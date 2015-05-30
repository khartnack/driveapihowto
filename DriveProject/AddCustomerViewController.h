//
//  AddCustomerViewController.h
//  DriveProject
//
//  Created by Dave Beltramini on 5/29/15.
//  Copyright (c) 2015 Katie Beltramini. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProjectViewController.h"
#import "ViewController.h"
#import "AppDelegate.h"
#import "ProjectViewController.h"
#import "ViewController.h"
@class ViewController;
@class ProjectViewController;
@interface AddCustomerViewController : UIViewController <UINavigationControllerDelegate>
@property(nonatomic, strong) NSString *user_key;
@property(nonatomic,strong) NSString *noteurl;
//@property (nonatomic, strong) AddProjectViewController *addProjectViewController;
@property(nonatomic, strong) ProjectViewController  *projectViewController;
@property(nonatomic, strong) ViewController  *viewController;
@property(nonatomic,strong) AddCustomerViewController *addCustomerViewController;
@end
