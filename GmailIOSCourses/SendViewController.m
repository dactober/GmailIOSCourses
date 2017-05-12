//
//  SendViewController.m
//  GmailIOSCourses
//
//  Created by Aleksey Drachyov on 5/9/17.
//  Copyright © 2017 Aleksey Drachyov. All rights reserved.
//

#import "SendViewController.h"

@interface SendViewController ()
@property (weak, nonatomic) IBOutlet UITextField *to;
@property (weak, nonatomic) IBOutlet UITextField *subject;
@property (weak, nonatomic) IBOutlet UITextView *body;

@end

@implementation SendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
-(void)setData:(Coordinator*)coordinator{
    self.coordinator=coordinator;
}



- (IBAction)sendMessage:(id)sender {
     [self.coordinator sendMessage:self.to.text subject:self.subject.text body:self.body.text];
    [self.navigationController popViewControllerAnimated:YES];
}


@end
