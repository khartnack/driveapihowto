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



@interface FileViewController ()
@property (nonatomic, retain) GTLServiceDrive *driveService;
@property (nonatomic, copy) NSArray *files;
@end
static NSString* const DRIVE_IDENTITY_FOLDER = @"my app2";
static NSString *const kKeychainItemName = @"Google Drive Quickstart";
static NSString *const kClientID = @"897192834849-vo8k2i8qegqseacbhm5kl4c69qga71s2.apps.googleusercontent.com";
static NSString *const kClientSecret = @"6owEqq6jJ0w0OSwRrG0pB8Sj";
static NSString *folderName = @"nottest";
static NSMutableArray *driveFiles;


@implementation FileViewController
@synthesize driveService;




- (instancetype)init
{
    self = [super init];
    if (self) {
        
        // Check for authorization.
        GTMOAuth2Authentication *auth =
        [GTMOAuth2ViewControllerTouch authForGoogleFromKeychainForName:kKeychainItemName
                                                              clientID:kClientID
                                                          clientSecret:kClientSecret];
        if ([auth canAuthorize]) {
        //    [self isAuthorizedWithAuthentication:auth];
        }
        
    }
    return self;
}



- (GTLServiceDrive *)driveService {
    static GTLServiceDrive *service = nil;
    
    if (!service) {
        service = [[GTLServiceDrive alloc] init];
        
        // Have the service object set tickets to fetch consecutive pages
        // of the feed so we do not need to manually fetch them.
        service.shouldFetchNextPages = YES;
        
        // Have the service object set tickets to retry temporary error conditions
        // automatically.
        service.retryEnabled = YES;
    }
    return service;
}
/*
- (void)authButtonClicked
{
    
    if (!self.isAuthorized) {
        // Sign in.
        SEL finishedSelector = @selector(viewController:finishedWithAuth:error:);
        GTMOAuth2ViewControllerTouch *authViewController =
        [[GTMOAuth2ViewControllerTouch alloc] initWithScope:kGTLAuthScopeDrive
                                                   clientID:kClientId
                                               clientSecret:kClientSecret
                                           keychainItemName:kKeychainItemName
                                                   delegate:self
                                           finishedSelector:finishedSelector];
        
        [delegate authButtonClicked_GDWithVC:authViewController];
        
    } else {
        // Sign out
        [GTMOAuth2ViewControllerTouch removeAuthFromKeychainForName:kKeychainItemName];
        [[self driveService] setAuthorizer:nil];
        [delegate LoginLogout_GD:@"Link"];
        self.isAuthorized = NO;
        [self toggleActionButtons:NO];
        [self.driveFiles removeAllObjects];
        
    }
    
}

- (IBAction)refreshButtonClicked:(id)sender {
    [self loadDriveFilesWithFolderID:nil];
}

- (void)toggleActionButtons:(BOOL)enabled {
    
    
}


- (void)viewController:(GTMOAuth2ViewControllerTouch *)viewController
      finishedWithAuth:(GTMOAuth2Authentication *)auth
                 error:(NSError *)error {
    
    [viewController dismissViewControllerAnimated:YES completion:nil];
    [delegate dismissViewController_GD];
    
    if (error == nil) {
        [self isAuthorizedWithAuthentication:auth];
    }
}

- (void)isAuthorizedWithAuthentication:(GTMOAuth2Authentication *)auth {
    [[self driveService] setAuthorizer:auth];
    //self.authButton.title = @"Sign out";
    [delegate LoginLogout_GD:@"Unlink"];
    self.isAuthorized = YES;
    [self toggleActionButtons:YES];
    //[self loadDriveFiles];
}

- (void)loadDriveFilesWithFolderID:(NSString*)folderID {
    GTLQueryDrive *query = [GTLQueryDrive queryForFilesList];
    
    if(folderID==nil)
    {
        
        
        query.q = @"mimeType = 'application/pdf' or mimeType = 'application/vnd.google-apps.folder'";
        
    }
    else
    {
        query.q = [NSString stringWithFormat:@"'%@' IN parents and (mimeType = 'application/pdf' or mimeType = 'application/vnd.google-apps.folder')", folderID];
        
    }
    
    
    
    //UIAlertView *alert = [DrEditUtilities showLoadingMessageWithTitle:@"Loading files"
    //                                                       delegate:self];
    
    
    
    [self.driveService executeQuery:query completionHandler:^(GTLServiceTicket *ticket,
                                                              GTLDriveFileList *files,
                                                              NSError *error) {
        //[alert dismissWithClickedButtonIndex:0 animated:YES];
        if (error == nil) {
            
            [delegate loadAllFolders_GD:files];
            
        } else {
            NSLog(@"An error occurred: %@", error);
            [delegate errormessage_GD:error];
        }
    }];
}

-(NSString *)getuploadFileName{
    
    SingletonClass* sharedSingleton = [SingletonClass sharedInstance];
    ManageFile *manageFile=[[ManageFile alloc]init];
    NSString *pdfName=[manageFile getFileNameWithInventory:sharedSingleton.strInventory_no withClientRef:sharedSingleton.strClientRef withSeprator:@"-" withExtension:@".pdf" withRowID:sharedSingleton.rowID]; //Inevtory and Client passed as blank means we will get values from SingletonClass class
    return pdfName;
    
}

-(NSString*)getPDFFileName
{
    NSString* fileName = @"ConditionReport.PDF";
    
    NSArray *arrayPaths =
    NSSearchPathForDirectoriesInDomains(
                                        NSDocumentDirectory,
                                        NSUserDomainMask,
                                        YES);
    NSString *path = [arrayPaths objectAtIndex:0];
    NSString* pdfFileName = [path stringByAppendingPathComponent:fileName];
    
    return pdfFileName;
    
}

// Uploads a photo to Google Drive
- (void)uploadFileToGDWithIdentifier:(NSString*)folderIdentifier
{
    NSString *pdfFileName=[self getuploadFileName];
    //SingletonClass *sharedSingleton=[SingletonClass sharedInstance];
    
    //NSString *file1 =[self getPDFFileName]; // Using PCM format
    
    NSString *file1=[self getPDFFileName];
    
    NSData *file1Data = [[NSData alloc] initWithContentsOfFile:file1];
    
    
    GTLDriveFile *file = [GTLDriveFile object];
    file.title = pdfFileName;
    file.descriptionProperty = @"Uploaded from Art Report iOS app";
    file.mimeType = @"application/pdf";
    
    GTLDriveParentReference *parentRef = [GTLDriveParentReference object];
    parentRef.identifier = folderIdentifier; // identifier property of the folder
    if(folderIdentifier!=nil)
    {
        file.parents = @[ parentRef ];
    }
    
    NSData *data = file1Data;
    GTLUploadParameters *uploadParameters = [GTLUploadParameters uploadParametersWithData:data MIMEType:file.mimeType];
    GTLQueryDrive *query = [GTLQueryDrive queryForFilesInsertWithObject:file
                                                       uploadParameters:uploadParameters];
    
    UIAlertView *waitIndicator = [self showWaitIndicator:@"Uploading to Google Drive"];
    
    [self.driveService executeQuery:query
                  completionHandler:^(GTLServiceTicket *ticket,
                                      GTLDriveFile *insertedFile, NSError *error) {
                      [waitIndicator dismissWithClickedButtonIndex:0 animated:YES];
                      if (error == nil)
                      {
                          NSLog(@"File ID: %@", insertedFile.identifier);
                          [self showAlert:@"Google Drive" message:@"File saved!"];
                          [delegate dismissViewController_GD];
                      }
                      else
                      {
                          NSLog(@"An error occurred: %@", error);
                          [self showAlert:@"Google Drive" message:@"Sorry, an error occurred!"];
                          
                          [delegate dismissViewController_GD];
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








- (void)refreshButtonClicked{
    
}







@end
/*
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class]
           forCellReuseIdentifier:@"UITableViewCell"];
   // NSLog(@"%@", [((GTMOAuth2Authentication *)self.driveService.authorizer) canAuthorize]);
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadDriveFiles
{

  //  fileFetchStatusFailure = NO;
    
    //for more info about fetching the files check this link
    GTLQueryDrive *query = [GTLQueryDrive queryForFilesList];
    query.q = [NSString stringWithFormat:@"'%@' IN parents", @"root"];
    
    // queryTicket can be used to track the status of the request.
    [self.driveService executeQuery:query
                  completionHandler:^(GTLServiceTicket *ticket,
                                      GTLDriveFileList *files, NSError *error)
     {
         NSLog(@"error: %@", error.localizedDescription);
         GTLBatchQuery *batchQuery = [GTLBatchQuery batchQuery];
         
         //incase there is no files under this folder then we can avoid the fetching process
         
         if(error)
         {
             UIAlertView *alertForError=[[UIAlertView alloc]initWithTitle:@"ERROR" message:error.localizedDescription delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:Nil, nil];
             
             [alertForError show];
             
         }
         else
         {
             //an array to store files : driveFiles
             driveFiles = [[NSMutableArray alloc] init];
             [driveFiles addObjectsFromArray:files.items];
             
             if (driveFiles.count == 0)
             {
                 UIAlertView *noDataAlert=[[UIAlertView alloc]initWithTitle:@"NO FILE" message:@"No Files in google drive" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:Nil, nil];
                 
                 [noDataAlert show];
                 
             }
             else
             {
                 for (GTLDriveFile *driveFile in driveFiles)
                 {
                     //if you are showing files in a tableview
                     [self.tableView reloadData];
                 }
             }
         }
         
         //finally execute the batch query. Since the file reterive process is much faster because it will get all file metadata info at once
         [self.driveService executeQuery:batchQuery
                       completionHandler:^(GTLServiceTicket *ticket,
                                           GTLDriveFile *file,
                                           NSError *error) {
                       }];
         
     }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.files count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell =
    [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"
                                    forIndexPath:indexPath];
    
    NSDictionary *file = self.files[indexPath.row];
    cell.textLabel.text = file[@"title"];
    
    return cell;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}*/


@end
