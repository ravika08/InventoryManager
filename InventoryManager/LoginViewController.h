//
//  LoginViewController.h
//  InventoryManager
//
//  Created by ctsuser1 on 5/12/16.
//  Copyright © 2016 Cognizant. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController<UITextFieldDelegate>

@property IBOutlet UITextField *userIdField;
@property IBOutlet UITextField *passwordField;
-(IBAction)loginButtonAction:(id)sender;
@end