//
//  Coordinator1.h
//  GmailIOSCourses
//
//  Created by Aleksey Drachyov on 5/5/17.
//  Copyright © 2017 Aleksey Drachyov. All rights reserved.
//

#import <Foundation/Foundation.h>
@class AllMessagesFetcher;
@class Message;

@interface Coordinator : NSObject
-(instancetype)initWithData:(NSString*)email accessToken:(NSString*)accessToken;
@property(nonatomic,strong)NSString *serverAddressForReadMessages;
@property (strong)NSString *userID;
@property (strong)NSString *accessToken;
@property(strong,nonatomic)AllMessagesFetcher *amf;
-(void)readListOfMessages:(void(^)(NSArray*))callback;
-(void)getMessage:(NSString *)messageID callback:(void(^)(Message*))callback;

-(void)sendMessage:(NSString *)to subject:(NSString*) subject body:(NSString*)body;

@end
