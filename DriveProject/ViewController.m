//
//  ViewController.m
//  DriveProject
//
//  Created by Dave Beltramini on 5/18/15.
//  Copyright (c) 2015 Katie Beltramini. All rights reserved.
//

#import "ViewController.h"
#import "CameraViewController.h"
#import "ViewController.h"
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
