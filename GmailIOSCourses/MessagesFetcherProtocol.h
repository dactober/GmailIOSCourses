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
-(void)readListOfMessages:(void(^)(NSDictionary*))callback label:(NSString*)labelId nextPage:(NSString*)nextPageToken;
-(void)message:(NSString*)serverAddressForReadMessages callback:(void(^)(Message*))callback ;
-(NSMutableURLRequest*)request:(NSURL*)url;
@end
