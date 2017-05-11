//
//  ReadMessages1.h
//  GmailIOSCourses
//
//  Created by Aleksey Drachyov on 5/5/17.
//  Copyright © 2017 Aleksey Drachyov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InboxMessagesFetcher:NSObject
-(void)readListOfMessages:(NSString*)serverAddressForReadMessages callback:(void(^)(NSArray*))callback;
-(void)getMessage:(NSString*)serverAddressForReadMessages callback:(void(^)(NSDictionary*))callback;
-(instancetype)initWithData:(NSString*)accessToken;
@property (strong,nonatomic)NSArray *messageArray;
@property(strong,nonatomic)NSString *accessToken;
@property(strong,nonatomic)NSURLSession *session;
@end

