//
//  AddProjectViewController.m
//  DriveProject
//
//  Created by Dave Beltramini on 5/27/15.
//  Copyright (c) 2015 Katie Beltramini. All rights reserved.
//

#import "AddProjectViewController.h"

@interface AddProjectViewController ()
@property (strong, nonatomic) IBOutlet UILabel *ProjectName;
@property (weak, nonatomic) IBOutlet UITextField *projectField;
@property NSString *project;
@property NSString *customer_key;
@end

@implementation AddProjectViewController



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

    self.customer_key = _customer_key;
    
    
    
    
    
    NSString *post = [NSString stringWithFormat: @"project=%@&customer_key=%@&", self.project, self.customer_key];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    NSString *fixedURL = [NSString stringWithFormat:@"http://customer-proj.appspot.com/project/"];
    
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
