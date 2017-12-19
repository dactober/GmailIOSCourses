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
#import "SentMessagesViewController.h"
@interface AuthorizationViewContoller() 
@property (nonatomic, strong)GTLRGmailService *service;
@property (nonatomic, strong)SettingsTableViewController* settingsViewController;
@property (nonatomic, strong)SentMessagesViewController *sentViewController;
@property (nonatomic, strong)MainViewController *mainViewController;
@property (nonatomic, strong)UIStoryboard *storyboard;
@property (nonatomic, strong)UIWindow *window;
@property (nonatomic, strong)Coordinator *coordinator;
@end

static NSString *accessToken;
static NSString *const kKeychainItemName = @"Google API";
static NSString *const kClientID = @"341159379147-rnod9n0vgg0sakksoqlt4ggbjdutrcjj.apps.googleusercontent.com";

@implementation AuthorizationViewContoller

- (instancetype)initWithWindow:(UIWindow *)window {
    self=[super init];
    if(self) {
        self.window=window;
        self.storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:@"Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2228.0 Safari/537.36", @"UserAgent", nil];
        [[NSUserDefaults standardUserDefaults] registerDefaults:dictionary];
        self.service = [[GTLRGmailService alloc] init];
        self.service.authorizer =
        [GTMOAuth2ViewControllerTouch authForGoogleFromKeychainForName:kKeychainItemName clientID:kClientID clientSecret:nil];
    }
    return self;
}

- (void)addMainViewController {
    self.mainViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Inbox"];
    self.coordinator = [[Coordinator alloc] initWithData:self.service.authorizer.userEmail accessToken:accessToken];
    self.settingsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Settings"];
    self.sentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Sent"];
    [self.sentViewController setCoordinator:self.coordinator];
    [self.mainViewController setCoordinator:self.coordinator];
    [self.mainViewController setSentMessagesViewController:self.sentViewController];
    [self.settingsViewController setCoordinator:self.coordinator];
    self.settingsViewController.delegate = self;
    [self addTabBarController];
    [self.window makeKeyAndVisible];
}

- (void)addTabBarController {
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:self.mainViewController];
    UINavigationController* nav1 = [[UINavigationController alloc] initWithRootViewController:self.sentViewController];
    UINavigationController* nav2 = [[UINavigationController alloc] initWithRootViewController:self.settingsViewController];
    NSArray *tabViewControllers=@[nav,nav1,nav2];
    UITabBarController *tabController = [[UITabBarController alloc]init];
    [tabController setViewControllers:tabViewControllers];
    nav.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Inbox" image:nil tag:1];
    nav1.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Sent" image:nil tag:2];
    nav2.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Settings" image:nil tag:3];
    [self.window setRootViewController:tabController];
}

- (void)addAuthorizationViewController {
    if (!self.service.authorizer.canAuthorize) {
        [self.window setRootViewController:[self createAuthController]];
        [self.window makeKeyAndVisible];
    } else {
        GTMOAuth2Authentication *auth = [GTMOAuth2ViewControllerTouch authForGoogleFromKeychainForName:kKeychainItemName clientID:kClientID clientSecret:nil];
        [auth authorizeRequest:nil completionHandler:^(NSError *error) {
            if (error) {
                NSLog(@"error: %@", error);
            } else {
                accessToken=auth.accessToken;
                [self addMainViewController];
            }
        }];
    }
}

- (GTMOAuth2ViewControllerTouch *)createAuthController {
    GTMOAuth2ViewControllerTouch *authController;
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

- (void)viewController:(GTMOAuth2ViewControllerTouch *)viewController
      finishedWithAuth:(GTMOAuth2Authentication *)authResult
                 error:(NSError *)error {
    if (error != nil) {
        self.service.authorizer = nil;
    }
    else {
        self.service.authorizer = authResult;
        accessToken=authResult.accessToken;
        [self addMainViewController];
    }
}

- (void)logOut {
    NSError* error;
    NSURL *url = [self.coordinator.contForMessages storeURL];
    [GTMOAuth2ViewControllerTouch removeAuthFromKeychainForName:kKeychainItemName];
    [[NSFileManager defaultManager]removeItemAtPath:url.path error:&error];
    self.settingsViewController.delegate = nil;
    [self.window setRootViewController:[self createAuthController]];
}

@end
