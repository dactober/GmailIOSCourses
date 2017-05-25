//
//  Coordinator1.h
//  GmailIOSCourses
//
//  Created by Aleksey Drachyov on 5/5/17.
//  Copyright © 2017 Aleksey Drachyov. All rights reserved.
//
@class CreaterContextForInbox;
@class CreaterContextForSentMessage;
#import <Foundation/Foundation.h>
#import "CoreData/CoreData.h"
@class AllMessagesFetcher;
@class Message;
@class InboxMessagesFetcher;
@class SendMessagesFetcher;

@interface Coordinator : NSObject
-(instancetype)initWithData:(NSString*)email accessToken:(NSString*)accessToken;
@property(nonatomic,strong)NSString *serverAddressForReadMessages;
@property (strong)NSString *userID;
@property (strong)NSString *accessToken;
@property(strong,nonatomic)InboxMessagesFetcher *imf;
@property(strong,nonatomic)SendMessagesFetcher *smf;
-(void)readListOfMessages:(void(^)(NSDictionary*))callback label:(NSString*)labelId;
-(void)getMessage:(NSString *)messageID callback:(void(^)(Message*))callback;
-(void)addObjectToInboxContext:(Message*)message context:(NSManagedObjectContext*)context;
-(void)sendMessage:(NSString *)to subject:(NSString*) subject body:(NSString*)body;
@property(nonatomic,strong)CreaterContextForInbox* contForInbox;
@property(nonatomic,strong)CreaterContextForSentMessage* contForSent;
-(bool) isHasObject:(NSString*)ID;
-(bool) isHasObjectSent:(NSString*)ID;
-(void)addObjectToSentContext:(Message*)message context:(NSManagedObjectContext*)context;
@end
