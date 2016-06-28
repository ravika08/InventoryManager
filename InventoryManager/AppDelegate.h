//
//  AppDelegate.h
//  InventoryManager
//
//  Created by ctsuser1 on 5/11/16.
//  Copyright © 2016 Cognizant. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

-(void)presentEnrollDetailModal;

-(void)presentUpdateDeviceModal;

@end

