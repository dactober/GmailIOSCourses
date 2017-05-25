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
#import "Sent+CoreDataClass.h"

@interface DetailViewController ()
@property(nonatomic,strong)Coordinator *coordinator;
@property(nonatomic,strong) NSManagedObjectContext *context;
@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    if(self.sentMessage!=nil){
        self.subject.text=self.sentMessage.subject;
        if([self.sentMessage.from containsString:@" <"]){
            
            NSRange range = [self.sentMessage.from rangeOfString:@" <"];
            NSString *shortString = [self.sentMessage.from substringToIndex:range.location];
            
            self.from.text=shortString;
            
            
        }else{
            self.from.text=self.sentMessage.from;
        }
        
        self.body.text=self.sentMessage.body;
    }else{
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
    
}
-(void)setData:(Inbox *)inboxMessage coordinator:(Coordinator*)coordinator context:(NSManagedObjectContext*)context{
    self.coordinator=coordinator;
        self.inboxMessage=inboxMessage;
    self.context=context;
    
}
-(void)setDataForSent:(Sent *)sentMessage coordinator:(Coordinator*)coordinator context:(NSManagedObjectContext*)context{
    self.coordinator=coordinator;
    self.sentMessage=sentMessage;
    self.context=context;
    
}
- (IBAction)send:(id)sender {
    SendViewController *send=[self.storyboard instantiateViewControllerWithIdentifier:@"Send"];
    if(self.inboxMessage!=nil){
        [send setData:self.coordinator flag:true message:self.inboxMessage];
    }else{
        [send setDataForSent:self.coordinator flag:true message:self.sentMessage];
    }
    
    [self.navigationController pushViewController:send animated:YES];
    
}
- (IBAction)delete:(id)sender {
    
    if(self.inboxMessage!=nil){
        [Message deleteMessage:self.coordinator messageID:self.inboxMessage.messageID callback:^{
            [self deleteFromContext];
            [self.context save:nil];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }];
    }else{
        
        [Message deleteMessage:self.coordinator messageID:self.sentMessage.messageID callback:^{
            [self deleteFromContext];
            [self.context save:nil];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }];
    }
    
    
}
-(void)deleteFromContext{
    if(self.inboxMessage!=nil) {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Inbox"];
        [request setPredicate:[NSPredicate predicateWithFormat:@"messageID == %@", self.inboxMessage.messageID]];
        NSError *error = nil;
        NSArray *results = [self.context executeFetchRequest:request error:&error];
            for (NSManagedObject *managedObject in results)
            {
                [self.context deleteObject:managedObject];
            }
        
    }
    else{
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Sent"];
        [request setPredicate:[NSPredicate predicateWithFormat:@"messageID == %@", self.sentMessage.messageID]];
        NSError *error = nil;
        NSArray *results = [self.context executeFetchRequest:request error:&error];
        for (NSManagedObject *managedObject in results)
        {
            [self.context deleteObject:managedObject];
        }
        
    }
    
}

@end
