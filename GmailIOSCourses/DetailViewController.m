//
//  DetailViewController.m
//  GmailIOSCourses
//
//  Created by Aleksey Drachyov on 5/9/17.
//  Copyright © 2017 Aleksey Drachyov. All rights reserved.
//

#import "DetailViewController.h"
#import "Coordinator.h"
#import "SendViewController.h"
#import "Inbox+CoreDataClass.h"
#import "Message.h"
@interface DetailViewController ()
@property(nonatomic,strong)Coordinator *coordinator;
@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.subject.text=self.inboxMessage.subject;
    if([self.inboxMessage.from containsString:@" <"]){
        
        NSRange range = [self.inboxMessage.from rangeOfString:@" <"];
        NSString *shortString = [self.inboxMessage.from substringToIndex:range.location];
        
        self.from.text=shortString;
        
        
    }else{
        self.from.text=self.inboxMessage.from;
    }
    
    self.body.text=self.inboxMessage.body;
}
-(void)setData:(Inbox *)inboxMessage coordinator:(Coordinator*)coordinator message:(Message *)message{
    self.coordinator=coordinator;
        self.inboxMessage=inboxMessage;
    self.message=message;
}
- (IBAction)send:(id)sender {
    SendViewController *send=[self.storyboard instantiateViewControllerWithIdentifier:@"Send"];
    [send setData:self.coordinator flag:true message:self.message];
    [self.navigationController pushViewController:send animated:YES];
    
}
- (IBAction)delete:(id)sender {
    [self.message deleteMessage:self.coordinator callback:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    }];
    
}


@end
