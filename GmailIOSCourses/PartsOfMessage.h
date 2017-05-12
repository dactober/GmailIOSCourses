//
//  PartOfMessage.h
//  GmailIOSCourses
//
//  Created by Aleksey Drachyov on 5/12/17.
//  Copyright © 2017 Aleksey Drachyov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PartOfMessage.h"
@interface PartsOfMessage : NSObject
@property(strong,nonatomic)PartOfMessage *part;
-(instancetype)initWithData:(NSArray *)parts;
@property(nonatomic,strong)NSMutableArray* parts;
@end
