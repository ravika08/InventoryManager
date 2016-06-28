//
//  DeviceInfoViewController.h
//  InventoryManager
//
//  Created by ctsuser1 on 5/12/16.
//  Copyright © 2016 Cognizant. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Device.h"

@interface DeviceInfoViewController : UIViewController

@property IBOutlet UIImageView *qrCodeImage;
@property IBOutlet UILabel *deviceIDLabel;
@property IBOutlet UILabel *devInfoLabel;
@property IBOutlet UILabel *devLocationLabel;
@property IBOutlet UILabel *devCloudTypeLabel;
@property IBOutlet UILabel *devClientLabel;
@property IBOutlet UILabel *checkedOutLabel;


-(IBAction)selectUpdateDevice:(id)sender;

@property NSNotificationCenter *noteCenter;

@property (nonatomic,strong) Device *device;
@end