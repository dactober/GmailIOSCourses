//
//  Sender.h
//  GmailIOSCourses
//
//  Created by Aleksey Drachyov on 5/25/17.
//  Copyright © 2017 Aleksey Drachyov. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Coordinator;
@interface Sender : NSObject
-(instancetype)initWithData:(NSURLSession *)session;
-(void)send:(NSString*)from to:(NSString*)to subject:(NSString*)subject body:(NSString*)body accessToken:(NSString*)accessToken;
-(void)deleteMessage:(Coordinator*)coordinator messageID:(NSString*)messageID callback:(void(^)(void))callback;
@end
