//
//  AppDelegate.m
//  BD
//
//  Created by User on 10/10/18.
//  Copyright © 2018 Digicon. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "HomeViewController.h"
#import "RegistrationViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

+(AppDelegate *)shared{
    
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    NSLog(@"Dir %@", [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject]);
    
    UIScreen *screen = [UIScreen mainScreen];
    
    self.window = [[UIWindow alloc] initWithFrame:screen.bounds];
    
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController *nav;
    
    DataModel *dm = [[DataModel alloc] init];
    NSArray *profiles =  [dm getDataWithEnitity:@"Profile" Managed:NO Predicate:nil Sorts:nil FetchLimit:0 Expressions:nil];
    
    
    if (profiles.count > 0){
        EProfile *profile = profiles.firstObject;
        
        if (profile.isLogin.intValue==1){
            HomeViewController *home = [board instantiateViewControllerWithIdentifier:@"HomeViewControllerID"];
            home.passProfile = profile;
            nav = [[UINavigationController alloc] initWithRootViewController:home];
        }
        else {
            LoginViewController *login = [board instantiateViewControllerWithIdentifier:@"LoginViewControllerID"];
            nav = [[UINavigationController alloc] initWithRootViewController:login];
        }
    }
    else {
        LoginViewController *login = [board instantiateViewControllerWithIdentifier:@"LoginViewControllerID"];
        nav = [[UINavigationController alloc] initWithRootViewController:login];
    }
    
    
    
   
    
    self.window.rootViewController = nav;
                   
    [self.window makeKeyAndVisible];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
