//
//  DetailViewControllerForHtml.h
//  
//
//  Created by Aleksey Drachyov on 5/13/17.
//
//

#import <UIKit/UIKit.h>
#import "CoreData/CoreData.h"
@class Coordinator;
@class Inbox;

@interface DetailViewControllerForHtml : UIViewController <UIWebViewDelegate>
-(void)setData:(Inbox *)inboxMessage coordinator:(Coordinator*)coordinator context:(NSManagedObjectContext *)context;

@property (strong,nonatomic)Inbox *inboxMessage;

@end
