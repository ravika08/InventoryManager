//
//  LoginViewController.m
//  InventoryManager
//
//  Created by ctsuser1 on 5/12/16.
//  Copyright © 2016 Cognizant. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoginViewController.h"
#import "ViewController.h"

#define kOFFSET_FOR_KEYBOARD 80.0

@implementation LoginViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    CALayer *border = [CALayer layer];
    CGFloat borderWidth = 1;
    border.borderColor = [UIColor lightGrayColor].CGColor;
    border.frame = CGRectMake(0, self.userIdField.frame.size.height - borderWidth, self.userIdField.frame.size.width, self.userIdField.frame.size.height);
    border.borderWidth = borderWidth;
    [self.userIdField.layer addSublayer:border];
    self.userIdField.layer.masksToBounds = YES;
    
    CALayer *borderPass = [CALayer layer];
    //CGFloat borderWidth = 2;
    borderPass.borderColor = [UIColor lightGrayColor].CGColor;
    borderPass.frame = CGRectMake(0, self.passwordField.frame.size.height - borderWidth, self.passwordField.frame.size.width, self.passwordField.frame.size.height);
    borderPass.borderWidth = borderWidth;
    [self.passwordField.layer addSublayer:borderPass];
    self.passwordField.layer.masksToBounds = YES;
    //userIdField.translatesAutoresizingMaskIntoConstraints = NO;
    NSLog(@"Test");
}



-(IBAction)loginButtonAction:(id)sender{
 
   [ self dismissViewControllerAnimated:YES completion:^{
       
   }];
}

@end