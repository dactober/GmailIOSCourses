//
//  DetailViewControllerForHtml.m
//  
//
//  Created by Aleksey Drachyov on 5/13/17.
//
//

#import "DetailViewControllerForHtml.h"
#import "Coordinator.h"
#import "Message.h"
#import "SendViewController.h"
@interface DetailViewControllerForHtml ()
@property (weak, nonatomic) IBOutlet UILabel *subject;
@property (weak, nonatomic) IBOutlet UILabel *from;
@property (weak, nonatomic) IBOutlet UIWebView *body;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activity;
@property(nonatomic,strong)Coordinator *coordinator;
@property (strong,nonatomic)Message *message;
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
    self.activity.startAnimating;
    NSString *body = [NSString stringWithFormat:@"%@",[self.message decodedMessage]];
    body = [body stringByReplacingOccurrencesOfString:@"http"
                                           withString:@"https"];
    [self.body loadHTMLString:body baseURL:nil];
}
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    self.activity.stopAnimating;
  self.activity.hidden=YES;
}
-(void)setData:(Message *)message coordinator:(Coordinator*)coordinator{
    self.coordinator=coordinator;
    self.message=message;
}
- (IBAction)send:(id)sender {
    SendViewController *send=[self.storyboard instantiateViewControllerWithIdentifier:@"Send"];
    [send setData:self.coordinator flag:true message:self.message];
    [self.navigationController pushViewController:send animated:YES];
}
- (IBAction)delete:(id)sender {
    [self.message deleteMessage:self.coordinator callback:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    }];
}

@end
