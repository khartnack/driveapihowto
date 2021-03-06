//
//  ProjectViewController.h
//  DriveProject
//
//  Created by Dave Beltramini on 5/27/15.
//  Copyright (c) 2015 Katie Beltramini. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
#import "AppDelegate.h"
@class FileViewController;
@class DriveViewController;
@class AddProjectViewController;
@class OptionsViewController;


@interface ProjectViewController : UITableViewController
@property (nonatomic, strong) FileViewController *fileViewController;
@property (nonatomic, strong)ProjectViewController *projectViewController;
@property (nonatomic, strong) AddProjectViewController *addProjectViewController;
@property (nonatomic, strong) OptionsViewController *optionsViewController;
@property (nonatomic, strong) DriveViewController *driveViewController;
@property(nonatomic, strong) NSURL *URL;
@property(nonatomic, strong) NSString *key;
@property(nonatomic,strong) NSString *noteurl;
@property(nonatomic,strong) NSString *project_key;
@property(nonatomic,strong) NSString *name;
@end