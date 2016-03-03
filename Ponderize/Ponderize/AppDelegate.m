//
//  AppDelegate.m
//  Ponderize
//
//  Created by Nathan Larson on 10/5/15.
//  Copyright © 2015 nathanlarson. All rights reserved.
//
//
//Credit for world icon used: <div>Icons made by <a href="http://www.freepik.com" title="Freepik">Freepik</a> from <a href="http://www.flaticon.com" title="Flaticon">www.flaticon.com</a>             is licensed by <a href="http://creativecommons.org/licenses/by/3.0/" title="Creative Commons BY 3.0">CC BY 3.0</a></div>

#import "AppDelegate.h"
#import "Connection.h"
#import "MyScriptureViewController.h"
#import "SignInViewController.h"



@interface AppDelegate ()<ConnectionDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    
    
    
    
    
    //Temporary
//    [[NSUserDefaults standardUserDefaults] setValue:nil forKey:@"user_id"];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [application setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];
    
    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]){
        
        [application registerUserNotificationSettings:[UIUserNotificationSettings
                                                       settingsForTypes:UIUserNotificationTypeAlert|
                                                       UIUserNotificationTypeSound categories:nil]];
    }
    
    [Connection connection].delegate = self;
    
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
    
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"currentScriptureReference"] != nil) {
        UIViewController *controller = self.window.rootViewController;
        
        MyScriptureViewController *viewController = [MyScriptureViewController new];
        
        [controller presentViewController:viewController animated:YES completion:nil];
    }else if ([[NSUserDefaults standardUserDefaults] valueForKey:@"user_id"]== nil){
        
        // set default 4 settings.
        [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"weeklyReminder"];
        [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"commentsOnMyPosts"];
        [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"groupPosts"];
        [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"groupComments"];
        
        
        // prompt for login account creation
        SignInViewController *viewController = [SignInViewController new];
        UIViewController *controller = self.window.rootViewController;
        [controller presentViewController:viewController animated:YES completion:nil];
        
    }
    
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)raiseNoInternetMessage
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"No Internet" message:@"Reconnect to the internet to use this application" preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        
    }]];
    
//    [self.window.rootViewController presentViewController:alert animated:YES completion:nil];
}

- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEEE"];
//    NSLog(@"%@", [dateFormatter stringFromDate:[NSDate date]]);
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"H"];
//    NSLog(@"%@", [dateFormat stringFromDate:[NSDate date]]);
    
    //weekly notification
    if ([[dateFormatter stringFromDate:[NSDate date]] isEqualToString:@"Sunday"] && [[[NSUserDefaults standardUserDefaults] valueForKey:@"shouldnotify"] isEqualToString:@"1"] && [[[NSUserDefaults standardUserDefaults] valueForKey:@"weeklyReminder"] isEqualToString:@"1"] && [[dateFormat stringFromDate:[NSDate date]] intValue] > 8 && [[dateFormat stringFromDate:[NSDate date]] intValue] < 23) {
        
        UILocalNotification *notification = [[UILocalNotification alloc] init];
        notification.fireDate = [NSDate dateWithTimeIntervalSinceNow:3];
        notification.alertBody = @"Don't forget to post your verse this week!";
        notification.timeZone = [NSTimeZone defaultTimeZone];
        notification.soundName = UILocalNotificationDefaultSoundName;
        
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
        [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:@"shouldnotify"];
    }else if (![[dateFormatter stringFromDate:[NSDate date]] isEqualToString:@"Sunday"]) {
        [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"shouldnotify"];
    }
    
    BOOL createNotification = NO;
    NSString *notificationText = @"";
    if ([[dateFormat stringFromDate:[NSDate date]] intValue] > 8 && [[dateFormat stringFromDate:[NSDate date]] intValue] < 23 && [[[NSUserDefaults standardUserDefaults] valueForKey:@"commentsOnMyPosts"] isEqualToString:@"1"]) {
        
        // just store the count of comments on my posts.
        NSString *count = [[Connection connection] getCountOfCommentsOnMyPosts];
        
        if ([[NSUserDefaults standardUserDefaults] valueForKey:@"countOfCommentsOnMyPosts"] == nil) {
            [[NSUserDefaults standardUserDefaults] setValue:count forKey:@"countOfCommentsOnMyPosts"];
        }else {
            int storedCount = [[[NSUserDefaults standardUserDefaults] valueForKey:@"countOfCommentsOnMyPosts"]intValue];
            int newCount = [count intValue];
            if (newCount > storedCount) {
                createNotification = YES;
                notificationText = [notificationText stringByAppendingString:@"New Comments"];
            }
            [[NSUserDefaults standardUserDefaults] setValue:count forKey:@"countOfCommentsOnMyPosts"];
        }
        

        
    }
    
    if ([[dateFormat stringFromDate:[NSDate date]] intValue] > 8 && [[dateFormat stringFromDate:[NSDate date]] intValue] < 23 && [[[NSUserDefaults standardUserDefaults] valueForKey:@"groupPosts"] isEqualToString:@"1"]) {
        
        // just store the count of total group posts.
        NSString *count = [[Connection connection] getCountOfTotalGroupPosts];
        
        if ([[NSUserDefaults standardUserDefaults] valueForKey:@"countOfGroupPosts"] == nil) {
            [[NSUserDefaults standardUserDefaults] setValue:count forKey:@"countOfGroupPosts"];
        }else {
            int storedCount = [[[NSUserDefaults standardUserDefaults] valueForKey:@"countOfGroupPosts"]intValue];
            int newCount = [count intValue];
            if (newCount > storedCount) {
                createNotification = YES;
                notificationText = [notificationText stringByAppendingString:@" New Group Posts"];
            }
            [[NSUserDefaults standardUserDefaults] setValue:count forKey:@"countOfGroupPosts"];
        }

        
    }
    
    if ([[dateFormat stringFromDate:[NSDate date]] intValue] > 8 && [[dateFormat stringFromDate:[NSDate date]] intValue] < 23 && [[[NSUserDefaults standardUserDefaults] valueForKey:@"groupComments"] isEqualToString:@"1"]) {
        
        // just store the count of total group comments.
        NSString *count = [[Connection connection] getcountOfTotalGroupComments];

        if ([[NSUserDefaults standardUserDefaults] valueForKey:@"countOfGroupComments"] == nil) {
            [[NSUserDefaults standardUserDefaults] setValue:count forKey:@"countOfGroupComments"];
        }else {
            int storedCount = [[[NSUserDefaults standardUserDefaults] valueForKey:@"countOfGroupComments"]intValue];
            int newCount = [count intValue];
            if (newCount > storedCount) {
                createNotification = YES;
                notificationText = [notificationText stringByAppendingString:@" New Group Comments"];
            }
            [[NSUserDefaults standardUserDefaults] setValue:count forKey:@"countOfGroupComments"];
        }
        
    }
    
    if (createNotification) {
        UILocalNotification *notification = [[UILocalNotification alloc] init];
        notification.fireDate = [NSDate dateWithTimeIntervalSinceNow:3];
        notification.alertBody = notificationText;
        notification.timeZone = [NSTimeZone defaultTimeZone];
        notification.soundName = UILocalNotificationDefaultSoundName;
        
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    }
    
    completionHandler(UIBackgroundFetchResultNewData);
}

@end
