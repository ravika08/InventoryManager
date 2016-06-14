//
//  EnrollDeviceDetailViewController.h
//  InventoryManager
//
//  Created by ctsuser1 on 5/19/16.
//  Copyright © 2016 Cognizant. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface EnrollDeviceDetailViewController : UIViewController<UITextFieldDelegate>

@property IBOutlet UILabel *makeModelLabel;
@property IBOutlet UILabel *osVersionLabel;
@property IBOutlet UITextField *locationTextField;
@property IBOutlet UITextField *imeiTextField;
@property IBOutlet UITextField *macaddressTextField;
@property IBOutlet UITextField *serialNoTextField;
@property IBOutlet UITextField *screeresolutionTextField;
@property IBOutlet UITextField *deviceIDTextField;
@property IBOutlet UITextField *categoryTextField;
@property IBOutlet UITextField *cloudTypeTextField;
@end