//
//  ScanViewController.h
//  InventoryManager
//
//  Created by ctsuser1 on 5/13/16.
//  Copyright © 2016 Cognizant. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScanViewController : UIViewController<UITextFieldDelegate>

@property (strong, nonatomic, readonly) NSString *barcode;

@end