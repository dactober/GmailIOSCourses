//
//  Coordinator1.m
//  GmailIOSCourses
//
//  Created by Aleksey Drachyov on 5/5/17.
//  Copyright © 2017 Aleksey Drachyov. All rights reserved.
//

#import "Coordinator.h"

@implementation Coordinator
-(instancetype)initWithData:(NSString*)email accessToken:(NSString*)accessToken{
    self=[super init];
    if(self){
        self.userID=email;
        self.accessToken=accessToken;
        self.rm=[[ReadMessages alloc]initWithData:self.accessToken];
    }
    return self;
}

-(void)readListOfMessages:(void(^)(NSArray*))callback{
    self.serverAddressForReadMessages=[NSString stringWithFormat:@"https://www.googleapis.com/gmail/v1/users/%@/messages?fields=messages(id,threadId),nextPageToken&maxResults=%d",self.userID,20];
    
    [self.rm readListOfMessages:self.serverAddressForReadMessages callback:callback];
    
}
-(void)getMessage:(NSString *)messageID callback:(void(^)(NSDictionary*))callback{
    self.serverAddressForReadMessages=[NSString stringWithFormat:@"https://www.googleapis.com/gmail/v1/users/%@/messages/%@",self.userID,messageID];
    [self.rm getMessage:self.serverAddressForReadMessages callback:callback];
}
-(Message *)createMessage:(NSDictionary *)message{
    Message *msg=[[Message alloc]initWithData:message];
    return msg;
}
@end
