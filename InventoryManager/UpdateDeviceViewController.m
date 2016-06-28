//
//  UpdateDeviceViewController.m
//  InventoryManager
//
//  Created by ctsuser1 on 6/27/16.
//  Copyright © 2016 Cognizant. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UpdateDeviceViewController.h"
#import "RestAdapter.h"

@implementation UpdateDeviceViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    self.device = [[Device alloc]init];
}

-(IBAction)updateDeviceSelected:(id)sender{
    
    self.device.location= self.locationTextField.text;
    self.device.client = self.clientTextField.text;
    self.device.cloudType = self.cloudTypeTextField.text;
    self.device.osversion = self.osversionTextField.text;
    
    //Restadapter call to update device
    [[RestAdapter sharedInstance] updateDeviceDetails:self.device];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    
}

-(IBAction)dismissAction:(id)sender{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

@end