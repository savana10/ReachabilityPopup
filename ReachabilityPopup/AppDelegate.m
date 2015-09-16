//
//  AppDelegate.m
//  ReachabilityPopup
//
//  Created by Savana on 16/09/15.
//  Copyright (c) 2015 Savana. All rights reserved.
//

#import "AppDelegate.h"
#import "Reachability.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

Reachability *reachable;
UIView *noNetView;
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    reachable =[Reachability reachabilityWithHostName:@"www.parse.com"];
    [reachable startNotifier];
    
    return YES;
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

- (void) reachabilityChanged:(NSNotification *)note
{
    NetworkStatus status = reachable.currentReachabilityStatus;
    BOOL connectionRequired = [reachable connectionRequired];
    switch (status)
    {
        case NotReachable:        {
            NSLog(@"N/A");
            connectionRequired = NO;
            [self displayOrHideStatus:true];
            break;
        }
        case ReachableViaWWAN:        {
            NSLog(@"Reachable WWAN");
            break;
        }
        case ReachableViaWiFi:        {
            break;
        }
    }
    if (connectionRequired)
    {
        NSLog(@"may require vpn");
    }
    
}
-(void) displayOrHideStatus:(BOOL) display
{
    if (display) {
        if (noNetView == nil) {
            noNetView = [[UIView alloc]  initWithFrame:CGRectMake(0, self.window.frame.size.height, self.window.frame.size.width, 40)];
            UILabel *noStausLbl = [[UILabel alloc]  initWithFrame:CGRectMake(10, 0, noNetView.frame.size.width, noNetView.frame.size.height)];
            [noStausLbl setTextColor:[UIColor whiteColor]];
            [noStausLbl setText:@"No Connection."];
            [noStausLbl setFont:[UIFont fontWithName:@"Roboto Bold" size:14]];
            [noStausLbl setTag:1];
            [noNetView addSubview:noStausLbl];
            [noNetView setBackgroundColor:[UIColor colorWithWhite:0.173 alpha:1.000]];
        }
        [self.window addSubview:noNetView];
        [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            [noNetView setFrame:CGRectMake(0, self.window.frame.size.height-40, self.window.frame.size.width, 40)];
        } completion:^(BOOL finished) {
            [self performSelector:@selector(displayOrHideStatus:) withObject:false afterDelay:2];
        }];
        
    }else{
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            [noNetView setFrame:CGRectMake(0, self.window.frame.size.height, self.window.frame.size.width, 40)];
        } completion:^(BOOL finished) {
            [noNetView removeFromSuperview];
        }];
    }
}
@end

