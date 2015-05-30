//
//  AppDelegate.m
//  DriveProject
//
//  Copyright (c) 2015 Katie Beltramini. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "FileViewController.h"
#import "ProjectViewController.h"
#import "AddProjectViewController.h"
#import "OptionsViewController.h"
#import "DriveViewController.h"
#import "EditViewController.h"
#import "LoginViewController.h"
#import "AddCustomerViewController.h"
#import "AccountViewController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    LoginViewController *lvc = [[LoginViewController alloc] init];
    
    ViewController *vvc = [[ViewController alloc] init];
    lvc.viewController = vvc;
    
    AccountViewController *avc =[[AccountViewController alloc] init];
    lvc.accountViewController = avc;
    
    AddCustomerViewController *acvc = [[AddCustomerViewController alloc] init];
    vvc.addCustomerViewController = acvc;
    
  
    ProjectViewController *pvc = [[ProjectViewController alloc] init];
    vvc.projectViewController = pvc;
    
    AddProjectViewController *apvc = [[AddProjectViewController alloc] init];
    pvc.addProjectViewController = apvc;

    
    DriveViewController *opvc = [[DriveViewController alloc] init];
    pvc.driveViewController = opvc;
    
    FileViewController *fvc = [[FileViewController alloc] init];
    opvc.fileViewController = fvc;
    
    EditViewController *evc = [[EditViewController alloc] init];
    opvc.editViewController = evc;
    
    UINavigationController *masterNav = [[UINavigationController alloc] initWithRootViewController:lvc];
    
    //create the look for nav bar across views
    [[UINavigationBar appearance] setBarTintColor:[UIColor orangeColor]];
 //   [[UINavigationBar appearance] setBarTintColor:UIColorFromRGB(0xFFCCFF)];
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
    shadow.shadowOffset = CGSizeMake(0, 1);
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                           [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0], NSForegroundColorAttributeName,
                                                           shadow, NSShadowAttributeName,
                                                           [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:21.0], NSFontAttributeName, nil]];
    
    
    self.window.rootViewController = masterNav;
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
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

@end
