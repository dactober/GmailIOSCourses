//
//  Coordinator1.m
//  GmailIOSCourses
//
//  Created by Aleksey Drachyov on 5/5/17.
//  Copyright © 2017 Aleksey Drachyov. All rights reserved.
//

#import "Coordinator.h"
#import "Message.h"
#import "SendMessagesFetcher.h"
#import "InboxMessagesFetcher.h"
#import "MessageEntity+CoreDataClass.h"
#import "Sender.h"

@interface Coordinator ()
- (bool)isHasObject:(NSString *)ID label:(NSString *)label;
@property(nonatomic, strong) NSString *nextPageTokenForInbox;
@property(nonatomic, strong) NSString *nextPageTokenForSent;
@property(nonatomic, strong) InboxMessagesFetcher *inboxMessageFetcher;
@property(nonatomic, strong) NSString *serverAddressForReadMessages;
@property(nonatomic, strong) NSString *userID;
@property(nonatomic, strong) Sender *sender;
@end

@implementation Coordinator
static NSString *const inbox = @"INBOX";
- (instancetype)initWithEmail:(NSString *)email accessToken:(NSString *)accessToken {
    self = [super init];
    if (self) {
        self.userID = email;
        self.accessToken = accessToken;

        [self customInit];
    }
    return self;
}

- (void)customInit {
    self.inboxMessageFetcher = [[InboxMessagesFetcher alloc] initWithAccessToken:self.accessToken];
    self.contForMessages = [[CreaterContextForMessages alloc] init];
    self.sender = [[Sender alloc] initWithSession:[NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]]];
}

- (void)messages:(NSString *)label {
    [self.inboxMessageFetcher readListOfMessages:^(NSDictionary *listOfMessages) {
      NSArray *arrayOfMessages = [listOfMessages objectForKey:@"messages"];
      if ([label isEqualToString:inbox]) {
          self.nextPageTokenForInbox = [listOfMessages objectForKey:@"nextPageToken"];
      } else {
          self.nextPageTokenForSent = [listOfMessages objectForKey:@"nextPageToken"];
      }
      __block NSInteger counter = 0;
      NSManagedObjectContext *context = [self.contForMessages setupBackGroundManagedObjectContext];
      void (^trySaveContext)(void) = ^{
        counter++;
        if (counter % [arrayOfMessages count] == 0) {
            NSError *mocSaveError = nil;
            if (![context save:&mocSaveError]) {
                NSLog(@"Save did not complete successfully. Error: %@", [mocSaveError localizedDescription]);
            } else {
                [self.contForMessages.context save:nil];
            }
        }
      };
      [context performBlock:^{
        for (int i = 0; i < arrayOfMessages.count; i++) {
            if ([self isHasObject:[arrayOfMessages[i] objectForKey:@"id"] label:label]) {
                trySaveContext();
            } else {
                [self.inboxMessageFetcher message:[arrayOfMessages[i] objectForKey:@"id"]
                                         callback:^(Message *message) {
                                           [self.contForMessages addMessage:message ToInboxContext:context];
                                           trySaveContext();
                                         }];
            }
        }
      }];
    }
                                           label:label
                                        nextPage:self.nextPageTokenForInbox];
}

- (void)sendMessage:(NSString *)to subject:(NSString *)subject body:(NSString *)body {
    [self.sender send:self.userID to:to subject:subject body:body accessToken:self.accessToken];
}
- (void)deleteMessage:(NSString *)ID label:(NSString *)label {
    [self.sender deleteMessage:self
                     messageID:ID
                      callback:^{
                        [self.contForMessages deleteFromContext:ID];
                        [self.contForMessages.context save:nil];
                      }];
}

- (bool)isHasObject:(NSString *)ID label:(NSString *)label {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"MessageEntity"];
    NSError *error = nil;
    [request setPredicate:[NSPredicate predicateWithFormat:@"messageID == %@", ID]];
    NSArray *results = [self.contForMessages.context executeFetchRequest:request error:&error];
    if ([results count]) {
        return true;
    } else {
        return false;
    }
}

@end
