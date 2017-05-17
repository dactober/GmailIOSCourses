//
//  SentMessageFetcher.m
//  GmailIOSCourses
//
//  Created by Aleksey Drachyov on 5/12/17.
//  Copyright © 2017 Aleksey Drachyov. All rights reserved.
//

#import "SendMessagesFetcher.h"
#import "Message.h"

@interface SendMessagesFetcher () 

@end
@implementation SendMessagesFetcher
-(instancetype)initWithData:(NSString*)accessToken{
    self=[super init];
    if(self){
        self.accessToken=accessToken;
        
    }
    return self;
}

@end
