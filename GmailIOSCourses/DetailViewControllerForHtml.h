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
@class Sent;
@interface DetailViewControllerForHtml : UIViewController <UIWebViewDelegate>
-(void)setData:(Inbox *)inboxMessage coordinator:(Coordinator*)coordinator context:(NSManagedObjectContext *)context;
@property (strong,nonatomic)Sent *sentMessage;
@property (strong,nonatomic)Inbox *inboxMessage;
-(void)setDataForSent:(Sent *)sentMessage coordinator:(Coordinator*)coordinator context:(NSManagedObjectContext *)context;
@end
