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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
