//
//  Sent+CoreDataProperties.m
//  GmailIOSCourses
//
//  Created by Aleksey Drachyov on 5/24/17.
//  Copyright © 2017 Aleksey Drachyov. All rights reserved.
//

#import "Sent+CoreDataProperties.h"

@implementation Sent (CoreDataProperties)

+ (NSFetchRequest<Sent *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Sent"];
}

@dynamic body;
@dynamic snippet;
@dynamic subject;
@dynamic from;
@dynamic date;
@dynamic messageID;
@dynamic mimeType;

@end
