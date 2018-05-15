//
//  SendViewController.m
//  GmailIOSCourses
//
//  Created by Aleksey Drachyov on 5/9/17.
//  Copyright © 2017 Aleksey Drachyov. All rights reserved.
//

#import "SendViewController.h"
#import "Message.h"
#import "MessageEntity+CoreDataClass.h"
@interface SendViewController ()<UITextViewDelegate>
@property(weak, nonatomic) IBOutlet UITextField *to;
@property(weak, nonatomic) IBOutlet UITextField *subject;
@property(weak, nonatomic) IBOutlet UITextView *body;
@property(strong, nonatomic) MessageEntity *message;
@property(assign, nonatomic) BOOL isReply;
@end

@implementation SendViewController
bool boolean;
- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *sendButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Send_mail"] style:UIBarButtonItemStylePlain target:self action:@selector(sendMessage:)];
    sendButton.tintColor = [UIColor blackColor];
    self.navigationItem.rightBarButtonItems = @[sendButton];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.body.delegate = self;
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    if (self.isReply) {
        [self setTextFieldsEnabled:!self.isReply];
        if (self.message) {
            NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}";
            NSRegularExpression *regex = nil;
            regex = [NSRegularExpression regularExpressionWithPattern:emailRegex options:NSRegularExpressionCaseInsensitive error:nil];
            NSTextCheckingResult *match = [regex firstMatchInString:self.message.from options:0 range:NSMakeRange(0, [self.message.from length])];
            if (match) {
                self.to.text = [self.message.from substringWithRange:[match rangeAtIndex:0]];
            }
            self.subject.text = [NSString stringWithFormat:@"Re: %@", self.message.subject];
        }
    }
}

- (void)setTextFieldsEnabled:(BOOL)enabled {
    self.to.userInteractionEnabled = enabled;
    self.subject.userInteractionEnabled = enabled;
}

- (void)setData:(Coordinator *)coordinator flag:(bool)flag message:(MessageEntity *)message {
    self.coordinator = coordinator;
    self.message = message;
    self.isReply = flag;
}

- (IBAction)sendMessage:(id)sender {
    [self.coordinator sendMessage:self.to.text subject:self.subject.text body:self.body.text];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    textView.text = @"";
    textView.textColor = [UIColor blackColor];
}

@end
