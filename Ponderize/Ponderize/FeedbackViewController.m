//
//  FeedbackViewController.m
//  Ponderize
//
//  Created by Nathan Larson on 10/10/15.
//  Copyright © 2015 nathanlarson. All rights reserved.
//

#import "FeedbackViewController.h"

@interface FeedbackViewController ()<UIWebViewDelegate>

@end

@implementation FeedbackViewController

- (void)viewDidLoad
{
    UILabel *titleLabel = [UILabel new];
    titleLabel.text = @"Feedback";
    titleLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:22.0];
    titleLabel.frame = CGRectMake(0, 0, 150, 30);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = titleLabel;
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:67.0 / 255.0 green:213.0 / 255.0 blue:81.0 / 255.0 alpha:1.0];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}

- (void)viewDidAppear:(BOOL)animated
{
    NSString *urlToGet = @"http://ponder.appselevated.com/feedback.html";
    
    _webViewOutlet.delegate = self;
    NSString *url = urlToGet;
    NSURL *nsurl=[NSURL URLWithString:url];
    NSURLRequest *nsrequest=[NSURLRequest requestWithURL:nsurl];
    [_webViewOutlet loadRequest:nsrequest];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [UIView animateWithDuration:0.3 animations:^{
        _coverViewOutlet.alpha = 0.0;
    }];
    
    
}

@end
