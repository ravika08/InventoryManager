//
//  ViewController.m
//  InventoryManager
//
//  Created by ctsuser1 on 5/11/16.
//  Copyright © 2016 Cognizant. All rights reserved.
//

#import "ViewController.h"
#import "SCLAlertView.h"
#import "Chameleon.h"
#import "RestAdapter.h"
#import "Device.h"
#import "AppDelegate.h"
#import "DeviceInfoViewController.h"

@interface ViewController ()

@property (nonatomic) DeviceStatus deviceStatus;
@property NSString *userId;
@property NSNotificationCenter *noteCenter;
@property (nonatomic,strong) Device *device;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self registerForNotifications];
    NSString *deviceId=[[Device sharedInstance] deviceIdentifier];
    [[RestAdapter sharedInstance] checkDeviceStatus:deviceId];
}

-(void)registerForNotifications{
    
    RestAdapter *restAdapter = [RestAdapter sharedInstance];
    self.noteCenter = [NSNotificationCenter defaultCenter];
    
    [self.noteCenter addObserver:self
                        selector:@selector(handleDeviceStatusNotEnrolled:)
                            name:kDeviceStatusNotEnrolled
                          object:restAdapter];
    [self.noteCenter addObserver:self
                        selector:@selector(handleDeviceStatusEnrolled:)
                            name:kDeviceStatusEnrolled
                          object:nil];
    [self.noteCenter addObserver:self
                   selector:@selector(handleDeviceEnrolled:)
                       name:kDeviceEnrolled
                     object:nil];
    [self.noteCenter addObserver:self
                   selector:@selector(handleDeviceStatusUpdated:)
                       name:kDeviceUpdated
                     object:nil];

}

-(void)viewDidAppear:(BOOL)animated{
    
    
    
}

-(void)viewDidDisappear:(BOOL)animated{
    NSLog(@"View disappear");
    [self.noteCenter removeObserver:self];
}

-(void)handleDeviceStatusNotEnrolled:(NSNotification *)responseNote{
    
    NSLog(@"Device Status Not Enrolled in view controller");
    self.deviceStatus=DeviceNotEnrolled;
    [self updateImageAndLabels];
}

-(void)handleDeviceStatusEnrolled:(NSNotification *)responseNote{
    
    NSLog(@"Device Status Enrolled view controller");
    self.device = [responseNote.userInfo valueForKey:kDeviceKey];
    if([self.device.status isEqualToString:@"available"]){
        NSLog(@"Device Available");
        self.deviceStatus=DeviceAvailable;
    }
    if([self.device.status isEqualToString:@"checkedOut"]){
        NSLog(@"Device checked out");
        self.deviceStatus=DeviceCheckedOut;
        self.userId=self.device.user;
        
    }
    [self updateImageAndLabels];
}

-(void)handleDeviceEnrolled:(NSNotification *)responseNote{
    [self alertForEnroll];
    self.deviceStatus=DeviceAvailable;
    [self updateImageAndLabels];
    NSLog(@"Device Enrolled");
}

