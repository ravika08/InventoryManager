//
//  ScanViewController.m
//  InventoryManager
//
//  Created by ctsuser1 on 5/13/16.
//  Copyright © 2016 Cognizant. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "ScanViewController.h"
#import "Chameleon.h"


@interface ScanViewController () <AVCaptureMetadataOutputObjectsDelegate>
{
    AVCaptureSession *_session;
    AVCaptureDevice *_device;
    AVCaptureDeviceInput *_input;
    AVCaptureMetadataOutput *_output;
    AVCaptureVideoPreviewLayer *_prevLayer;
    
    UIView *_highlightView;
    
}


@property (assign, nonatomic) BOOL canSendBarcodeToDelegate;
@property (assign, nonatomic) BOOL isCameraMultiScanLocked;
@end

@implementation ScanViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupHighlightView];
    
    
    //this is bottom toolbar that's part of the navigation controller.
    
    UITapGestureRecognizer *tapToFocusRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToFocus:)];
    [tapToFocusRecognizer setNumberOfTapsRequired:1];
    [tapToFocusRecognizer setNumberOfTouchesRequired:1];
    [self.view addGestureRecognizer:tapToFocusRecognizer];
    
    
    _session = [[AVCaptureSession alloc] init];
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error = nil;
    
    _input = [AVCaptureDeviceInput deviceInputWithDevice:_device error:&error];
    if (_input) {
        [_session addInput:_input];
    } else {
        NSLog(@"AVCaputerDeviceInput Error: %@", error);
    }
    
    _output = [[AVCaptureMetadataOutput alloc] init];
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    [_session addOutput:_output];
    
    _output.metadataObjectTypes = [_output availableMetadataObjectTypes];
    
    _prevLayer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
    _prevLayer.frame = self.view.bounds;
    
    _prevLayer.videoGravity = AVLayerVideoGravityResize;
    
    if([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeLeft) {
        _prevLayer.connection.videoOrientation = (AVCaptureVideoOrientation)UIInterfaceOrientationLandscapeRight;
        
    } else if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeRight) {
        _prevLayer.connection.videoOrientation = (AVCaptureVideoOrientation)UIInterfaceOrientationLandscapeLeft;
    }
    
    [self.view.layer insertSublayer:_prevLayer atIndex:0];
    [self addOverlayImage];
}

-(void)setupHighlightView {
    _highlightView = [[UIView alloc] init];
    _highlightView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin;
    _highlightView.layer.borderColor = [UIColor greenColor].CGColor;
    _highlightView.layer.borderWidth = 3;
    [self.view addSubview:_highlightView];
}

-(void)tapToFocus:(UITapGestureRecognizer *)singleTap{
    //dismiss keyboard if trying to focus...
        //get the touch point
    CGPoint touchPoint = [singleTap locationInView:self.view];
    CGPoint convertedPoint = [_prevLayer captureDevicePointOfInterestForPoint:touchPoint];
    
    //do the focus.
    if([_device isFocusPointOfInterestSupported] && [_device isFocusModeSupported:AVCaptureFocusModeAutoFocus]){
        NSError *error = nil;
        [_device lockForConfiguration:&error];
        if(!error){
            [_device setFocusPointOfInterest:convertedPoint];
            [_device setFocusMode:AVCaptureFocusModeAutoFocus];
            [_device unlockForConfiguration];
            //            NSLog(@"Focusing camera on point %@",NSStringFromCGPoint(convertedPoint));
        }
    }
    
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [_session startRunning];
    self.canSendBarcodeToDelegate = YES;
}


-(void)viewWillDisappear:(BOOL)animated {
    
    [_session stopRunning];
    
    [super viewWillDisappear:animated];
}


-(void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
        
        _prevLayer.connection.videoOrientation = (AVCaptureVideoOrientation)orientation;
        _prevLayer.frame = self.view.bounds;
        
    } completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
    }];
    
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    //iOS AVCaputure may call this delegate method at will for a sigle barcode scan,
    //we only need to inform the CamerasCanner delegate once per user initiated scan.
    if(self.canSendBarcodeToDelegate == NO) {
        NSLog(@"Camera - these are not the barcodes you're looking for...");
        return;
    }
    NSLog(@"Camera - avcapture got metadata, can send bardcode to delegate is YES, processing barcode metadata...");
    
    CGRect highlightViewRect = CGRectZero;
    AVMetadataMachineReadableCodeObject *barCodeObject;
    NSString *detectionString = nil;
    NSArray *barCodeTypes = @[AVMetadataObjectTypeUPCECode,
                              AVMetadataObjectTypeCode39Code,
                              AVMetadataObjectTypeCode39Mod43Code,
                              AVMetadataObjectTypeEAN13Code,
                              AVMetadataObjectTypeEAN8Code,
                              AVMetadataObjectTypeCode93Code,
                              AVMetadataObjectTypeCode128Code,
                              AVMetadataObjectTypePDF417Code,
                              AVMetadataObjectTypeQRCode,
                              AVMetadataObjectTypeAztecCode];
    
    for (AVMetadataObject *metadata in metadataObjects) {
        for (NSString *type in barCodeTypes) {
            if ([metadata.type isEqualToString:type]) {
                
                barCodeObject = (AVMetadataMachineReadableCodeObject *)[_prevLayer transformedMetadataObjectForMetadataObject:
                                                                        (AVMetadataMachineReadableCodeObject *)metadata];
                highlightViewRect = barCodeObject.bounds;
                detectionString = [(AVMetadataMachineReadableCodeObject *)metadata stringValue];
                break;
            }
        }
        
        if (detectionString != nil) {
            
            NSString *trimmedBarcode = [detectionString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            
            if(trimmedBarcode.length > 0) {
                
                _barcode = trimmedBarcode;
                    self.canSendBarcodeToDelegate = NO;
               
            }
            break;
        }
    }
    
    _highlightView.frame = highlightViewRect;
}

-(void) addOverlayImage{
    CGRect overlayRect = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, _prevLayer.bounds.size.width, _prevLayer.bounds.size.height);
    UIView *overlayView = [[UIView alloc] initWithFrame:overlayRect];
    overlayView.tag=13;
    UIImageView *overlayImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"focus"]];
    overlayImage.image = [overlayImage.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    overlayImage.center=overlayView.center;
    //overlayImage.alpha = 0.5;
    [overlayImage setTintColor:[UIColor flatWhiteColorDark]];
    [overlayView addSubview:overlayImage];
    
    [self.view addSubview:overlayView];
    [self.view layoutIfNeeded];
}


-(BOOL)isLocked {
    BOOL locked = self.isCameraMultiScanLocked;
    
    return locked;
}

-(void)setLocked:(BOOL)isLocked {
    
    self.isCameraMultiScanLocked = isLocked;
}

@end
