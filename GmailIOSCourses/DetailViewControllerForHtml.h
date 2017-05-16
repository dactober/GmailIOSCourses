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
@interface DetailViewControllerForHtml : UIViewController <UIWebViewDelegate>
-(void)setData:(Message *)message coordinator:(Coordinator*)coordinator;
@end
