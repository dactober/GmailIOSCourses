//
//  Coordinator1.h
//  GmailIOSCourses
//
//  Created by Aleksey Drachyov on 5/5/17.
//  Copyright © 2017 Aleksey Drachyov. All rights reserved.
//
@class CreaterContextForInbox;
#import <Foundation/Foundation.h>
#import "CoreData/CoreData.h"
@class AllMessagesFetcher;
@class Message;
@class InboxMessagesFetcher;
@class SendMessagesFetcher;
@class Sender;
@class Inbox;
@interface Coordinator : NSObject
-(instancetype)initWithData:(NSString*)email accessToken:(NSString*)accessToken;
@property(nonatomic,strong)NSString *serverAddressForReadMessages;
@property (strong)NSString *userID;
@property (strong)NSString *accessToken;
@property(strong,nonatomic)InboxMessagesFetcher *imf;
@property(strong,nonatomic)SendMessagesFetcher *smf;
@property(nonatomic,strong)Sender* sender;
-(void)readListOfMessages:(void(^)(NSDictionary*))callback label:(NSString*)labelId nextPageToken:(NSString *)nextPage;
-(void)getMessage:(NSString *)messageID callback:(void(^)(Message*))callback;
-(void)addObjectToInboxContext:(Message*)message context:(NSManagedObjectContext*)context label:(NSString *)label;
-(void)sendMessage:(NSString *)to subject:(NSString*) subject body:(NSString*)body;
@property(nonatomic,strong)CreaterContextForInbox* contForInbox;
-(bool) isHasObject:(NSString*)ID label:(NSString*)label;

-(void)getMessages:(NSString *)label;
-(void)deleteMessage:(NSString*)ID label:(NSString*)label;
@end
