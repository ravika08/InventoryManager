//
//  Device.h
//  InventoryManager
//
//  Created by ctsuser1 on 5/16/16.
//  Copyright © 2016 Cognizant. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Device : NSObject

@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *os;
@property (nonatomic,strong) NSString *user;
@property (nonatomic,strong) NSString *deviceId;
@property (nonatomic,strong) NSString *status;
@property (nonatomic,strong) NSString *_id;
@property (nonatomic,strong) NSString *__v;
@property (nonatomic,strong) NSString *location;
@property (nonatomic,strong) NSString *category;
@property (nonatomic,strong) NSString *imei;
@property (nonatomic,strong) NSString *macAddress;
@property (nonatomic,strong) NSString *serialNumber;
@property (nonatomic,strong) NSString *screenResolution;
@property (nonatomic,strong) NSString *cloudType;
@property (nonatomic,strong) NSNumber *hours;
@property (nonatomic,strong) NSString *lastUpdated_at;

+(instancetype)sharedInstance;

-(NSString *)deviceIdentifier;
-(NSString *)deviceOSVersion;
-(NSString *)devicePlatformString;
-(instancetype)initWithDictionary:(NSDictionary *)dict;
-(NSDictionary *)dictionary;
@end