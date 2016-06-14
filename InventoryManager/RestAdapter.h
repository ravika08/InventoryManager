//
//  RestAdapter.h
//  InventoryManager
//
//  Created by ctsuser1 on 5/16/16.
//  Copyright © 2016 Cognizant. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Device.h"

@interface RestAdapter :  NSObject <NSURLSessionDataDelegate>

@property (nonatomic,strong) NSURLSessionConfiguration *defaultConfigObject;
@property (nonatomic,strong) NSURLSession *defaultSession;

extern NSString *const serverURL;
extern NSString *const enrollApi;
extern NSString *const updateApi;
extern NSString *const kDeviceStatusNotEnrolled;
extern NSString *const kDeviceStatusEnrolled;
extern NSString *const kDeviceKey;
extern NSString *const kDeviceEnrolled;
extern NSString *const kDeviceUpdated;
+(instancetype)sharedInstance;

-(void)checkDeviceStatus:(NSString *)deviceId;
-(void) enrollDevice:(Device *)device;
-(void) updateDeviceForUser:(NSString *)userId withStatus:(NSString *)status;
@end