//
//  LoginViewController.h
//  DriveProject
//
//  Created by Dave Beltramini on 5/29/15.
//  Copyright (c) 2015 Katie Beltramini. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddProjectViewController.h"
@class FileViewController;
@class ProjectViewController;
@class AddProjectViewController;
@class EditViewController;
@class ViewController;
@class LoginViewController;
@class AccountViewController;


@interface LoginViewController : UIViewController
@property (nonatomic, strong) FileViewController *fileViewController;
@property (nonatomic, strong) ProjectViewController *projectViewController;
@property (nonatomic, strong) AddProjectViewController *addProjectViewController;
@property (nonatomic, strong) EditViewController *editViewController;
@property (nonatomic, strong) ViewController *viewController;
@property (nonatomic, strong) LoginViewController *loginViewController;
@property (nonatomic, strong) AccountViewController *accountViewController;
@property(nonatomic, strong) NSURL *URL;
@property(nonatomic,strong) NSString *noteurl;
@property(nonatomic, strong) NSString *user_key;
@end

