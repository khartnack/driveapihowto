//
//  ViewController.h
//  DriveProject
//
//  Created by Dave Beltramini on 5/17/15.
//  Copyright (c) 2015 Katie Beltramini. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>

#import "GTMOAuth2ViewControllerTouch.h"
#import "GTLDrive.h"

@interface CameraViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate>


@property (nonatomic, retain) GTLServiceDrive *driveService;
@property (nonatomic, retain) CameraViewController *cameraViewController;

@end

