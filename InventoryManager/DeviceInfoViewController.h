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

@property IBOutlet UILabel *checkedOutLabel;

@property (nonatomic,strong) Device *device;
@end