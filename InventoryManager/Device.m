//
//  Device.m
//  InventoryManager
//
//  Created by ctsuser1 on 5/16/16.
//  Copyright © 2016 Cognizant. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Device.h"
#import "UIDeviceHardware.h"
#import <UIKit/UIKit.h>


@implementation Device

+(instancetype)sharedInstance {
    static dispatch_once_t pred;
    static Device *sharedInstance = nil;
    dispatch_once(&pred, ^{
        sharedInstance = [[Device alloc] init];
    });
    return sharedInstance;
}

-(instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

-(NSString *)deviceIdentifier{
    return [[[UIDevice currentDevice] identifierForVendor] UUIDString];
}

-(NSString *)deviceOSVersion{
    
    return [UIDevice currentDevice].systemVersion;
}

-(NSString *)devicePlatformString{
    
    return [UIDeviceHardware platformString];
}

-(NSDictionary *)dictionary{
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setValue:self.deviceId forKey:@"deviceId"];
    [dictionary setValue:self.name forKey:@"name"];
    [dictionary setValue:self.status forKey:@"status"];
    [dictionary setValue:self.user forKey:@"user"];
    [dictionary setValue:self.name forKey:@"name"];
    [dictionary setValue:self.os forKey:@"os"];
    [dictionary setValue:self.location forKey:@"location"];
    [dictionary setValue:self.category forKey:@"category"];
    [dictionary setValue:self.imei forKey:@"imei"];
    [dictionary setValue:self.serialNumber forKey:@"serialNumber"];
    [dictionary setValue:self.macAddress forKey:@"macAddress"];
    [dictionary setValue:self.screenResolution forKey:@"screenResolution"];
    [dictionary setValue:self.cloudType forKey:@"cloudType"];
    [dictionary setValue:self.osversion forKey:@"osversion"];
    [dictionary setValue:self.client forKey:@"client"];
    [dictionary setValue:self.assetID forKey:@"assetID"];
    return dictionary;
}


@end