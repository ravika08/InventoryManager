//
//  DeviceInfoViewController.m
//  InventoryManager
//
//  Created by ctsuser1 on 5/12/16.
//  Copyright © 2016 Cognizant. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DeviceInfoViewController.h"
#import "Device.h"
#import "AppDelegate.h"
#import "RestAdapter.h"
#import "SCLAlertView.h"
#import "Chameleon.h"

@implementation DeviceInfoViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    [self updateView];
    
}

-(void)updateView{
    NSString* Identifier = [[Device sharedInstance] deviceIdentifier]; // IOS 6+
    CIImage *qrCode = [self createQRForString:Identifier];
    NSString *OSVersion = [[Device sharedInstance] deviceOSVersion];
    NSString *platformString = [[Device sharedInstance] devicePlatformString];
    NSLog(@"Device:%@",[self.device dictionary]);
    [self updateStatusLabel];
    // Convert to an UIImage
    UIImage *qrCodeImg = [self createNonInterpolatedUIImageFromCIImage:qrCode withScale:2*[[UIScreen mainScreen] scale]];
    
    [self.qrCodeImage setImage:qrCodeImg];
    [self.deviceIDLabel setText:[NSString stringWithFormat:@"Device Id:%@",Identifier]];
    [self.devInfoLabel setText:[NSString stringWithFormat:@"%@ iOS %@ ",platformString,OSVersion]];
    [self.devLocationLabel setText:[NSString stringWithFormat:@"Location:%@",self.device.location?:@""]];
    [self.devClientLabel setText:[NSString stringWithFormat:@"Client:%@",self.device.client?:@""]];
    [self.devCloudTypeLabel setText:[NSString stringWithFormat:@"Cloud Type:%@",self.device.cloudType?:@""]];
}

-(void)updateStatusLabel{
    if([self.device.status isEqualToString:@"checkedOut"]){
        self.checkedOutLabel.text =[NSString stringWithFormat:@"Device checked out to %@",self.device.user];
        self.checkedOutLabel.textColor = [UIColor flatBlackColor];

    }else if([self.device.status isEqualToString:@"available"]){
        self.checkedOutLabel.text = @"Device Enrolled and available for check-out";
        self.checkedOutLabel.textColor = [UIColor flatBlackColor];
    }else{
        self.checkedOutLabel.text = @"Device Not Enrolled!";
        self.checkedOutLabel.textColor = [UIColor flatRedColor];
       
    }
    
}

-(void)viewDidAppear:(BOOL)animated{
    
    self.noteCenter = [NSNotificationCenter defaultCenter];
    [self.noteCenter addObserver:self
                        selector:@selector(handleDeviceStatusUpdated:)
                            name:kDeviceUpdated
                          object:nil];
}

-(void)viewDidDisappear:(BOOL)animated{
    
    [self.noteCenter removeObserver:self];
}

- (CIImage *)createQRForString:(NSString *)qrString {
    NSData *stringData = [qrString dataUsingEncoding: NSISOLatin1StringEncoding];
    
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [qrFilter setValue:stringData forKey:@"inputMessage"];
    
    return qrFilter.outputImage;
}

- (UIImage *)createNonInterpolatedUIImageFromCIImage:(CIImage *)image withScale:(CGFloat)scale
{
    // Render the CIImage into a CGImage
    CGImageRef cgImage = [[CIContext contextWithOptions:nil] createCGImage:image fromRect:image.extent];
    
    // Now we'll rescale using CoreGraphics
    UIGraphicsBeginImageContext(CGSizeMake(image.extent.size.width * scale, image.extent.size.width * scale));
    CGContextRef context = UIGraphicsGetCurrentContext();
    // We don't want to interpolate (since we've got a pixel-correct image)
    CGContextSetInterpolationQuality(context, kCGInterpolationNone);
    CGContextDrawImage(context, CGContextGetClipBoundingBox(context), cgImage);
    // Get the image out
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // Tidy up
    UIGraphicsEndImageContext();
    CGImageRelease(cgImage);
    return scaledImage;
}

-(IBAction)selectUpdateDevice:(id)sender{
    if([self.device.status isEqualToString:@"checkedOut"] || [self.device.status isEqualToString:@"available"]){
    
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] presentUpdateDeviceModal];
    }else{
        NSLog(@"Else in button action");
        SCLAlertView *alert = [[SCLAlertView alloc] init];
        alert.shouldDismissOnTapOutside = YES;
        alert.backgroundType=Blur;
        alert.attributedFormatBlock = ^NSAttributedString* (NSString *value)
        {
            NSMutableAttributedString *subTitle = [[NSMutableAttributedString alloc]initWithString:value];
            NSRange redRange = [value rangeOfString:value options:NSCaseInsensitiveSearch];
            [subTitle addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Avenir Next Condensed" size:17.0] range:redRange];
            
            return subTitle;
        };
        
        [alert showError:self title:@"Not Enrolled!" subTitle:@"Please Enroll the device first" closeButtonTitle:@"Ok" duration:0.0f];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)handleDeviceStatusUpdated:(NSNotification *)responseNote{
    NSLog(@"Device status updated");
    self.device = [responseNote.userInfo objectForKey:kDeviceKey];
    SCLAlertView *alert = [[SCLAlertView alloc] init];
    alert.shouldDismissOnTapOutside = YES;
    alert.backgroundType=Blur;
    alert.customViewColor=[UIColor flatGreenColor];
    alert.attributedFormatBlock = ^NSAttributedString* (NSString *value)
    {
        NSMutableAttributedString *subTitle = [[NSMutableAttributedString alloc]initWithString:value];
        NSRange redRange = [value rangeOfString:value options:NSCaseInsensitiveSearch];
        [subTitle addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Avenir Next Condensed" size:17.0] range:redRange];
        
        return subTitle;
    };
    
    [alert showSuccess:self title:@"Success" subTitle:@"Device details updated" closeButtonTitle:@"OK" duration:0.0f];
    [self updateView];
}


@end