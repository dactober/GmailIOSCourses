//
//  WebLinkViewController.m
//  GmailIOSCourses
//
//  Created by Aleksey Drachyov on 5/14/18.
//  Copyright © 2018 Aleksey Drachyov. All rights reserved.
//

#import "WebLinkViewController.h"
#import "LoadingViewController.h"

@interface WebLinkViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property (nonatomic, strong) NSURLRequest *request;
@end

@implementation WebLinkViewController

- (instancetype)initWithRequest:(NSURLRequest *)request {
    self = [super init];
    if (self) {
        self.request = request;
    }
    return self;
}

+ (instancetype)controllerWithRequest:(NSURLRequest *)request {
    return [[self alloc] initWithRequest:request];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.backBarButtonItem.tintColor = UIColor.blackColor;
    self.webView.delegate = self;
    [self.webView loadRequest:self.request];
    // Do any additional setup after loading the view from its nib.
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [self showLoading:[LoadingViewController sharedInstance] containerView:self.view];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self hideLoading:[LoadingViewController sharedInstance]];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    return YES;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [self alertWithTitle:error.description message:nil];
}

- (void)alertWithTitle:(NSString *)title message:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:nil];
        [self.navigationController popViewControllerAnimated:YES];
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
