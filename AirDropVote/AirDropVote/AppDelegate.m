//
//  AppDelegate.m
//  AirDropVote
//
//  Created by 高橋 勲 on 2013/10/01.
//  Copyright (c) 2013年 高橋 勲. All rights reserved.
//

#import "AppDelegate.h"
#import "FileUtil.h"
#import "JsonResolver.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    NSLog(@"%@",url.path);
    NSData *jsonData = [NSData dataWithContentsOfURL:url];
    NSString *receivedString = [FileUtil data2str:jsonData];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"received Json" message:receivedString delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alert show];
    
    // Inserting Data from Json
    /*
    NSArray *jsonList = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:nil];
    for (NSDictionary* json in jsonList) {
        Bookmark *bm = [[Bookmark alloc] initWithJson:json];
        if ([BookmarkDAO exists:bm]) {
            NSLog(@"exists.");
        } else {
            [BookmarkDAO insert:bm];
        }
    }*/
    [JsonResolver resolveAndInsertDataFromJson:jsonData];
    
    //Refresh Candidates Table
    UINavigationController *nav = (UINavigationController*)self.window.rootViewController;
    CandidatesListViewController *candidateVC = (CandidatesListViewController*)[nav childViewControllers][0];
    [candidateVC.tableView reloadData];
    
    if ([nav childViewControllers].count > 1) {
        CandidatesListViewController *candidateVC = (CandidatesListViewController*)[nav childViewControllers][1];
        [candidateVC.tableView reloadData];
    }

    return true;
}

@end
