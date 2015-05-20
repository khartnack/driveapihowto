//
//  ViewController.h
//  DriveProject
//
//  Created by Dave Beltramini on 5/18/15.
//  Copyright (c) 2015 Katie Beltramini. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "CameraViewController.h"
#import "FileViewController.h"
#import "AppDelegate.h"

@class CameraViewController;
@class FileViewController;
@interface ViewController:  UIViewController <UINavigationControllerDelegate>
@property (nonatomic, strong) CameraViewController  *cameraViewController;
@property (nonatomic, strong) FileViewController  *fileViewController;
@end


