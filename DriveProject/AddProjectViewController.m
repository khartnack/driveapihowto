//
//  AddProjectViewController.m
//  DriveProject
//
//  Created by Dave Beltramini on 5/27/15.
//  Copyright (c) 2015 Katie Beltramini. All rights reserved.
//

#import "AddProjectViewController.h"
#import "ProjectViewController.h"
#import "ViewController.h"


@interface AddProjectViewController ()  <UINavigationControllerDelegate>
@property (strong, nonatomic) IBOutlet UILabel *ProjectName;
@property (weak, nonatomic) IBOutlet UITextField *projectField;
@property NSString *project;
@property NSString *customer_key;
@end

@implementation AddProjectViewController
@synthesize viewController;
@synthesize addProjectViewController;

- (void)setKey:(NSString *)key
{
    _key = key;
    
    NSLog(@"--key%@",key);
    
}

- (IBAction)addProject:(id)sender
{
    if([self.projectField.text isEqual: @""])
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
        self.project = self.projectField.text;
    }
    NSLog(@"key %@", _noteurl);

    self.customer_key = _noteurl;
    
    
    
    
    
    NSString *post = [NSString stringWithFormat: @"name=%@&customer_key=%@&", self.project, self.customer_key];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    NSString *fixedURL = [NSString stringWithFormat:@"http://cs496sp2015.appspot.com/project"];
    
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
    
    [self.navigationController popToRootViewControllerAnimated:YES];
  //  [self.navigationController popViewControllerAnimated:YES];
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
