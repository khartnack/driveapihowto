//
//  EditViewController.h
//  DriveProject
//
//  Created by Dave Beltramini on 5/28/15.
//  Copyright (c) 2015 Katie Beltramini. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "GTMOAuth2ViewControllerTouch.h"
#import "GTLDrive.h"
#import "FileViewController.h"
#import "ProjectViewController.h"
#import "DriveViewController.h"


@interface EditViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (nonatomic, retain) DriveViewController *driveViewController;
@property (nonatomic, retain) FileViewController *fileViewController;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) EditViewController *editViewController;
@property (nonatomic, retain) NSString *noteurl;
@property (nonatomic,retain) NSString *project_key;
@end
