//
//  ViewController.h
//  DriveProject
//
//  Copyright (c) 2015 Katie Beltramini. All rights reserved.
// test


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
@interface OptionsViewController:  UIViewController <UINavigationControllerDelegate>
//@property (nonatomic, strong) CameraViewController  *cameraViewController;
@property (nonatomic, strong) FileViewController  *fileViewController;
//@property (nonatomic, strong) FolderViewController * folderViewController;
@property (nonatomic,strong) NSString *name;
@property (nonatomic, strong) NSString *noteurl;
@end


