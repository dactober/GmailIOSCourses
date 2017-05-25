//
//  MessagesFetcherProtocol.h
//  GmailIOSCourses
//
//  Created by Aleksey Drachyov on 5/18/17.
//  Copyright © 2017 Aleksey Drachyov. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Message;
@protocol MessagesFetcherProtocol <NSObject>

-(void)readListOfMessages:(NSString*)serverAddressForReadMessages callback:(void(^)(NSDictionary*))callback;
-(void)getMessage:(NSString*)serverAddressForReadMessages  callback:(void(^)(Message*))callback ;
-(NSMutableURLRequest*)getRequest:(NSURL*)url;
@end
