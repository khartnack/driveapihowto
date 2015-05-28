//
//  EditViewController.m
//  DriveProject
//
//  Created by Dave Beltramini on 5/28/15.
//  Copyright (c) 2015 Katie Beltramini. All rights reserved.
//

#import "FileViewController.h"
#import "DriveViewController.h"
#import "ViewController.h"
#import "AppDelegate.h"
#import "GTMOAuth2ViewControllerTouch.h"
#import "GTLDrive.h"
#import "EditViewController.h"


@interface EditViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *CurrentNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *CurrentName;
@property (weak, nonatomic) IBOutlet UITextField *NameText;
@property (weak, nonatomic) IBOutlet UILabel *NameLabel;
@property (nonatomic, retain) GTLServiceDrive *driveService;
@property (nonatomic, copy) NSArray *files;
@property (nonatomic, strong) NSString *identityDirId;
@property (strong) NSString *originalContent;
@property (strong) NSString *fileTitle;
@property (strong, nonatomic) NSString *projectname;
@property (strong, nonatomic) NSString *customer_key;
//@property (strong, nonatomic) NSString *project_key;
@end
//static NSString* const DRIVE_IDENTITY_FOLDER = @"Text Folder for App";
static NSString *const kKeychainItemName = @"Google Drive Quickstart";
static NSString *const kClientID = @"897192834849-vo8k2i8qegqseacbhm5kl4c69qga71s2.apps.googleusercontent.com";
static NSString *const kClientSecret = @"6owEqq6jJ0w0OSwRrG0pB8Sj";
static NSString *folderName = @"nottest";
static NSMutableArray *driveFiles;


@implementation EditViewController
@synthesize driveService;
@synthesize projectname;

//@synthesize fileViewController;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.projectname = _name;
    self.CurrentNameLabel.text = self.projectname;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




- (IBAction)editProject:(id)sender
{
    if([self.NameText.text isEqual: @""])
    {
        
        /* UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"error"
         message:@"Please fill in the name."
         delegate:self
         cancelButtonTitle:@"OK"
         
         otherButtonTitles:nil];
         [alert show];*/
        
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                       message:@"Please Provide A Name."
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
        
        return;
        
    }
    else
    {
        self.projectname = self.NameText.text;
    }
    NSLog(@"key %@", _noteurl);
    
    self.customer_key = _noteurl;
    
    
    
    
    
    NSString *post = [NSString stringWithFormat: @"name=%@&", self.projectname];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    
  
    
    NSString *fixedURL = [NSString stringWithFormat:@"http://cs496sp2015.appspot.com/project/%@",_project_key];
    
    NSLog(@"noteurl on edit %@", fixedURL);
    [request setURL:[NSURL URLWithString:fixedURL]];
    [request setHTTPMethod:@"PUT"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    NSLog(@"postdata = %@", postData);
    NSURLConnection *conn = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    if (conn){
        NSLog(@"Connection Successful");
    } else {
        NSLog(@"Connection Failed");
    }
    
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)deleteProject:(id)sender
{
    if([self.NameText.text isEqual: @""])
    {
        
        /* UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"error"
         message:@"Please fill in the name."
         delegate:self
         cancelButtonTitle:@"OK"
         
         otherButtonTitles:nil];
         [alert show];*/
        
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                       message:@"Please Provide A Name."
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
        
        return;
        
    }
    else
    {
        self.projectname = self.NameText.text;
    }
    NSLog(@"key %@", _noteurl);
    
    self.customer_key = _noteurl;
    
    
    NSString *post = [NSString stringWithFormat: @"name=%@&", self.projectname];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    
    
    NSString *fixedURL = [NSString stringWithFormat:@"http://cs496sp2015.appspot.com/project/%@", _project_key];
    NSLog(@"fixedURL on edit %@", fixedURL);
    
    [request setURL:[NSURL URLWithString:fixedURL]];
    [request setHTTPMethod:@"PUT"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    NSLog(@"postdata = %@", postData);
    NSURLConnection *conn = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    if (conn){
        NSLog(@"Connection Successful");
    } else {
        NSLog(@"Connection Failed");
    }
    
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch(buttonIndex) {
            // case 0: //"No" pressed
            //do something?
            // break;
        case 0: //"Yes" pressed
            //here you pop the viewController
            [self dismissViewControllerAnimated:YES completion:nil];
            
    }
}

@end
