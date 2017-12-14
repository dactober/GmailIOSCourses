//
//  Coordinator1.h
//  GmailIOSCourses
//
//  Created by Aleksey Drachyov on 5/5/17.
//  Copyright © 2017 Aleksey Drachyov. All rights reserved.
//
@class CreaterContextForMessages;
#import <Foundation/Foundation.h>
#import "CoreData/CoreData.h"
@interface Coordinator : NSObject
@property(nonatomic,strong)CreaterContextForMessages* contForMessages;
@property (strong)NSString *accessToken;
-(instancetype)initWithData:(NSString*)email accessToken:(NSString*)accessToken;
-(void)getMessages:(NSString *)label;
-(void)deleteMessage:(NSString*)ID label:(NSString*)label;
-(void)sendMessage:(NSString *)to subject:(NSString*) subject body:(NSString*)body;
@end
