//
//  DetailViewController.m
//  GmailIOSCourses
//
//  Created by Aleksey Drachyov on 5/9/17.
//  Copyright © 2017 Aleksey Drachyov. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.subject.text=self.message.subject;
    self.from.text=self.message.from;
    self.body.text=[self.message decodedMessage];
}
-(void)setData:(Message *)message{
    
        self.message=message;
}
- (IBAction)send:(id)sender {
}
- (IBAction)delete:(id)sender {
}


@end
