//
//  DriveAuthorizationViewController.m
//  GmailIOSCourses
//
//  Created by Aleksey Drachyov on 5/3/18.
//  Copyright © 2018 Aleksey Drachyov. All rights reserved.
//

#import "DriveAuthorizationViewController.h"
#import <Google/SignIn.h>
#import "GTLRDrive.h"
#import "DriveViewController.h"
#import "LoadingViewController.h"
#import <GTMSessionFetcher/GTMSessionFetcherService.h>
#import <GTMSessionFetcher/GTMSessionFetcherLogging.h>
#import <GoogleAPIClientForREST/GTLRUtilities.h>

static NSString *accessToken;
static NSString *const kKeychainItemName = @"Google API";
static NSString *const kClientID = @"341159379147-utrggbj15aghj07mj675512os6mupefb.apps.googleusercontent.com";
@interface DriveAuthorizationViewController ()<GIDSignInDelegate, GIDSignInUIDelegate, LGSideMenuDelegate>
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (nonatomic, strong) IBOutlet GIDSignInButton *signInButton;
@property (nonatomic, strong) GTLRDriveService *service;
@property (nonatomic, strong) GIDSignIn *signIn;
@end

@implementation DriveAuthorizationViewController

- (instancetype)initWithMenuController:(LGSideMenuController *)sideMenu {
    self = [super init];
    if (self) {
        self.sideMenu = sideMenu;
    }
    return self;
}

+ (instancetype)controllerWithMenuController:(LGSideMenuController *)sideMenu {
    return [[self alloc] initWithMenuController:sideMenu];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //[self logout];
    [self showLoading:[LoadingViewController sharedInstance] containerView:self.view];
    self.navigationController.navigationBarHidden = YES;
    self.signIn = [GIDSignIn sharedInstance];
    self.signIn.delegate = self;
    self.signIn.uiDelegate = self;
    self.service = [[GTLRDriveService alloc] init];
    [self.signIn signInSilently];
    
    self.signInButton = [[GIDSignInButton alloc] init];
    [self.containerView addSubview:self.signInButton];
    self.signInButton.style = kGIDSignInButtonStyleWide;
}

// When the view loads, create necessary subviews, and initialize the Gmail AP

- (void)signIn:(GIDSignIn *)signIn didSignInForUser:(GIDGoogleUser *)user withError:(NSError *)error {
    if (error != nil) {
        [self hideLoading:[LoadingViewController sharedInstance]];
        self.service.authorizer = nil;
    } else {
        self.signInButton.hidden = true;
        self.service.authorizer = user.authentication.fetcherAuthorizer;
        accessToken = user.authentication.accessToken;
        [self createMainViewController];
    }
}

- (void)createMainViewController {
    [self hideLoading:[LoadingViewController sharedInstance]];
    DriveViewController *controller = [[DriveViewController alloc] initWithService:self.service delegate:self];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)showLeftView {
    [self.sideMenu showLeftViewAnimated:YES completionHandler:nil];
}

- (void)displayResultWithTicket:(GTLRServiceTicket *)ticket finishedWithObject:(GTLRDrive_FileList *)labelsResponse error:(NSError *)error {
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

- (void)logout {
    GTLRDriveService *service = self.service;
    GIDSignIn *signIn = [GIDSignIn sharedInstance];
    [signIn signOut];
}

@end
