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
@class CameraViewController;
@interface ViewController : UIViewController <UINavigationControllerDelegate>
@property (nonatomic, strong) CameraViewController  *cameraViewController;

@end
