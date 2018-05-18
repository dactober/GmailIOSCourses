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
#import "GMLeftMenuViewController.h"
#import <LGSideMenuController/LGSideMenuController.h>
#import <LGSideMenuController/UIViewController+LGSideMenuController.h>
#import "DriveAuthorizationViewController.h"
#import "GTLRDrive.h"
#import "LoadingViewController.h"
#import <GTLRCalendar.h>
#import "CalendarViewController.h"

typedef NS_ENUM(NSUInteger, TabItemType) {
    TabItemTypeInbox,
    TabItemTypeSent,
    TabItemTypeSettings
};

@interface AuthorizationViewContoller ()<LGSideMenuDelegate>
@property(weak, nonatomic) IBOutlet UIView *containerView;
@property(nonatomic, strong) LGSideMenuController *menuController;

@end

static NSString *accessToken;
static NSString *const kKeychainItemName = @"Google API";
static NSString *const kClientID = @"341159379147-utrggbj15aghj07mj675512os6mupefb.apps.googleusercontent.com";

@implementation AuthorizationViewContoller

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.menuController = nil;
    [self showLoading:[LoadingViewController sharedInstance] containerView:self.view];
    self.navigationController.navigationBarHidden = YES;
    GIDSignIn *signIn = [GIDSignIn sharedInstance];
    signIn.delegate = self;
    signIn.uiDelegate = self;
    [GIDSignIn sharedInstance].scopes = @[
                                          kGTLRAuthScopeGmailReadonly, kGTLRAuthScopeGmailSend, kGTLRAuthScopeGmailMailGoogleCom, kGTLRAuthScopeGmailSettingsBasic, kGTLRAuthScopeGmailInsert,
                                          kGTLRAuthScopeGmailCompose, kGTLRAuthScopeDrive, kGTLRAuthScopeDriveFile, kGTLRAuthScopeDriveAppdata, kGTLRAuthScopeDriveMetadata, kGTLRAuthScopeCalendar
                                          ];
    [signIn signInSilently];
    
    self.signInButton = [[GIDSignInButton alloc] init];
    [self.view addSubview:self.signInButton];
    self.signInButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.signInButton.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor].active = YES;
    [self.signInButton.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;
    self.signInButton.style = kGIDSignInButtonStyleWide;
    self.service = [[GTLRGmailService alloc] init];
}

// When the view loads, create necessary subviews, and initialize the Gmail AP

- (void)signIn:(GIDSignIn *)signIn didSignInForUser:(GIDGoogleUser *)user withError:(NSError *)error {
    [self hideLoading:[LoadingViewController sharedInstance]];
    if (error != nil) {
        self.service.authorizer = nil;
    } else {
        self.signInButton.hidden = true;
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
    Coordinator *coordinator = [[Coordinator alloc] initWithEmail:[GIDSignIn sharedInstance].currentUser.userID accessToken:accessToken];
    
    MainViewController *mainViewController = [MainViewController controllerWithCoordinator:coordinator delegate:self];
    SentMessagesViewController *sentViewController = [SentMessagesViewController controllerWithCoordinator:coordinator];
    DriveAuthorizationViewController *driveAuthController = [DriveAuthorizationViewController new];
    CalendarViewController *calendarViewController = [CalendarViewController new];
    UINavigationController *driveNavController = [[UINavigationController alloc] initWithRootViewController:driveAuthController];
    UINavigationController *calendarNavController = [[UINavigationController alloc] initWithRootViewController:calendarViewController];
    NSArray <UINavigationController *> *tabViewControllers = [self tabViewControllers:@[mainViewController, sentViewController]];
    UITabBarController *tabController = [self createTabBarControllerWithViewControllers:tabViewControllers];
    GMLeftMenuViewController *leftViewController = [GMLeftMenuViewController leftMenuWithItems:@[tabController, driveNavController, calendarNavController]];
    
    self.menuController = [LGSideMenuController sideMenuControllerWithRootViewController:tabController leftViewController:leftViewController rightViewController:nil];
    self.menuController.leftViewWidth = 250;
    self.menuController.leftViewBackgroundColor = [UIColor whiteColor];
    self.menuController.leftViewPresentationStyle = LGSideMenuPresentationStyleSlideBelow;
    driveAuthController.sideMenu = self.menuController;
    calendarViewController.delegate = self;
    [self.navigationController pushViewController:self.menuController animated:YES];
}

- (void)showLeftView {
    [self.menuController showLeftViewAnimated:YES completionHandler:nil];
}

- (NSArray <UINavigationController *> *)tabViewControllers:(NSArray *)viewControllers {
    NSMutableArray *tabViewControllers = [NSMutableArray new];
    for (UIViewController *controller in viewControllers) {
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:controller];
        [self setupNavigationItemForViewController:controller];
        [tabViewControllers addObject:nav];
    }
    return tabViewControllers;
}

- (void)setupNavigationItemForViewController:(UIViewController *)viewController {
    viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"hamburger"] style:UIBarButtonItemStyleDone target:self action:@selector(showLeftView)];
    viewController.navigationItem.leftBarButtonItem.tintColor = [UIColor blackColor];
}

- (UITabBarController *)createTabBarControllerWithViewControllers:(NSArray <UINavigationController *> *)viewControllers {
    UITabBarController *controller = [UITabBarController new];
    for (int i = 0; i < viewControllers.count; i++) {
        viewControllers[i].tabBarItem = [[UITabBarItem alloc] initWithTitle:[self mapping][@(i)] image:[self imageMapping][@(i)] tag:i];
        [viewControllers[i].navigationBar setBackgroundImage:[self imageFromLayer:[self gradientForView:viewControllers[i].navigationBar]] forBarMetrics:UIBarMetricsDefault];
    }
    controller.tabBar.tintColor = [UIColor blackColor];
    [controller.tabBar.layer insertSublayer:[self gradientForTabBar:controller.tabBar] atIndex:0];
    [controller setViewControllers:viewControllers];
    return controller;
}

- (UIImage *)imageFromLayer:(CALayer *)layer
{
    UIGraphicsBeginImageContext([layer frame].size);
    
    [layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return outputImage;
}

- (CAGradientLayer *)gradientForView:(UIView *)view {
    CAGradientLayer *gradient = [CAGradientLayer layer];
    CGRect gradientFrame = self.navigationController.navigationBar.bounds;
    gradientFrame.size.height += [UIApplication sharedApplication].statusBarFrame.size.height;
    gradient.frame = gradientFrame;
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithRed:137/255.0 green:207/255.0 blue:240/255.0 alpha:1.0] CGColor],(id)[[UIColor colorWithRed:122/255.0 green:192/255.0 blue:225/255.0 alpha:1.0] CGColor], nil];
    return gradient;
}

- (CAGradientLayer *)gradientForTabBar:(UITabBar *)view {
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = view.bounds;
    gradient.startPoint = CGPointZero;
    gradient.endPoint = CGPointMake(1, 1);
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithRed:137/255.0 green:207/255.0 blue:240/255.0 alpha:1.0] CGColor],(id)[[UIColor colorWithRed:122/255.0 green:192/255.0 blue:225/255.0 alpha:1.0] CGColor], nil];
    return gradient;
}

- (NSDictionary *)mapping {
    return @{
             @(TabItemTypeInbox) : @"Inbox",
             @(TabItemTypeSent) : @"Sent",
             };
}

- (NSDictionary *)imageMapping {
    return @{
             @(TabItemTypeInbox) : [UIImage imageNamed:@"inbox"],
             @(TabItemTypeSent) : [UIImage imageNamed:@"sentTab"],
             };
}

@end
