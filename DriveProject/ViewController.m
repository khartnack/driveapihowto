//
//  CustomerViewController.m
//  DriveProject
//
//  Created by Dave Beltramini on 5/27/15.
//  Copyright (c) 2015 Katie Beltramini. All rights reserved.
//

#import "ViewController.h"
#import "ProjectViewController.h"
#import "AddProjectViewController.h"
#import "EditViewController.h"
#import "LoginViewController.h"
#import "AddCustomerViewController.h"

@interface ViewController () <NSURLSessionDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, copy) NSArray *courses;
//@property (nonatomic, strong) NSString *key;

@end

@implementation ViewController
@synthesize projectViewController;
@synthesize addCustomerViewController;



- (instancetype)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.navigationItem.title = @"Customers";
        
        NSLog(@"instance type key %@", _user_key);
        self.user_key = _user_key;
        NSURLSessionConfiguration *config =
        [NSURLSessionConfiguration defaultSessionConfiguration];
        
        _session = [NSURLSession sessionWithConfiguration:config
                                                 delegate:self
                                            delegateQueue:nil];
        // Set the tab bar item's title
        //     self.tabBarItem.title = @"Notes";
        
       [self fetchFeed];
    }
    return self;
}

//- (void)viewDidLoad
//{
//   [super viewDidLoad];

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.user_key = _user_key;
    [self.tableView registerClass:[UITableViewCell class]
           forCellReuseIdentifier:@"UITableViewCell"];
    self.user_key=_user_key;
    NSLog(@"did load %@", _user_key);
    
    
    UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addCustomer)];
    
    NSArray *actionButtonItems = @[addItem];
    self.navigationItem.rightBarButtonItems = actionButtonItems;
    
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]initWithTitle:@"Logout" style: UIBarButtonItemStylePlain    target:self action:@selector(logout)];
    self.navigationItem.leftBarButtonItem = backButton;
    
    [self fetchFeed];
    
    
}

-(void)logout{
     [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)addCustomer{
    
    NSLog(@"navigation call for add");
    
    self.addCustomerViewController.noteurl = _noteurl;
    self.addCustomerViewController.user_key = _user_key;
    NSLog(@"_user_key %@", _user_key);
          NSLog(@"_user_key %@", self.addCustomerViewController.user_key);
    [self.navigationController pushViewController:addCustomerViewController animated:YES];
    
    //  [self.navigationController pushViewController:customerViewController animated:YES];
    // [self fetchFeed];
    // [self.tableView reloadData];
    
}




- (void)fetchFeed
{
    
    self.user_key = _user_key;
    NSLog(@"_user_key in fetchfeed %@", self.user_key);
    //https://bookapi.bignerdranch.com/private/courses.json
   //NSString *someText = [NSString stringWithFormat: @"http://cs496sp2015.appspot.com/customer/%@",noteurl];
    NSString *requestString = [NSString stringWithFormat: @"http://may29proj.appspot.com/customer&id=%@/", self.user_key];
    NSLog(@"requestString %@", requestString);
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
         self.courses = jsonObject[@"customers"];
         
         NSLog(@"%@", self.courses);
         
         dispatch_async(dispatch_get_main_queue(), ^{
             [self.tableView reloadData];
         });
     }];
    [dataTask resume];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.courses count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell =
    [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"
                                    forIndexPath:indexPath];
    
    NSDictionary *course = self.courses[indexPath.row];
    cell.textLabel.text = course[@"name"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //NSLog(@"called");
    NSDictionary *course = self.courses[indexPath.row];
    
    NSString *noteurl = course[@"key"];
    
    NSLog(@"--%@",noteurl);
    
    NSString *someText = [NSString stringWithFormat: @"http://cs496sp2015.appspot.com/customer/%@/project",noteurl];
    NSURL *URL= [NSURL URLWithString:someText];
    //NSURL *URL = [NSURL URLWithString:course[@"someText"]];
    
    
    
    NSLog(@"--%@",URL);
    
    self.projectViewController.title = course[@"name"];
    self.projectViewController.URL = URL;
    self.projectViewController.noteurl = noteurl;
    //self.projectViewController.customer = course[@"key"];
    
    [self.navigationController pushViewController:self.projectViewController animated:YES];
}




- (void)  URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
 didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
   completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential *))completionHandler
{
    NSLog(@"here");
    NSURLCredential *cred =
    [NSURLCredential credentialWithUser:@"BigNerdRanch"
                               password:@"AchieveNerdvana"
     //                           persistence:NSURLCredentialPersistenceNone];
                            persistence:NSURLCredentialPersistenceForSession];
    completionHandler(NSURLSessionAuthChallengeUseCredential, cred);
    
}





@end
