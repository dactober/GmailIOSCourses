//
//  ReadMessages1.h
//  GmailIOSCourses
//
//  Created by Aleksey Drachyov on 5/5/17.
//  Copyright © 2017 Aleksey Drachyov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MessagesFetcherProtocol.h"
@class Coordinator;
@class Message;
@interface InboxMessagesFetcher:NSObject<MessagesFetcherProtocol>
@property (strong,nonatomic)NSArray *messageArray;
@property(strong,nonatomic)NSString *accessToken;
-(instancetype)initWithData:(NSString*)accessToken;
-(Message *)createMessage:(NSDictionary *)message;
@end

