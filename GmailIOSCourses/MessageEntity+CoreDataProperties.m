//
//  MessageEntity+CoreDataProperties.m
//  GmailIOSCourses
//
//  Created by Aleksey Drachyov on 6/8/17.
//  Copyright © 2017 Aleksey Drachyov. All rights reserved.
//

#import "MessageEntity+CoreDataProperties.h"

@implementation MessageEntity (CoreDataProperties)

+ (NSFetchRequest<MessageEntity *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"MessageEntity"];
}

@dynamic body;
@dynamic date;
@dynamic from;
@dynamic label;
@dynamic messageID;
@dynamic mimeType;
@dynamic snippet;
@dynamic subject;

@end
