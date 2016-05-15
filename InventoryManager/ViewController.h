//
//  ViewController.h
//  InventoryManager
//
//  Created by ctsuser1 on 5/11/16.
//  Copyright © 2016 Cognizant. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property IBOutlet UIButton *mainButton;
@property IBOutlet UILabel *statusLabel;
@property IBOutlet UILabel *headLineLabel;
@property IBOutlet UIButton *deviceInfoButton;
@property IBOutlet UIButton *checkoutButton;

-(IBAction)mainImageSelected:(id)sender;


typedef NS_OPTIONS(NSInteger, DeviceStatus) {
    DeviceNotEnrolled = 0,
    DeviceAvailable = 1,
    DeviceCheckedOut = 2
    
};

@end

