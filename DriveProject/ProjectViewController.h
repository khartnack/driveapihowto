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

@class AddProjectViewController;
//@class NotesInfoViewController;
//@class ImageViewController;

@interface ProjectViewController : UITableViewController
@property (nonatomic, strong) FileViewController *fileViewController;
@property (nonatomic, strong)ProjectViewController *projectViewController;
@property (nonatomic, strong) AddProjectViewController *addProjectViewController;
//@property (nonatomic, strong) CustomerInfoViewController *customerInfoViewController;
//@property (nonatomic, strong) NotesInfoViewController *notesInfoViewController;
//@property (nonatomic, strong) ImageViewController *imageViewController;
@property(nonatomic, strong) NSURL *URL;
@property(nonatomic, strong) NSString *key;
@end