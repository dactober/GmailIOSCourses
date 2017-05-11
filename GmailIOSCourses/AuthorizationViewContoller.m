//
//  ViewController.m
//  GmailIOSCourses
//
//  Created by Aleksey Drachyov on 4/29/17.
//  Copyright © 2017 Aleksey Drachyov. All rights reserved.
//

#import "AuthorizationViewContoller.h"
static NSString *accessToken;
static NSString *const kKeychainItemName = @"Google API";
static NSString *const kClientID = @"341159379147-rnod9n0vgg0sakksoqlt4ggbjdutrcjj.apps.googleusercontent.com";

@implementation AuthorizationViewContoller

// When the view loads, create necessary subviews, and initialize the Gmail API service.
- (void)viewDidLoad {
    [super viewDidLoad];
   // [ GTMOAuth2ViewControllerTouch removeAuthFromKeychainForName:kKeychainItemName];
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
    self.mainViewController=[self.storyboard instantiateViewControllerWithIdentifier:@"Main"];
    Coordinator *coordinator=[[Coordinator alloc] initWithData:self.service.authorizer.userEmail accessToken:accessToken];
    [self.mainViewController setCoordinator:coordinator];
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:self.mainViewController];
    [self presentViewController:nav animated:YES completion:nil];
}
// When the view appears, ensure that the Gmail API service is authorized, and perform API calls.
- (void)viewDidAppear:(BOOL)animated {
    if (!self.service.authorizer.canAuthorize) {
        // Not yet authorized, request authorization by pushing the login UI onto the UI stack.
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
    NSArray *scopes = [NSArray arrayWithObjects:kGTLRAuthScopeGmailReadonly,kGTLRAuthScopeGmailModify,kGTLRAuthScopeGmailMailGoogleCom,kGTLRAuthScopeGmailSend,kGTLRAuthScopeGmailInsert,kGTLRAuthScopeGmailLabels,kGTLRAuthScopeGmailCompose,kGTLRAuthScopeGmailSettingsBasic,kGTLRAuthScopeGmailSettingsSharing, nil];
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
        [self createMainViewController];
        
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


@end
