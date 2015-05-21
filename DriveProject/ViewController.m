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

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIButton *AddImage;
@property (weak, nonatomic) IBOutlet UIButton *AddText;
@property (nonatomic, retain) GTLServiceDrive *driveService;
@end
static NSString *const kKeychainItemName = @"Google Drive Quickstart";
static NSString *const kClientID = @"897192834849-vo8k2i8qegqseacbhm5kl4c69qga71s2.apps.googleusercontent.com";
static NSString *const kClientSecret = @"6owEqq6jJ0w0OSwRrG0pB8Sj";
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

- (void)viewDidLoad {
    [super viewDidLoad];
   // self.driveService = [[GTLServiceDrive alloc] init];
    //self.driveService.authorizer = [GTMOAuth2ViewControllerTouch authForGoogleFromKeychainForName:kKeychainItemName
    //                                                                                     clientID:kClientID
    //                                                                                 clientSecret:kClientSecret];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)addImage:(id)sender
{
    
    NSLog(@"navigation call for add image");
    //  [self.navigationController pushViewController: NotesViewController animated:YES];
    
    [self.navigationController pushViewController:cameraViewController animated:YES];
    
}

- (IBAction)addText:(id)sender
{
    
    NSLog(@"navigation call for view files");
    //  [self.navigationController pushViewController: NotesViewController animated:YES];
    
    [self.navigationController pushViewController:fileViewController animated:YES];

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
        //[self showAlert:@"Authentication Error" message:error.localizedDescription];
        self.driveService.authorizer = nil;
    }
    else
    {
        self.driveService.authorizer = authResult;
    }
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
