//
//  SentMessageFetcher.h
//  GmailIOSCourses
//
//  Created by Aleksey Drachyov on 5/12/17.
//  Copyright © 2017 Aleksey Drachyov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SendMessageFetcher : NSObject

-(instancetype)initWithData:(NSString*)accessToken;
@property(nonatomic,strong)NSString* accessToken;
-(void)send:(NSString*)from to:(NSString*)to subject:(NSString*)subject body:(NSString*)body;
@end
