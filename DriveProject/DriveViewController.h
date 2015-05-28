//
//  DriveViewController.h
//  DriveProject
//
//  Created by Dave Beltramini on 5/28/15.
//  Copyright (c) 2015 Katie Beltramini. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "FileViewController.h"
#import "AppDelegate.h"
#import "ProjectViewController.h"
#import "ViewController.h"


//@class CameraViewController;
@class FileViewController;
//@class FolderViewController;
@class ProjectViewController;
@interface DriveViewController:  UIViewController <UINavigationControllerDelegate>
//@property (nonatomic, strong) CameraViewController  *cameraViewController;
@property (nonatomic, strong) FileViewController  *fileViewController;
//@property (nonatomic, strong) FolderViewController * folderViewController;
@property (nonatomic,strong) NSString *name;
@end


