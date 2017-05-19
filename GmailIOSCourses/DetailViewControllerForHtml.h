//
//  DetailViewControllerForHtml.h
//  
//
//  Created by Aleksey Drachyov on 5/13/17.
//
//

#import <UIKit/UIKit.h>
@class Message;
@class Coordinator;
@class Inbox;
@interface DetailViewControllerForHtml : UIViewController <UIWebViewDelegate>
-(void)setData:(Inbox *)inboxMessage coordinator:(Coordinator*)coordinator message:(Message*)message;
@property (strong,nonatomic)Inbox *inboxMessage;
@end
