//
//  Inbox+CoreDataProperties.m
//  GmailIOSCourses
//
//  Created by Aleksey Drachyov on 5/20/17.
//  Copyright © 2017 Aleksey Drachyov. All rights reserved.
//

#import "Inbox+CoreDataProperties.h"

@implementation Inbox (CoreDataProperties)

+ (NSFetchRequest<Inbox *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Inbox"];
}

@dynamic date;
@dynamic body;
@dynamic subject;
@dynamic from;
@dynamic snippet;

@end
