//
//  Coordinator1.h
//  GmailIOSCourses
//
//  Created by Aleksey Drachyov on 5/5/17.
//  Copyright © 2017 Aleksey Drachyov. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CustomTableCell.h"
#import "DetailViewController.h"
#import "InboxMessagesFetcher.h"
#import "SendMessageFetcher.h"
@interface Coordinator : NSObject
-(instancetype)initWithData:(NSString*)email accessToken:(NSString*)accessToken;
@property(nonatomic,strong)NSString *serverAddressForReadMessages;
@property (strong)NSString *userID;
@property (strong)NSString *accessToken;
@property(strong,nonatomic)InboxMessagesFetcher *imf;
-(void)readListOfMessages:(void(^)(NSMutableArray*))callback;
-(void)getMessage:(NSString *)messageID callback:(void(^)(Message*))callback;

-(void)sendMessage:(NSString *)to subject:(NSString*) subject body:(NSString*)body;
@property(nonatomic,strong)SendMessageFetcher* smf;
@end
