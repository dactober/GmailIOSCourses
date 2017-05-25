//
//  SentMessageFetcher.h
//  GmailIOSCourses
//
//  Created by Aleksey Drachyov on 5/12/17.
//  Copyright © 2017 Aleksey Drachyov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MessagesFetcherProtocol.h"
@interface SendMessagesFetcher : NSObject<MessagesFetcherProtocol>
@property (strong,nonatomic)NSArray *messageArray;
@property(strong,nonatomic)NSString *accessToken;

-(Message *)createMessage:(NSDictionary *)message;


@end
