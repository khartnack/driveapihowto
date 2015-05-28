//
//  ViewController.m
//  DriveProject
//
//  Created by Dave Beltramini on 5/18/15.
//  Copyright (c) 2015 Katie Beltramini. All rights reserved.
// used code from here:
//https://github.com/surespot/surespot-ios/blob/master/surespot/backup/RestoreIdentityDriveViewController.mm
//and https://developers.google.com/drive/ios/quickstart

#import "ViewController.h"
#import "FileViewController.h"
#import "AppDelegate.h"
#import "DriveViewController.h"
#import "ProjectViewController.h"
#import "EditViewController.h"

@interface DriveViewController() <UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *EditProject;
@property (nonatomic, strong) NSString *identityDirId;
@property (weak, nonatomic) IBOutlet UIButton *AddImage;
@property (weak, nonatomic) IBOutlet UIButton *AddText;
@property (nonatomic, retain) GTLServiceDrive *driveService;
@end

//static NSString* const DRIVE_IDENTITY_FOLDER = _name;
//@"Image Folder for Apps";
static NSString *const kKeychainItemName = @"Google Drive Quickstart";
static NSString *const kClientID = @"897192834849-vo8k2i8qegqseacbhm5kl4c69qga71s2.apps.googleusercontent.com";
static NSString *const kClientSecret = @"6owEqq6jJ0w0OSwRrG0pB8Sj";
static NSString *folderName = @"nottest";
static NSMutableArray *driveFiles;
@implementation DriveViewController
//@synthesize cameraViewController;
@synthesize driveService;
@synthesize fileViewController;
@synthesize editViewController;
//@synthesize folderViewController;




- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Initialization code
        self.navigationItem.title = @"Project Options";
        // NSString* DRIVE_IDENTITY_FOLDER = _name;
        NSLog(@"initWithNibName");
        
    }
    return self;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)addImage:(id)sender
{
    UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else
    {
        // In case we're running the iPhone simulator, fall back on the photo library instead.
        cameraUI.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
        {
            [self showAlert:@"Error" message:@"Sorry, iPad Simulator not supported!"];
            return;
        }
    };
    
    cameraUI.delegate = self;
    
    [self presentViewController:cameraUI animated:YES completion:NULL];
    
    if (![self isAuthorized])
    {
        //Not yet authorized, request authorization and push the login UI onto the navigation stack.
        [cameraUI pushViewController:[self createAuthController] animated:YES];
    }
    
    
}

- (IBAction)addText:(id)sender
{
    
    self.fileViewController.name = _name;
    [self.navigationController pushViewController:fileViewController animated:YES];
    
}


- (IBAction)editProject:(id)sender
{
    
    self.editViewController.name = _name;
    [self.navigationController pushViewController:editViewController animated:YES];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    // Initialize the drive service & load existing credentials from the keychain if available
    self.driveService = [[GTLServiceDrive alloc] init];
    self.driveService.authorizer = [GTMOAuth2ViewControllerTouch authForGoogleFromKeychainForName:kKeychainItemName
                                                                                         clientID:kClientID
                                                                                     clientSecret:kClientSecret];
    
    GTLQueryDrive *queryFilesList = [GTLQueryDrive queryForChildrenListWithFolderId:@"root"];
    queryFilesList.q =  [NSString stringWithFormat:@"title='%@' and trashed = false and mimeType='application/vnd.google-apps.folder'", _name];
    //DRIVE_IDENTITY_FOLDER];
    [driveService executeQuery:queryFilesList
             completionHandler:^(GTLServiceTicket *ticket, GTLDriveFileList *files,
                                 NSError *error) {
                 if (error == nil) {
                     if (files.items.count > 0) {
                         NSString * identityDirId = nil;
                         
                         for (id file in files.items) {
                             _identityDirId = [file identifier];
                             NSLog(@"Parent.Ref %@", identityDirId);
                             
                             if (identityDirId) break;
                         }
                         
                         return;
                     }
                     else {
                         GTLDriveFile *folderObj = [GTLDriveFile object];
                         folderObj.title = _name; //DRIVE_IDENTITY_FOLDER;
                         folderObj.mimeType = @"application/vnd.google-apps.folder";
                         
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
                                      
                                      return;
                                      
                                  }];
                     }
                     
                     
                 } else {
                     NSLog(@"An error occurred: %@", error);
                     
                 }
             }];
    
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)showCamera
{
    UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else
    {
        // In case we're running the iPhone simulator, fall back on the photo library instead.
        cameraUI.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
        {
            [self showAlert:@"Error" message:@"Sorry, iPad Simulator not supported!"];
            return;
        }
    };
    
    cameraUI.delegate = self;
    
    [self presentViewController:cameraUI animated:YES completion:NULL];
    
    if (![self isAuthorized])
    {
        //Not yet authorized, request authorization and push the login UI onto the navigation stack.
        [cameraUI pushViewController:[self createAuthController] animated:YES];
    }
}

// Handle selection of an image
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    [self uploadPhoto:image];
    [self dismissViewControllerAnimated:YES completion:NULL];
    
}

// Handle cancel from image picker/camera.
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    
    [self dismissViewControllerAnimated:YES completion:nil];
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




// Uploads a photo to Google Drive
- (void)uploadPhoto:(UIImage*)image
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"'Image App Uploaded File ('EEEE MMMM d, YYYY h:mm a, zzz')"];
    GTLDriveFile *file = [GTLDriveFile object];
    file.title = [dateFormat stringFromDate:[NSDate date]];
    file.descriptionProperty = @"Uploaded from the Google Drive iOS Quickstart";
    file.mimeType = @"image/png";
    
    GTLDriveParentReference *parentRef = [GTLDriveParentReference object];
    
    parentRef.identifier = _identityDirId;
    
    if(parentRef.identifier!=nil)
    {
        
        file.parents = @[ parentRef ];
        
    }
    
    NSData *data = UIImagePNGRepresentation((UIImage *)image);
    GTLUploadParameters *uploadParameters = [GTLUploadParameters uploadParametersWithData:data MIMEType:file.mimeType];
    GTLQueryDrive *query2 = [GTLQueryDrive queryForFilesInsertWithObject:file
                                                        uploadParameters:uploadParameters];
    
    
    
    UIAlertView *waitIndicator = [self showWaitIndicator:@"Uploading to Google Drive"];
    
    [self.driveService executeQuery:query2
                  completionHandler:^(GTLServiceTicket *ticket,
                                      GTLDriveFile *insertedFile, NSError *error) {
                      [waitIndicator dismissWithClickedButtonIndex:0 animated:YES];
                      if (error == nil)
                      {
                          NSLog(@"File ID: %@", insertedFile.identifier);
                          [self showAlert:@"Google Drive" message:@"File saved!"];
                      }
                      else
                      {
                          NSLog(@"An error occurred: %@", error);
                          [self showAlert:@"Google Drive" message:@"Sorry, an error occurred!"];
                      }
                  }];
    
    
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
