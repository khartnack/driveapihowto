//
//  AccountViewController.m
//  DriveProject
//
//  Created by Dave Beltramini on 5/29/15.
//  Copyright (c) 2015 Katie Beltramini. All rights reserved.
//

#import "AccountViewController.h"

@interface AccountViewController ()
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *passwordLabel;
@property (weak, nonatomic) IBOutlet UITextField *usernameText;
@property (weak, nonatomic) IBOutlet UITextField *passwordText;
@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *pwd;

@end

@implementation AccountViewController
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


- (IBAction)createAccount:(id)sender
{
    
    self.username = self.usernameText.text;
    self.pwd = self.passwordText.text;
    if([self.self.usernameText.text isEqual: @""])
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
        self.username = self.usernameText.text;
    }
 

    
    NSString *post = [NSString stringWithFormat: @"username=%@&pwd=%@&", self.username, self.pwd];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    NSString *fixedURL = [NSString stringWithFormat:@"http://may29proj.appspot.com/customer"];
    
    [request setURL:[NSURL URLWithString:fixedURL]];
    [request setHTTPMethod:@"POST"];
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
    
    //  [self.navigationController pushViewController:self.viewController animated:YES];
    
    //[self.navigationController popToRootViewControllerAnimated:YES];
    //  self.viewController.user_key = self.user_key;
    //  NSLog(@"user key %@", self.user_key);
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
