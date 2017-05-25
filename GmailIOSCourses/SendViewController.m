//
//  SendViewController.m
//  GmailIOSCourses
//
//  Created by Aleksey Drachyov on 5/9/17.
//  Copyright © 2017 Aleksey Drachyov. All rights reserved.
//

#import "SendViewController.h"
#import "Message.h"
#import "Inbox+CoreDataClass.h"
#import "Sent+CoreDataClass.h"
@interface SendViewController ()
@property (weak, nonatomic) IBOutlet UITextField *to;
@property (weak, nonatomic) IBOutlet UITextField *subject;
@property (weak, nonatomic) IBOutlet UITextView *body;
@property(strong,nonatomic)Inbox* inboxMessage;
@property(strong,nonatomic)Sent* sentMessage;

@end

@implementation SendViewController
bool boolean;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    if(boolean){
        if(self.inboxMessage!=nil){
            NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}";
            NSRegularExpression *regex = nil;
            regex = [NSRegularExpression regularExpressionWithPattern:emailRegex
                                                              options:NSRegularExpressionCaseInsensitive
                                                                error:nil];
            NSTextCheckingResult *match = [regex firstMatchInString:self.inboxMessage.from options:0 range:NSMakeRange(0, [self.inboxMessage.from length])];
            if(match!=nil){
                self.to.text= [self.inboxMessage.from substringWithRange:[match rangeAtIndex:0]];
            }
            
            self.subject.text=[NSString stringWithFormat:@"Re: %@",self.inboxMessage.subject];
        }else{
            NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}";
            NSRegularExpression *regex = nil;
            regex = [NSRegularExpression regularExpressionWithPattern:emailRegex
                                                              options:NSRegularExpressionCaseInsensitive
                                                                error:nil];
            NSTextCheckingResult *match = [regex firstMatchInString:self.sentMessage.from options:0 range:NSMakeRange(0, [self.sentMessage.from length])];
            if(match!=nil){
                self.to.text= [self.sentMessage.from substringWithRange:[match rangeAtIndex:0]];
            }
            
            self.subject.text=[NSString stringWithFormat:@"Re: %@",self.sentMessage.subject];
        }
        
    }
}
-(void)setData:(Coordinator*)coordinator flag:(bool)flag message:(Inbox*)message{
    self.coordinator=coordinator;
    self.inboxMessage=message;
    boolean=flag;
    
}

-(void)setDataForSent:(Coordinator*)coordinator flag:(bool)flag message:(Sent*)message{
    self.coordinator=coordinator;
    self.sentMessage=message;
    boolean=flag;
    
}

- (IBAction)sendMessage:(id)sender {
     [self.coordinator sendMessage:self.to.text subject:self.subject.text body:self.body.text];
    [self.navigationController popViewControllerAnimated:YES];
}


@end
