//
//  SCImageBrowser.m
//  SCImagePickerControllerDemo
//
//  Created by Aevit on 15/9/15.
//  Copyright (c) 2015年 Aevit. All rights reserved.
//

#import "SCImageBrowser.h"

@interface SCImageBrowser ()

@end

@implementation SCImageBrowser

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    SCZoomingScrollView *page = [[SCZoomingScrollView alloc] initWithFrame:self.view.bounds withImage:_image];
    [self.view addSubview:page];
}

- (void)dealloc {
    self.image = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
