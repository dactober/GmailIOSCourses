//
//  DetailViewControllerForHtml.m
//  
//
//  Created by Aleksey Drachyov on 5/13/17.
//
//

#import "DetailViewControllerForHtml.h"
#import "Coordinator.h"
#import "SendViewController.h"
#import "MessageEntity+CoreDataClass.h"
#import "Message.h"

@interface DetailViewControllerForHtml ()
@property (weak, nonatomic) IBOutlet UILabel *subject;
@property (weak, nonatomic) IBOutlet UILabel *from;
@property (weak, nonatomic) IBOutlet UIWebView *body;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activity;
@property(nonatomic,strong)Coordinator *coordinator;
@property(nonatomic,strong) NSManagedObjectContext *context;
@end

@implementation DetailViewControllerForHtml

- (void)viewDidLoad {
    [super viewDidLoad];
    self.body.delegate=self;
    
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    self.subject.text=self.message.subject;
    if([self.message.from containsString:@" <"]){
        
        NSRange range = [self.message.from rangeOfString:@" <"];
        NSString *shortString = [self.message.from substringToIndex:range.location];
        
        self.from.text=shortString;
        
        
    }else{
        self.from.text=self.message.from;
    }
    self.activity.hidden=NO;
    [self.activity startAnimating];
    
    [self.body loadHTMLString:self.message.body baseURL:nil];
}
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [self.activity stopAnimating];
  self.activity.hidden=YES;
}
-(void)setData:(MessageEntity *)inboxMessage coordinator:(Coordinator*)coordinator context:(NSManagedObjectContext *)context{
    self.coordinator=coordinator;
    self.message=inboxMessage;
    self.context=context;
}

- (IBAction)send:(id)sender {
    SendViewController *send=[self.storyboard instantiateViewControllerWithIdentifier:@"Send"];
        [send setData:self.coordinator flag:true message:self.message];
    
    
    [self.navigationController pushViewController:send animated:YES];
}
- (IBAction)delete:(id)sender {
    [self.coordinator deleteMessage:self.message.messageID label:self.message.label];
}
@end
