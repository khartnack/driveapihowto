//
//  ProjectViewController.m
//  DriveProject
//
//  Created by Dave Beltramini on 5/27/15.
//  Copyright (c) 2015 Katie Beltramini. All rights reserved.
//

#import "ProjectViewController.h"
#import "ViewController.h"


@interface ProjectViewController () <NSURLSessionDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, copy) NSArray *courses;
//@property (nonatomic, strong) NSString *key;

@end

@implementation ProjectViewController
//@synthesize projectViewController;

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.navigationItem.title = @"Customers";
        
        NSURLSessionConfiguration *config =
        [NSURLSessionConfiguration defaultSessionConfiguration];
        
        _session = [NSURLSession sessionWithConfiguration:config
                                                 delegate:self
                                            delegateQueue:nil];
        // Set the tab bar item's title
        //     self.tabBarItem.title = @"Notes";
        
      //  [self fetchFeed];
    }
    return self;
}

//- (void)viewDidLoad
//{
//   [super viewDidLoad];

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    [self.tableView registerClass:[UITableViewCell class]
           forCellReuseIdentifier:@"UITableViewCell"];
    
    
    
    //UIBarButtonItem *backButton = [[UIBarButtonItem alloc]initWithTitle:@"Info" style: UIBarButtonItemStylePlain    //target:self action:@selector(home)];
    
    // self.navigationItem.leftBarButtonItem = backButton;
    
    /* if(backButton.BNRQuizViewController == nil) {
     BNRQuizViewController  *view2 = [[BNRQuizViewController  alloc] initWithNibName:@"View2" bundle:[NSBundle mainBundle]];
     self.BNRQuizViewController  = view2;
     // [view2 release];
     }
     //test
     [self.navigationController pushViewController:self.BNRQuizViewController animated:YES];*/
    
    //UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addCustomer)];
    
    //NSArray *actionButtonItems = @[addItem];
    // self.navigationItem.rightBarButtonItems = actionButtonItems;
    
    
}

-(void)addCustomer{
    
    NSLog(@"navigation call for add");
    //  [self.navigationController pushViewController: NotesViewController animated:YES];
    
    //  [self.navigationController pushViewController:customerViewController animated:YES];
    [self fetchFeed];
    [self.tableView reloadData];
}

- (void)setURL:(NSURL *)URL
{
    _URL = URL;
    
    NSLog(@"--NSLOG%@",URL);
    if (_URL) {
        [self fetchFeed];
    }
}




- (void)fetchFeed
{
    
    NSURLRequest *req = [NSURLRequest requestWithURL:_URL cachePolicy:NSURLRequestReloadIgnoringCacheData
                                     timeoutInterval:60.0];
    
    NSURLSessionDataTask *dataTask =
    [self.session dataTaskWithRequest:req
                    completionHandler:
     ^(NSData *data, NSURLResponse *response, NSError *error) {
         
         
         NSLog(@"data -->%@", data);
         NSError *err = nil;
         NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data
                                                                    options:0
                                                                      error:&err];
         
         // NSLog(@"err %@",err);
         
         NSLog(@"jsonObject -->%@", jsonObject);
         self.courses = jsonObject[@"customer"];
         
         NSLog(@"courses -->%@", self.courses);
         
         dispatch_async(dispatch_get_main_queue(), ^{
             [self.tableView reloadData];
         });
     }];
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
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //NSLog(@"called");
    NSDictionary *course = self.courses[indexPath.row];
    
    NSString *noteurl = course[@"key"];
    
    NSLog(@"--%@",noteurl);
    
    NSString *someText = [NSString stringWithFormat: @"http://customer-proj.appspot.com/customer/%@",noteurl];
    NSURL *URL= [NSURL URLWithString:someText];
    //NSURL *URL = [NSURL URLWithString:course[@"someText"]];
    
    
    
    NSLog(@"--%@",URL);
    
    // self.customerInfoViewController.title = course[@"name"];
    //   self.customerInfoViewController.URL = URL;
    
    //   [self.navigationController pushViewController:self.projectViewController animated:YES];
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
