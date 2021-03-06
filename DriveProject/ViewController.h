//
//  ViewController.h
//  DriveProject
//
//  Created by Dave Beltramini on 5/27/15.
//  Copyright (c) 2015 Katie Beltramini. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddProjectViewController.h"
#import "AddCustomerViewController.h"
@class AddCustomerViewController;
@class FileViewController;
@class ProjectViewController;
@class AddProjectViewController;
@class EditViewController;
@class LoginViewController;

@interface ViewController : UITableViewController {ProjectViewController *projectViewController;}
@property (nonatomic, strong) FileViewController *fileViewController;
@property (nonatomic, strong) ProjectViewController *projectViewController;
@property (nonatomic, strong) AddProjectViewController *addProjectViewController;
@property (nonatomic, strong) EditViewController *editViewController;
@property (nonatomic, strong) LoginViewController *loginViewController;
@property (nonatomic, strong) AddCustomerViewController *addCustomerViewController;
@property(nonatomic, strong) NSURL *URL;
@property(nonatomic,strong) NSString *noteurl;
@property(nonatomic, strong) NSString *user_key;
@end


