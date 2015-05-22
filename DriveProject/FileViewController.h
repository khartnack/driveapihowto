//
//  FileViewController.h
//  DriveProject
//
//  Created by Dave Beltramini on 5/22/15.
//  Copyright (c) 2015 Katie Beltramini. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "GTMOAuth2ViewControllerTouch.h"
#import "GTLDrive.h"
#import "FileViewController.h"


@interface FileViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, retain) FileViewController *fileViewController;
@end
