//
//  ViewController.m
//  DriveProject
//
//  Created by Dave Beltramini on 5/18/15.
//  Copyright (c) 2015 Katie Beltramini. All rights reserved.
//

#import "ViewController.h"
#import "CameraViewController.h"
#import "FileViewController.h"
#import "AppDelegate.h"


@interface ViewController() <UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (nonatomic, strong) NSString *identityDirId;
@property (weak, nonatomic) IBOutlet UIButton *AddImage;
@property (weak, nonatomic) IBOutlet UIButton *AddText;
@property (nonatomic, retain) GTLServiceDrive *driveService;
@end

static NSString* const DRIVE_IDENTITY_FOLDER = @"Image Folder for Apps";
static NSString *const kKeychainItemName = @"Google Drive Quickstart";
static NSString *const kClientID = @"897192834849-vo8k2i8qegqseacbhm5kl4c69qga71s2.apps.googleusercontent.com";
static NSString *const kClientSecret = @"6owEqq6jJ0w0OSwRrG0pB8Sj";
static NSString *folderName = @"nottest";
static NSMutableArray *driveFiles;
@implementation ViewController
@synthesize cameraViewController;
@synthesize driveService;
@synthesize fileViewController;




- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Initialization code
        self.navigationItem.title = @"Upload File";
        
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
    //cameraUI.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeImage, nil];
    //cameraUI.allowsEditing = YES;
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
    
    NSLog(@"navigation call for view files");
   
    
    [self.navigationController pushViewController:fileViewController animated:YES];

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
    //cameraUI.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeImage, nil];
    //cameraUI.allowsEditing = YES;
    cameraUI.delegate = self;
    
    [self presentViewController:cameraUI animated:YES completion:NULL];
    
    if (![self isAuthorized])
    {
        //Not yet authorized, request authorization and push the login UI onto the navigation stack.
        [cameraUI pushViewController:[self createAuthController] animated:YES];
    }
    //[self dismissViewControllerAnimated:YES completion:nil];
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



-(void)loadDriveFiles
{
    GTLQueryDrive *query = [GTLQueryDrive queryForFilesList];
    query.q = [NSString stringWithFormat:@"'%@' IN parents", @"root"];
    [self.driveService executeQuery:query completionHandler:^(GTLServiceTicket *ticket,
                                                              GTLDriveFileList *files,
                                                              NSError *error) {
        if (error == nil)
        {
            driveFiles = [[NSMutableArray alloc] init]; //
            [driveFiles addObjectsFromArray:files.items];
            
            for (GTLDriveFile *file in driveFiles)
                NSLog(@"File is %@", file.title);
        }
        else
        {
            NSLog(@"An error occurred in loadDriveFiles: %@", error);
        }
    }];
}


// Uploads a photo to Google Drive
- (void)uploadPhoto:(UIImage*)image
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"'Quickstart Uploaded File ('EEEE MMMM d, YYYY h:mm a, zzz')"];
    GTLDriveFile *file = [GTLDriveFile object];
    file.title = [dateFormat stringFromDate:[NSDate date]];
    file.descriptionProperty = @"Uploaded from the Google Drive iOS Quickstart";
    file.mimeType = @"image/png";
    
    GTLDriveParentReference *parentRef = [GTLDriveParentReference object];
    
    parentRef.identifier = _identityDirId;
    NSLog(@"folder identifier %@", _identityDirId);
    if(parentRef.identifier!=nil)
    {
        
        file.parents = @[ parentRef ];
        NSLog(@"if idnetityDir!=nil %@", @[parentRef]);
        
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