-(void)handleDeviceStatusUpdated:(NSNotification *)responseNote{
    [self alertForUpdate];
    self.device = [responseNote.userInfo valueForKey:kDeviceKey];
    if([self.device.status isEqualToString:@"available"]){
        NSLog(@"Device Available");
        self.deviceStatus=DeviceAvailable;
    }
    if([self.device.status isEqualToString:@"checkedOut"]){
        NSLog(@"Device checked out");
        self.deviceStatus=DeviceCheckedOut;
        self.userId=self.device.user;
        
    }
    [self updateImageAndLabels];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([[segue identifier] isEqualToString:@"devInfoSegueE"])
    {
        
        DeviceInfoViewController *vc = [segue destinationViewController];
        
        // Pass any objects to the view controller here, like...
        vc.device=self.device;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)updateImageAndLabels{
    NSLog(@"Update image and labels");
    switch (self.deviceStatus) {
        case DeviceNotEnrolled:
        {
           
            [self.mainButton setImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
            self.headLineLabel.text=@"Not Enrolled";
            self.statusLabel.text=@"Select the button above to enroll device";
            self.usageHoursLabel.hidden=YES;
        }
            break;
        case DeviceAvailable:
        {
            [self.mainButton setImage:[UIImage imageNamed:@"available"] forState:UIControlStateNormal];
            self.headLineLabel.text=@"Available";
            self.statusLabel.text=@"Select the button above to check out device";
            self.usageHoursLabel.hidden=YES;
            if (self.usageTimer != nil) {
            [self.usageTimer invalidate];
            self.usageTimer=nil;
            }
        }
            break;
        case DeviceCheckedOut:
        {
            [self.mainButton setImage:[UIImage imageNamed:@"checked-out"] forState:UIControlStateNormal];
            self.headLineLabel.text=[NSString stringWithFormat:@"Checked Out to %@",self.userId];
             self.statusLabel.text=@"Select the button above to check in device";
            NSDateFormatter *dateFormat = [NSDateFormatter new];
            //correcting format to include seconds and decimal place
            dateFormat.dateFormat = @"yyyy'-'MM'-'dd'T'HH':'mm':'ss.SSSZ";
            // Always use this locale when parsing fixed format date strings
            NSLocale *posix = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
            [dateFormat setLocale:posix];
            self.lastUpdated = [dateFormat dateFromString:self.device.lastUpdated_at];
            self.usageHoursLabel.hidden=NO;
            self.usageTimer=[NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timerTick:) userInfo:nil repeats:YES];
            
        }
            break;
        default:
            break;
    }
}

-(void)timerTick:(NSTimer *)timer{
    
    NSDate *now = [NSDate date];
    
    NSTimeInterval distanceBetweenDates = [self.lastUpdated timeIntervalSinceDate:now];
    long seconds = lroundf(distanceBetweenDates); // Since modulo operator (%) below needs int or long
    int hour = (int)seconds / 3600;
    int mins = (seconds % 3600) / 60;
    int secs = seconds % 60;
    self.usageHoursLabel.text = [NSString stringWithFormat:@"Time Elapsed - %d : %d : %d",abs(hour), abs(mins),abs(secs)];
    
    
    
}

-(IBAction)mainImageSelected:(id)sender{
    switch (self.deviceStatus) {
        case DeviceNotEnrolled:
        {
            NSLog(@"Enroll Device method call");
             [(AppDelegate *)[[UIApplication sharedApplication] delegate] presentEnrollDetailModal];
             
           
        }
            break;
        case DeviceAvailable:
        {
            [self alertForCheckOut];
            
        }
            break;
        case DeviceCheckedOut:
        {
            [[RestAdapter sharedInstance] updateDeviceForUser:@"admin" withStatus:@"available"];
        }
            break;
        default:
            break;
    }
    
    [self updateImageAndLabels];
}

-(void)alertForEnroll{
    
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
    
    [alert showSuccess:self title:@"Success" subTitle:@"Successfully Enrolled Device to Inventory" closeButtonTitle:@"OK" duration:0.0f];


}

-(void)alertForCheckOut{
    
    SCLAlertView *alert = [[SCLAlertView alloc] init];
    [alert setHorizontalButtons:YES];
    alert.shouldDismissOnTapOutside = YES;
    alert.backgroundType=Blur;
    alert.customViewColor=[UIColor flatYellowColor];
    UITextField *textField=[alert addTextField:@"UserID"];
    
    alert.attributedFormatBlock = ^NSAttributedString* (NSString *value)
    {
        NSMutableAttributedString *subTitle = [[NSMutableAttributedString alloc]initWithString:value];
        NSRange redRange = [value rangeOfString:value options:NSCaseInsensitiveSearch];
        [subTitle addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Avenir Next Condensed" size:17.0] range:redRange];
        
        return subTitle;
    };
    [alert addButton:@"Check Out" actionBlock:^(void) {
        NSLog(@"Second button tapped");
        NSString *userId=textField.text;
        [[RestAdapter sharedInstance] updateDeviceForUser:userId withStatus:@"checkedOut"];
    }];
    
    [alert showSuccess:self title:@"Check Out" subTitle:@"Enter Id of user checking out" closeButtonTitle:@"Cancel" duration:0.0f];
    
}

-(void)alertForUpdate{
    
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
    
}


@end
