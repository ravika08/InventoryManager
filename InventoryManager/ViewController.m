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

@interface ViewController ()

@property (nonatomic) DeviceStatus deviceStatus;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.deviceStatus=DeviceNotEnrolled;
    [self updateImageAndLabels];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)updateImageAndLabels{
    switch (self.deviceStatus) {
        case DeviceNotEnrolled:
        {
           
            [self.mainButton setImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
            self.headLineLabel.text=@"Not Enrolled";
            self.statusLabel.text=@"Select the button above to enroll device";
        }
            break;
        case DeviceAvailable:
        {
            [self.mainButton setImage:[UIImage imageNamed:@"available"] forState:UIControlStateNormal];
            self.headLineLabel.text=@"Available";
            self.statusLabel.text=@"Select the button above to check out device";
        }
            break;
        case DeviceCheckedOut:
        {
            [self.mainButton setImage:[UIImage imageNamed:@"checked-out"] forState:UIControlStateNormal];
            self.headLineLabel.text=@"Checked Out to 211156";
             self.statusLabel.text=@"Select the button above to check in device";
        }
            break;
        default:
            break;
    }
}

-(IBAction)mainImageSelected:(id)sender{
    switch (self.deviceStatus) {
        case DeviceNotEnrolled:
            [self alertForEnroll];
            self.deviceStatus=DeviceAvailable;
            break;
        case DeviceAvailable:
            [self alertForCheckOut];
            self.deviceStatus=DeviceCheckedOut;
            break;
        case DeviceCheckedOut:
            self.deviceStatus=DeviceAvailable;
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
    alert.shouldDismissOnTapOutside = YES;
    alert.backgroundType=Blur;
    alert.customViewColor=[UIColor flatYellowColor];
    [alert addTextField:@"UserID"];
    
    alert.attributedFormatBlock = ^NSAttributedString* (NSString *value)
    {
        NSMutableAttributedString *subTitle = [[NSMutableAttributedString alloc]initWithString:value];
        NSRange redRange = [value rangeOfString:value options:NSCaseInsensitiveSearch];
        [subTitle addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Avenir Next Condensed" size:17.0] range:redRange];
        
        return subTitle;
    };
    
    [alert showSuccess:self title:@"Check Out" subTitle:@"Enter Id of user checking out" closeButtonTitle:@"OK" duration:0.0f];
    
}


@end
