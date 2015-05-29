//
//  LoginViewController.m
//  DriveProject
//
//  Created by Dave Beltramini on 5/29/15.
//  Copyright (c) 2015 Katie Beltramini. All rights reserved.
//

#import "LoginViewController.h"
#import "ViewController.h"
#import "ProjectViewController.h"
#import "AddProjectViewController.h"
#import "EditViewController.h"
@interface LoginViewController () <NSURLSessionDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *welcome;
@property (weak, nonatomic) IBOutlet UILabel *username2;
@property (weak, nonatomic) IBOutlet UILabel *password;
@property (weak, nonatomic) IBOutlet UITextField *usernameText;
@property (nonatomic, strong) NSURLSession *session;
@property (weak, nonatomic) IBOutlet UITextField *pwdTxt;
@property (nonatomic, copy) NSArray *courses;
@property (nonatomic, copy) NSArray *users;
@property (nonatomic, strong) NSString *key;
@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *pwd;
@end

@implementation LoginViewController
@synthesize viewController;
@synthesize username;
@synthesize pwd;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)login:(id)sender
{
    
    self.username = self.usernameText.text;
    self.pwd = self.pwdTxt.text;
    
    NSString *requestString = [NSString stringWithFormat:@"http://may29sp2015.appspot.com/user&username=%@&pwd=%@",self.username, self.pwd];
    NSURL *url = [NSURL URLWithString:requestString];
    NSURLRequest *req = [NSURLRequest requestWithURL:url  cachePolicy:NSURLRequestReloadIgnoringCacheData
                                     timeoutInterval:60.0];
    
    NSURLSessionDataTask *dataTask =
    [self.session dataTaskWithRequest:req
                    completionHandler:
     ^(NSData *data, NSURLResponse *response, NSError *error) {
         
         NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data
                                                                    options:0
                                                                      error:nil];
    

    
    NSArray *users = jsonObject[@"users"];
    for ( NSDictionary *user in users)
    {
        self.user_key = user[@"key"];
    
    }
    
    NSLog(@"user key %@", _user_key);
    
         dispatch_async(dispatch_get_main_queue(), ^{
             
             
         });
     }];
    [dataTask resume];
    
   // self.viewController.user_key = _user_key;
    [self.navigationController pushViewController:self.viewController animated:YES];
    
}

- (IBAction)signup:(id)sender
{
    
    
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