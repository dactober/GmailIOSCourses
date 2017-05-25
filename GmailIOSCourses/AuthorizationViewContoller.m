//
//  ViewController.m
//  GmailIOSCourses
//
//  Created by Aleksey Drachyov on 4/29/17.
//  Copyright © 2017 Aleksey Drachyov. All rights reserved.
//

#import "AuthorizationViewContoller.h"
#import "GTMOAuth2ViewControllerTouch.h"
#import "MainViewController.h"
#import "GTLRGmail.h"
#import "Coordinator.h"
#import "SettingsTableViewController.h"
#import "SentMessagesViewController.h"
@interface AuthorizationViewContoller()
@property (nonatomic, strong) GTLRGmailService *service;
@property(nonatomic,strong)SettingsTableViewController* settingsViewController;
@property(nonatomic,strong)SentMessagesViewController *sentViewController;
@property(nonatomic,strong)MainViewController *mainViewController;
@end

static NSString *accessToken;
static NSString *const kKeychainItemName = @"Google API";
static NSString *const kClientID = @"341159379147-rnod9n0vgg0sakksoqlt4ggbjdutrcjj.apps.googleusercontent.com";

@implementation AuthorizationViewContoller

// When the view loads, create necessary subviews, and initialize the Gmail AP
- (void)viewDidLoad {
    [super viewDidLoad];
    //[ GTMOAuth2ViewControllerTouch removeAuthFromKeychainForName:kKeychainItemName];
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:@"Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2228.0 Safari/537.36", @"UserAgent", nil];
    [[NSUserDefaults standardUserDefaults] registerDefaults:dictionary];
    // Initialize the Gmail API service & load existing credentials from the keychain if available.
    self.service = [[GTLRGmailService alloc] init];
    self.service.authorizer =
    [GTMOAuth2ViewControllerTouch authForGoogleFromKeychainForName:kKeychainItemName
                                                          clientID:kClientID
                                                      clientSecret:nil];
    
   
    
    
}
-(void)createMainViewController{
    self.mainViewController=[self.storyboard instantiateViewControllerWithIdentifier:@"Inbox"];
    Coordinator *coordinator=[[Coordinator alloc] initWithData:self.service.authorizer.userEmail accessToken:accessToken];
    self.settingsViewController=[self.storyboard instantiateViewControllerWithIdentifier:@"Settings"];
    self.sentViewController=[self.storyboard instantiateViewControllerWithIdentifier:@"Sent"];
    [self.sentViewController setCoordinator:coordinator];
    [self.mainViewController setCoordinator:coordinator];
    [self.mainViewController setSettingsViewController:self.settingsViewController];
    [self.mainViewController setSentMessagesViewController:self.sentViewController];
    [self.settingsViewController setCoordinator:coordinator];
    [self.settingsViewController setAuth:self];
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:self.mainViewController];
    
    UINavigationController* nav1 = [[UINavigationController alloc] initWithRootViewController:self.sentViewController];
   
    UINavigationController* nav2 = [[UINavigationController alloc] initWithRootViewController:self.settingsViewController];
    NSArray *tabViewControllers=@[nav,nav1,nav2];
        UITabBarController *tabController = [[UITabBarController alloc]init];
    [tabController setViewControllers:tabViewControllers];
    nav.tabBarItem =
    [[UITabBarItem alloc] initWithTitle:@"Inbox" image:nil tag:1];
    nav1.tabBarItem =
    [[UITabBarItem alloc] initWithTitle:@"Sent" image:nil tag:2];
    nav2.tabBarItem =
    [[UITabBarItem alloc] initWithTitle:@"Settings" image:nil tag:3];
    
    
   
    [self presentViewController:tabController animated:YES completion:nil];
}
// When the view appears, ensure that the Gmail API service is authorized, and perform API calls.
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    if (!self.service.authorizer.canAuthorize) {
        
        [self presentViewController:[self createAuthController] animated:YES completion:nil];
        
    } else {
        
        GTMOAuth2Authentication *auth = [GTMOAuth2ViewControllerTouch authForGoogleFromKeychainForName:kKeychainItemName
                                                                                              clientID:kClientID
                                                                                          clientSecret:nil];
        [auth authorizeRequest:nil
             completionHandler:^(NSError *error) {
                 if (error) {
                     NSLog(@"error: %@", error);
                 }
                 else {
                     accessToken=auth.accessToken;
                     [self createMainViewController];
                     
                     
                 }
             }];
    }
}




// Creates the auth controller for authorizing access to Gmail API.
- (GTMOAuth2ViewControllerTouch *)createAuthController {
    GTMOAuth2ViewControllerTouch *authController;
    // If modifying these scopes, delete your previously saved credentials by
    // resetting the iOS simulator or uninstall the app.
    NSArray *scopes = [NSArray arrayWithObjects:kGTLRAuthScopeGmailReadonly,kGTLRAuthScopeGmailMailGoogleCom,kGTLRAuthScopeGmailSend,kGTLRAuthScopeGmailInsert,kGTLRAuthScopeGmailLabels,kGTLRAuthScopeGmailCompose,kGTLRAuthScopeGmailSettingsBasic, nil];
    authController = [[GTMOAuth2ViewControllerTouch alloc]
                      initWithScope:[scopes componentsJoinedByString:@" "]
                      clientID:kClientID
                      clientSecret:nil
                      keychainItemName:kKeychainItemName
                      delegate:self
                      finishedSelector:@selector(viewController:finishedWithAuth:error:)];
    return authController;
}

// Handle completion of the authorization process, and update the Gmail API
// with the new credentials.
- (void)viewController:(GTMOAuth2ViewControllerTouch *)viewController
      finishedWithAuth:(GTMOAuth2Authentication *)authResult
                 error:(NSError *)error {
    if (error != nil) {
        [self showAlert:@"Authentication Error" message:error.localizedDescription];
        self.service.authorizer = nil;
    }
    else {
        self.service.authorizer = authResult;
        accessToken=authResult.accessToken;
        [self dismissViewControllerAnimated:YES completion:^{
            [self createMainViewController];
        }];
        
    }
}

// Helper for showing an alert
- (void)showAlert:(NSString *)title message:(NSString *)message {
    UIAlertController *alert =
    [UIAlertController alertControllerWithTitle:title
                                        message:message
                                 preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok =
    [UIAlertAction actionWithTitle:@"OK"
                             style:UIAlertActionStyleDefault
                           handler:^(UIAlertAction * action)
     {
         [alert dismissViewControllerAnimated:YES completion:nil];
     }];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
    
}
-(void)logOut:(NSURL*)url{
    NSError* error;
    [GTMOAuth2ViewControllerTouch removeAuthFromKeychainForName:kKeychainItemName];
    [[NSFileManager defaultManager]removeItemAtPath:url.path error:&error];
}

@end
