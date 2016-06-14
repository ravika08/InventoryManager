//
//  RestAdapter.m
//  InventoryManager
//
//  Created by ctsuser1 on 5/16/16.
//  Copyright © 2016 Cognizant. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RestAdapter.h"
#import "Device.h"

@implementation RestAdapter:NSObject

NSString *const serverURL=@"http://localhost:8080/";
NSString *const enrollApi=@"api/devices";
NSString *const updateApi=@"api/devices";
NSString *const kDeviceStatusNotEnrolled=@"devicestatus.notEnrolled";
NSString *const kDeviceStatusEnrolled=@"deviceStatus.Enrolled";
NSString *const kDeviceUpdated=@"device.Updated";
NSString *const kDeviceEnrolled=@"device.Enrolled";
NSString *const kDeviceKey = @"DeviceKey";

#pragma mark - initialization of the RestAdapter singleton.
+(instancetype)sharedInstance {
    static dispatch_once_t pred;
    static RestAdapter *sharedInstance = nil;
    dispatch_once(&pred, ^{
        sharedInstance = [[RestAdapter alloc] init];
    });
    return sharedInstance;
}

-(instancetype)init{
    self = [super init];
    if(self) {
        self.defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
        self.defaultConfigObject.requestCachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
        self.defaultConfigObject.timeoutIntervalForRequest=5.0;
        self.defaultSession = [NSURLSession sessionWithConfiguration: self.defaultConfigObject delegate: self delegateQueue: [NSOperationQueue mainQueue]];
        
    }
    
    return self;
}

/**
 *  Returns the NSMutableURLRequest object for NSURLSessionDataTask
 *
 *  @param path String for which object should be created
 *
 *  @return NSMutableURLRequest
 */
-(NSMutableURLRequest *)getRequestForURL:(NSString *)path{
    
    NSURL *url = [NSURL URLWithString:[serverURL stringByAppendingPathComponent:path]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    return request;
}

-(void)checkDeviceStatus:(NSString *)deviceId{
   
    NSString *path=[NSString stringWithFormat:@"%@/%@",enrollApi,deviceId];
    NSLog(@"Path:%@",path);
    NSMutableURLRequest *request = [self getRequestForURL:path];
    [request setHTTPMethod:@"GET"];
    
    NSURLSessionDataTask *dataTask = [self.defaultSession dataTaskWithRequest:request
                                                            completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
                                                                NSHTTPURLResponse *httpResp = (NSHTTPURLResponse*) response;
                                                                if (!error) {
                                                                    if (httpResp.statusCode == 200) {
                                                                        NSError *jsonError;
                                                                        
                                                                        
                                                                        NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data
                                                                                                                                   options:NSJSONReadingAllowFragments error:&jsonError];
                                                                        NSLog(@"json:%@",jsonObject);
                                                                        if(![jsonObject isKindOfClass:[NSNull class]]){
                                                                            NSLog(@"not null");
                                                                            Device *device = [[Device alloc] initWithDictionary:jsonObject];
                                                                            NSDictionary *userInfo = @{kDeviceKey:device};
                                                                            [[NSNotificationCenter defaultCenter] postNotificationName:kDeviceStatusEnrolled
                                                                                                                                object:self
                                                                                                                              userInfo:userInfo];
                                                                            NSLog(@"Device Enrolled notification sent");
                                                                            
                                                                        
                                                                        }else{
                                                                            //null means device not enrolled
                                                                            [[NSNotificationCenter defaultCenter] postNotificationName:kDeviceStatusNotEnrolled
                                                                                                                                object:self
                                                                                                                              userInfo:nil];
                                                                            NSLog(@"Device Not enrolled notification sent");
                                                                        }
                                                                    }
                                                                }
                                                            }];
    
    [dataTask resume];
    
}



-(void) enrollDevice:(Device *)device{
    
    NSMutableURLRequest *request = [self getRequestForURL:enrollApi];
    [request setHTTPMethod:@"POST"];
    NSLog(@"Enroll Device:%@",request);
    request.HTTPBody = [NSJSONSerialization dataWithJSONObject:[device dictionary] options:kNilOptions error:nil];
    NSURLSessionDataTask *dataTask = [self.defaultSession dataTaskWithRequest:request
                                                            completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
                                                                NSHTTPURLResponse *httpResp = (NSHTTPURLResponse*) response;
                                                                if (!error) {
                                                                    NSLog(@"reponse:%ld",(long)httpResp.statusCode);
                                                                    if (httpResp.statusCode == 200) {
                                                                        NSError *jsonError;

                                                                        NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data
                                                                                                                                   options:NSJSONReadingAllowFragments error:&jsonError];
                                                                //send device enrolled success note
                                                                        Device *device = [[Device alloc] initWithDictionary:jsonObject];
                                                                        NSDictionary *userInfo = @{kDeviceKey:device};
                                                                        [[NSNotificationCenter defaultCenter] postNotificationName:kDeviceEnrolled
                                                                                                                            object:self
                                                                                                                          userInfo:userInfo];
                                                                        
                                                                    }
                                                                }
                                                            }];
    
    [dataTask resume];
    
}


-(void) updateDeviceForUser:(NSString *)userId withStatus:(NSString *)status{
    
    NSString *deviceId=[[Device sharedInstance] deviceIdentifier];
    NSString *path=[NSString stringWithFormat:@"%@/%@",enrollApi,deviceId];
    NSLog(@"Path:%@",path);
    NSMutableURLRequest *request = [self getRequestForURL:path];
    [request setHTTPMethod:@"PUT"];
    Device *device=[[Device alloc]init];
    device.name=[[Device sharedInstance] devicePlatformString];
    device.os=[NSString stringWithFormat:@"iOS %@",[[Device sharedInstance] deviceOSVersion]];
    device.deviceId=[[Device sharedInstance] deviceIdentifier];
    device.status=status;
    device.user=userId;
    NSDictionary *bodyDict = [NSDictionary dictionaryWithObjectsAndKeys:
                              device.name, @"name",
                              device.os, @"os",
                              device.deviceId,@"deviceId",
                              device.status,@"status",
                              device.user,@"user",
                              nil];
    request.HTTPBody = [NSJSONSerialization dataWithJSONObject:bodyDict options:kNilOptions error:nil];
    NSURLSessionDataTask *dataTask = [self.defaultSession dataTaskWithRequest:request
                                                            completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
                                                                NSHTTPURLResponse *httpResp = (NSHTTPURLResponse*) response;
                                                                if (!error) {
                                                                    if (httpResp.statusCode == 200) {
                                                                        NSError *jsonError;
                                                                        
                                                                        NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data
                                                                                                                                   options:NSJSONReadingAllowFragments error:&jsonError];
                                                                        
                                                                        Device *device = [[Device alloc] initWithDictionary:jsonObject];
                                                                        NSDictionary *userInfo = @{kDeviceKey:device};

                                                                        //send device updated success note
                                                                        [[NSNotificationCenter defaultCenter] postNotificationName:kDeviceUpdated
                                                                                                                            object:self
                                                                                                                          userInfo:userInfo];
                                                                        
                                                                    }
                                                                }
                                                            }];
    
    [dataTask resume];

    
}


@end