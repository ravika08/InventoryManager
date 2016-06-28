//
//  AppDelegate.m
//  InventoryManager
//
//  Created by ctsuser1 on 5/11/16.
//  Copyright © 2016 Cognizant. All rights reserved.
//
#import "EnrollDeviceDetailViewController.h"
#import "AppDelegate.h"
#import "Constants.h"

@interface AppDelegate ()

@property (nonatomic) BOOL isLoggedIn;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.isLoggedIn=FALSE;
    [self initializeUserDefaults];
    if(!self.isLoggedIn){
      
        [self.window makeKeyAndVisible];
        
        
        UIStoryboard *loginStoryBoard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
        
        UIViewController *login = [loginStoryBoard instantiateInitialViewController];
        login.modalPresentationStyle=UIModalPresentationFullScreen;
        login.modalTransitionStyle=UIModalTransitionStyleFlipHorizontal;
        [[self topViewController] presentViewController:login animated:YES completion:^{
            
        }];

        
    }
    return YES;
}

-(void)presentEnrollDetailModal{
    [self.window makeKeyAndVisible];
    
    
    UIStoryboard *enrollStoryBoard = [UIStoryboard storyboardWithName:@"Enroll" bundle:nil];
    
    UIViewController *enroll = [enrollStoryBoard instantiateInitialViewController];
    enroll.modalPresentationStyle=UIModalPresentationFullScreen;
    enroll.modalTransitionStyle=UIModalTransitionStyleCoverVertical;
    [[self topViewController] presentViewController:enroll animated:YES completion:^{
        
    }];

    
}

-(void)presentUpdateDeviceModal{
    
    [self.window makeKeyAndVisible];
    
    UIStoryboard *updateStoryBoard = [UIStoryboard storyboardWithName:@"Update" bundle:nil];
    UIViewController *update = [updateStoryBoard instantiateInitialViewController];
    update.modalPresentationStyle=UIModalPresentationFullScreen;
    update.modalTransitionStyle=UIModalTransitionStyleCoverVertical;
    [[self topViewController] presentViewController:update animated:YES completion:^{
        
    }];

}

-(void)initializeUserDefaults {
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle]infoDictionary];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSDictionary *appDefaults = @{kServerURLKey:kDefaultServerURL
                                  };
    [userDefaults registerDefaults:appDefaults];
    [userDefaults synchronize];
    
    
}


- (UIViewController *)topViewController{
    return [self topViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
}

- (UIViewController *)topViewController:(UIViewController *)rootViewController
{
    if (rootViewController.presentedViewController == nil) {
        return rootViewController;
    }
    
    if ([rootViewController.presentedViewController isMemberOfClass:[UINavigationController class]]) {
        UINavigationController *navigationController = (UINavigationController *)rootViewController.presentedViewController;
        UIViewController *lastViewController = [[navigationController viewControllers] lastObject];
        return [self topViewController:lastViewController];
    }
    
    UIViewController *presentedViewController = (UIViewController *)rootViewController.presentedViewController;
    return [self topViewController:presentedViewController];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
