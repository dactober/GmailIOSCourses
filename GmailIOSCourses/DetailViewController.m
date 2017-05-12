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
    self.subject.text=self.cell.subject.text;
    self.from.text=self.cell.title.text;
    self.body.text=[self.message decodeMessage];
}
-(void)setData:(CustomTableCell *)cell message:(Message *)message{
    
        self.cell=cell;
        self.message=message;
}


@end
