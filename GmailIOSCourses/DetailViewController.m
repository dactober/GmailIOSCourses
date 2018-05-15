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
#import "MessageEntity+CoreDataClass.h"
#import "Message.h"

@interface DetailViewController ()
@property(nonatomic, strong) Coordinator *coordinator;
@property(nonatomic, strong) NSManagedObjectContext *context;
@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *deleteButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"remove"] style:UIBarButtonItemStylePlain target:self action:@selector(delete:)];
    deleteButton.tintColor = [UIColor blackColor];
    UIBarButtonItem *sendButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"reply"] style:UIBarButtonItemStylePlain target:self action:@selector(send:)];
    sendButton.tintColor = [UIColor blackColor];
    self.navigationItem.rightBarButtonItems = @[sendButton, deleteButton];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    self.subject.text = self.messageModel.subject;
    if ([self.messageModel.from containsString:@" <"]) {
        NSRange range = [self.messageModel.from rangeOfString:@" <"];
        NSString *shortString = [self.messageModel.from substringToIndex:range.location];
        self.from.text = shortString;
    } else {
        self.from.text = self.messageModel.from;
    }
    NSString *body =  self.messageModel.body;
    self.body.text = [body stringByReplacingOccurrencesOfString:@"/n" withString:@""];
}

- (void)setData:(MessageEntity *)inboxMessage coordinator:(Coordinator *)coordinator context:(NSManagedObjectContext *)context {
    self.coordinator = coordinator;
    self.messageModel = inboxMessage;
    self.context = context;
}

- (IBAction)send:(id)sender {
    SendViewController *send = [self.storyboard instantiateViewControllerWithIdentifier:@"Send"];
    [send setData:self.coordinator flag:true message:self.messageModel];
    [self.navigationController pushViewController:send animated:YES];
}

- (IBAction) delete:(id)sender {
    [self.coordinator deleteMessage:self.messageModel.messageID label:self.messageModel.label];
    dispatch_async(dispatch_get_main_queue(), ^{
      [self.navigationController popViewControllerAnimated:YES];
    });
}

@end
