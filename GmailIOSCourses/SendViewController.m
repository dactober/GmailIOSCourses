//
//  SendViewController.m
//  GmailIOSCourses
//
//  Created by Aleksey Drachyov on 5/9/17.
//  Copyright © 2017 Aleksey Drachyov. All rights reserved.
//

#import "SendViewController.h"
#import "Message.h"
@interface SendViewController ()
@property (weak, nonatomic) IBOutlet UITextField *to;
@property (weak, nonatomic) IBOutlet UITextField *subject;
@property (weak, nonatomic) IBOutlet UITextView *body;
@property(strong,nonatomic)Message* message;

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
        self.to.text=self.message.from;
        self.subject.text=[NSString stringWithFormat:@"Re: %@",self.message.subject];
    }
}
-(void)setData:(Coordinator*)coordinator flag:(bool)flag message:(Message*)message{
    self.coordinator=coordinator;
    self.message=message;
    boolean=flag;
    
}



- (IBAction)sendMessage:(id)sender {
     [self.coordinator sendMessage:self.to.text subject:self.subject.text body:self.body.text];
    [self.navigationController popViewControllerAnimated:YES];
}


@end
