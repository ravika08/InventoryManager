//
//  EnrollDeviceDetailViewController.m
//  InventoryManager
//
//  Created by ctsuser1 on 5/19/16.
//  Copyright © 2016 Cognizant. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EnrollDeviceDetailViewController.h"
#import "Device.h"
#import "RestAdapter.h"

@implementation EnrollDeviceDetailViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    self.makeModelLabel.text=[[Device sharedInstance] devicePlatformString];
    self.osVersionLabel.text=[[Device sharedInstance] deviceOSVersion];
    self.deviceIDTextField.text=[[Device sharedInstance] deviceIdentifier];
    if([[[Device sharedInstance] devicePlatformString] containsString:@"iPad"]){
     self.categoryTextField.text=@"Tablet";
    }else{
        self.categoryTextField.text=@"Phone";
    }
    
}

- (IBAction)doneButtonAction:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:^{
    
    }];
}

- (IBAction)enrollButtonAction:(id)sender{
    Device *device = [[Device alloc]init];
    device.imei=self.imeiTextField.text;
    device.macAddress=self.macaddressTextField.text;
    device.location=self.locationTextField.text;
    device.screenResolution=self.screeresolutionTextField.text;
    device.serialNumber=self.serialNoTextField.text;
    device.category=self.categoryTextField.text;
    device.cloudType=self.cloudTypeTextField.text;
    device.name=[[Device sharedInstance] devicePlatformString];
    device.os=[NSString stringWithFormat:@"iOS %@",[[Device sharedInstance] deviceOSVersion]];
    device.deviceId=[[Device sharedInstance] deviceIdentifier];
    device.status=@"available";
    device.user=@"admin";
    [[RestAdapter sharedInstance] enrollDevice:device];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}



@end