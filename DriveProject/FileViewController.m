//
//  FileViewController.m
//  DriveProject
//
//  Created by Dave Beltramini on 5/22/15.
//  Copyright (c) 2015 Katie Beltramini. All rights reserved.
//

//
//  FileViewController.m
//  DriveProject
//
//  Created by Dave Beltramini on 5/20/15.
//  Copyright (c) 2015 Katie Beltramini. All rights reserved.
//

#import "FileViewController.h"
#import "ViewController.h"
#import "CameraViewController.h"
#import "AppDelegate.h"
#import "GTMOAuth2ViewControllerTouch.h"
#import "GTLDrive.h"



@interface FileViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *NoteLabel;
@property (weak, nonatomic) IBOutlet UITextView *NoteText;
@property (nonatomic, retain) GTLServiceDrive *driveService;
@property (nonatomic, copy) NSArray *files;
@end
static NSString* const DRIVE_IDENTITY_FOLDER = @"Text Folder for App";
static NSString *const kKeychainItemName = @"Google Drive Quickstart";
static NSString *const kClientID = @"897192834849-vo8k2i8qegqseacbhm5kl4c69qga71s2.apps.googleusercontent.com";
static NSString *const kClientSecret = @"6owEqq6jJ0w0OSwRrG0pB8Sj";
static NSString *folderName = @"nottest";
static NSMutableArray *driveFiles;


@implementation FileViewController
@synthesize driveService;
@synthesize fileViewController;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Initialization code
        self.navigationItem.title = @"Categories";
  
    
        

    }
    return self;
}


- (IBAction)addText:(id)sender
{
    NSLog(@"addText");
}
@end
