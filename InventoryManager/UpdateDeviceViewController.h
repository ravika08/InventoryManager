//
//  UpdateDeviceViewController.h
//  InventoryManager
//
//  Created by ctsuser1 on 6/27/16.
//  Copyright © 2016 Cognizant. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Device.h"

@interface UpdateDeviceViewController : UIViewController<UITextFieldDelegate>

@property IBOutlet UITextField *locationTextField;
@property IBOutlet UITextField *cloudTypeTextField;
@property IBOutlet UITextField *clientTextField;
@property IBOutlet UITextField *osversionTextField;

@property (nonatomic,strong) Device *device;

-(IBAction)updateDeviceSelected:(id)sender;

-(IBAction)dismissAction:(id)sender;

@end