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
#import "FolderViewController.h"


@interface FolderViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, retain) GTLServiceDrive *driveService;
@property (nonatomic, copy) NSArray *files;
@property (nonatomic, strong) NSString *identityDirId;
@property (strong) NSString *originalContent;
@property (strong) NSString *fileTitle;
@end
static NSString* const DRIVE_IDENTITY_FOLDER = @"Text Folder for App";
static NSString *const kKeychainItemName = @"Google Drive Quickstart";
static NSString *const kClientID = @"897192834849-vo8k2i8qegqseacbhm5kl4c69qga71s2.apps.googleusercontent.com";
static NSString *const kClientSecret = @"6owEqq6jJ0w0OSwRrG0pB8Sj";
static NSString *folderName = @"nottest";
static NSMutableArray *driveFiles;


@implementation FolderViewController
@synthesize driveService;
@synthesize folderViewController;




- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Initialization code
        self.navigationItem.title = @"View Files";
        
    }
    return self;
}



- (IBAction)addText:(id)sender
{
    
    
}








- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//- (void)viewDidLoad
-(void)viewWillAppear:(BOOL)animated
{
    //  [super viewDidLoad];
    [super viewWillAppear:animated];
    // Initialize the drive service & load existing credentials from the keychain if available
    self.driveService = [[GTLServiceDrive alloc] init];
    self.driveService.authorizer = [GTMOAuth2ViewControllerTouch authForGoogleFromKeychainForName:kKeychainItemName
                                                                                         clientID:kClientID
                                                                                     clientSecret:kClientSecret];
    
    GTLQueryDrive *queryFilesList = [GTLQueryDrive queryForChildrenListWithFolderId:@"root"];
    queryFilesList.q =  [NSString stringWithFormat:@"title='%@' and trashed = false and mimeType='application/vnd.google-apps.folder'", DRIVE_IDENTITY_FOLDER];
    NSLog(@"Drive Identity folder%@", DRIVE_IDENTITY_FOLDER);
    NSLog(@"querylist%@", queryFilesList.q);
    [driveService executeQuery:queryFilesList
             completionHandler:^(GTLServiceTicket *ticket, GTLDriveFileList *files,
                                 NSError *error) {
                 if (error == nil) {
                     if (files.items.count > 0) {
                         NSLog(@"file count >0");
                         NSString * identityDirId = nil;
                         
                         for (id file in files.items) {
                             _identityDirId = [file identifier];
                             NSLog(@"Parent.Ref %@", identityDirId);
                             
                             if (identityDirId) break;
                         }
                         
                         //completionBlock(identityDirId);
                         return;
                     }
                     else {
                         GTLDriveFile *folderObj = [GTLDriveFile object];
                         folderObj.title = DRIVE_IDENTITY_FOLDER;
                         folderObj.mimeType = @"application/vnd.google-apps.folder";
                         
                         // To create a folder in a specific parent folder, specify the identifier
                         // of the parent:
                         // _resourceId is the identifier from the parent folder
                         NSLog(@"folder idnet %@", folderObj.identifier);
                         GTLDriveParentReference *parentRef = [GTLDriveParentReference object];
                         parentRef.identifier = @"root";
                         folderObj.parents = [NSArray arrayWithObject:parentRef];
                         
                         
                         GTLQueryDrive *query = [GTLQueryDrive queryForFilesInsertWithObject:folderObj uploadParameters:nil];
                         
                         [driveService executeQuery:query
                                  completionHandler:^(GTLServiceTicket *ticket, GTLDriveFile *file,
                                                      NSError *error) {
                                      NSString * identityDirId = nil;
                                      if (error == nil) {
                                          
                                          if (file) {
                                              _identityDirId = [file identifier];
                                              NSLog(@"identityDirID %@", identityDirId);
                                          }
                                          
                                      } else {
                                          NSLog(@"An error occurred in upload photo: %@", error);
                                          
                                      }
                                      //completionBlock(identityDirId);
                                      return;
                                      
                                  }];
                     }
                     
                     
                 } else {
                     NSLog(@"An error occurred: %@", error);
                     //completionBlock(nil);
                 }
             }];
    
    // Always display the camera UI.
    //[self showCamera];
    
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

// Helper to check if user is authorized
- (BOOL)isAuthorized
{
    return [((GTMOAuth2Authentication *)self.driveService.authorizer) canAuthorize];
}

// Creates the auth controller for authorizing access to Google Drive.
- (GTMOAuth2ViewControllerTouch *)createAuthController
{
    GTMOAuth2ViewControllerTouch *authController;
    authController = [[GTMOAuth2ViewControllerTouch alloc] initWithScope:kGTLAuthScopeDriveFile
                                                                clientID:kClientID
                                                            clientSecret:kClientSecret
                                                        keychainItemName:kKeychainItemName
                                                                delegate:self
                                                        finishedSelector:@selector(viewController:finishedWithAuth:error:)];
    return authController;
}

// Handle completion of the authorization process, and updates the Drive service
// with the new credentials.
- (void)viewController:(GTMOAuth2ViewControllerTouch *)viewController
      finishedWithAuth:(GTMOAuth2Authentication *)authResult
                 error:(NSError *)error
{
    if (error != nil)
    {
        [self showAlert:@"Authentication Error" message:error.localizedDescription];
        self.driveService.authorizer = nil;
    }
    else
    {
        self.driveService.authorizer = authResult;
    }
}




// Helper for showing a wait indicator in a popup
- (UIAlertView*)showWaitIndicator:(NSString *)title
{
    UIAlertView *progressAlert;
    progressAlert = [[UIAlertView alloc] initWithTitle:title
                                               message:@"Please wait..."
                                              delegate:nil
                                     cancelButtonTitle:nil
                                     otherButtonTitles:nil];
    [progressAlert show];
    
    UIActivityIndicatorView *activityView;
    activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    activityView.center = CGPointMake(progressAlert.bounds.size.width / 2,
                                      progressAlert.bounds.size.height - 45);
    
    [progressAlert addSubview:activityView];
    [activityView startAnimating];
    return progressAlert;
}



// Helper for showing an alert
- (void)showAlert:(NSString *)title message:(NSString *)message
{
    UIAlertView *alert;
    alert = [[UIAlertView alloc] initWithTitle: title
                                       message: message
                                      delegate: nil
                             cancelButtonTitle: @"OK"
                             otherButtonTitles: nil];
    [alert show];
    
    
}



- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}



@end

