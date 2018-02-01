//
//  ViewController.m
//  GmailIOSCourses
//
//  Created by Aleksey Drachyov on 4/29/17.
//  Copyright © 2017 Aleksey Drachyov. All rights reserved.
//

#import "AuthorizationViewContoller.h"
#import "MainViewController.h"
#import "Coordinator.h"
#import "SettingsTableViewController.h"
#import "SentMessagesViewController.h"
@interface AuthorizationViewContoller ()
@property(nonatomic, strong) SettingsTableViewController *settingsViewController;
@property(nonatomic, strong) SentMessagesViewController *sentViewController;
@property(nonatomic, strong) MainViewController *mainViewController;
@property(weak, nonatomic) IBOutlet UIView *containerView;
@end

static NSString *accessToken;
static NSString *const kKeychainItemName = @"Google API";
static NSString *const kClientID = @"341159379147-rnod9n0vgg0sakksoqlt4ggbjdutrcjj.apps.googleusercontent.com";

@implementation AuthorizationViewContoller

- (void)viewDidLoad {
    [super viewDidLoad];
    // Configure Google Sign-in.
    GIDSignIn *signIn = [GIDSignIn sharedInstance];
    signIn.delegate = self;
    signIn.uiDelegate = self;
    signIn.scopes = @[
        kGTLRAuthScopeGmailReadonly, kGTLRAuthScopeGmailSend, kGTLRAuthScopeGmailMailGoogleCom, kGTLRAuthScopeGmailSettingsBasic, kGTLRAuthScopeGmailInsert,
        kGTLRAuthScopeGmailCompose
    ];
    [signIn signInSilently];

    // Add the sign-in button.
    self.signInButton = [[GIDSignInButton alloc] init];
    [self.containerView addSubview:self.signInButton];
    self.signInButton.style = kGIDSignInButtonStyleWide;
    // Create a UITextView to display output.
    self.output = [[UITextView alloc] initWithFrame:self.view.bounds];
    self.output.editable = false;
    self.output.contentInset = UIEdgeInsetsMake(20.0, 0.0, 20.0, 0.0);
    self.output.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.output.hidden = true;
    [self.view addSubview:self.output];

    // Initialize the service object.
    self.service = [[GTLRGmailService alloc] init];
}

// When the view loads, create necessary subviews, and initialize the Gmail AP

- (void)signIn:(GIDSignIn *)signIn didSignInForUser:(GIDGoogleUser *)user withError:(NSError *)error {
    if (error != nil) {
        [self showAlert:@"Authentication Error" message:error.localizedDescription];
        self.service.authorizer = nil;
    } else {
        self.signInButton.hidden = true;
        self.output.hidden = false;
        self.service.authorizer = user.authentication.fetcherAuthorizer;
        accessToken = user.authentication.accessToken;
        [self createMainViewController];
    }
}

- (void)displayResultWithTicket:(GTLRServiceTicket *)ticket finishedWithObject:(GTLRGmail_ListLabelsResponse *)labelsResponse error:(NSError *)error {
    if (error == nil) {
        [self createMainViewController];
    } else {
        [self showAlert:@"Error" message:error.localizedDescription];
    }
}

// Helper for showing an alert
- (void)showAlert:(NSString *)title message:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK"
                                                 style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction *action) {
                                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                               }];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)createMainViewController {
    Coordinator *coordinator = [[Coordinator alloc] initWithEmail:self.service.authorizer.userEmail accessToken:accessToken];
    self.mainViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Inbox"];
    self.settingsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Settings"];
    self.sentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Sent"];
    [self.sentViewController setCoordinator:coordinator];
    [self.mainViewController setCoordinator:coordinator];
    [self.settingsViewController setCoordinator:coordinator];
    self.mainViewController.settingsViewController = self.settingsViewController;
    self.mainViewController.sentMessagesViewController = self.sentViewController;
    self.settingsViewController.delegate = (id)self;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:self.mainViewController];
    UINavigationController *nav1 = [[UINavigationController alloc] initWithRootViewController:self.sentViewController];
    UINavigationController *nav2 = [[UINavigationController alloc] initWithRootViewController:self.settingsViewController];
    NSArray *tabViewControllers = @[ nav, nav1, nav2 ];
    UITabBarController *tabController = [[UITabBarController alloc] init];
    [tabController setViewControllers:tabViewControllers];
    nav.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Inbox" image:nil tag:1];
    nav1.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Sent" image:nil tag:2];
    nav2.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Settings" image:nil tag:3];
    [self presentViewController:tabController animated:YES completion:nil];
}

//- (void)logOut:(NSURL *)url {
//    NSError *error;
//    [GTMOAuth2ViewControllerTouch removeAuthFromKeychainForName:kKeychainItemName];
//    [[NSFileManager defaultManager] removeItemAtPath:url.path error:&error];
//    [self.window setRootViewController:[self createAuthController]];
//}

@end
