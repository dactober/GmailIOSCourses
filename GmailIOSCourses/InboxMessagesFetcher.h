//
//  ReadMessages1.h
//  GmailIOSCourses
//
//  Created by Aleksey Drachyov on 5/5/17.
//  Copyright © 2017 Aleksey Drachyov. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Coordinator;
@class Message;
@interface InboxMessagesFetcher:NSObject
-(void)readListOfMessages:(NSString*)serverAddressForReadMessages callback:(void(^)(NSMutableArray*))callback;
-(void)getMessage:(NSString*)serverAddressForReadMessages  callback:(void(^)(Message*))callback ;
-(instancetype)initWithData:(NSString*)accessToken;
@property (strong,nonatomic)NSMutableArray *messageArray;
@property(strong,nonatomic)NSString *accessToken;
@property(strong,nonatomic)NSURLSession *session;
-(Message *)createMessage:(NSDictionary *)message;
@end

