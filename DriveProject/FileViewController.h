//
//  FileViewController.h
//  DriveProject
//
//  Created by Dave Beltramini on 5/20/15.
//  Copyright (c) 2015 Katie Beltramini. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "CameraViewController.h"
#import "GTMOAuth2ViewControllerTouch.h"
#import "GTLDrive.h"

@interface FileViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate>


@property (nonatomic, retain) GTLServiceDrive *driveService;
@property (nonatomic, retain) FileViewController *filerViewController;
@end