//
//  Sent+CoreDataProperties.m
//  GmailIOSCourses
//
//  Created by Aleksey Drachyov on 5/25/17.
//  Copyright © 2017 Aleksey Drachyov. All rights reserved.
//

#import "Sent+CoreDataProperties.h"

@implementation Sent (CoreDataProperties)

+ (NSFetchRequest<Sent *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Sent"];
}

@dynamic body;
@dynamic date;
@dynamic from;
@dynamic subject;
@dynamic snippet;
@dynamic mimeType;
@dynamic messageID;
@dynamic label;
@end
