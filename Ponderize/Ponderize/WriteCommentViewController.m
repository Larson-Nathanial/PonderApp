//
//  WriteCommentViewController.m
//  Ponderize
//
//  Created by Nathan Larson on 10/7/15.
//  Copyright © 2015 nathanlarson. All rights reserved.
//

#import "WriteCommentViewController.h"
#import "Connection.h"

@interface WriteCommentViewController ()<UITextViewDelegate>

@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) UIActivityIndicatorView *activityIndicator;
@property (nonatomic) UIView *coverView;

@end

@implementation WriteCommentViewController

- (void)viewDidLoad
{
    self.view.backgroundColor = [UIColor colorWithRed:245.0 / 255.0 green:245.0 / 255.0 blue:245.0 / 255.0 alpha:1.0];
    
    _commentTextView.delegate = self;
    _commentTextView.textColor = [UIColor lightGrayColor];
    
    _titleLabel = [UILabel new];
    _titleLabel.text = @"Write Comment";
    _titleLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:22.0];
    _titleLabel.frame = CGRectMake(0, 0, 150, 30);
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = _titleLabel;
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:67.0 / 255.0 green:213.0 / 255.0 blue:81.0 / 255.0 alpha:0.5];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];

    UIBarButtonItem *commentButton = [[UIBarButtonItem alloc] initWithTitle:@"Post" style:UIBarButtonItemStylePlain target:self action:@selector(postComment)];
    self.navigationItem.rightBarButtonItem = commentButton;
    
    
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelWrite)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    
}

- (void)viewDidAppear:(BOOL)animated
{
    _coverView = [UIView new];
    _coverView.frame = self.view.frame;
    _coverView.backgroundColor = [UIColor colorWithWhite:100.0 / 255.0 alpha:0.8];
    [self.view addSubview:_coverView];
    
    _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    _activityIndicator.center = self.view.center;
    [_activityIndicator startAnimating];
    [_coverView addSubview:_activityIndicator];
    _coverView.alpha = 0.0;
}

- (void)postComment
{
    [_commentTextView resignFirstResponder];
    if ([_commentTextView.text isEqualToString:@"Write comment here..."]) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Missing comment" message:@"You haven't typed anything yet.." preferredStyle:UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
            
        }]];
        
        [self presentViewController:alert animated:YES completion:nil];
        
    }else {
        [UIView animateWithDuration:0.3 animations:^{
            _coverView.alpha = 1.0;
        }];
        
        dispatch_queue_t aQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(aQueue, ^{
            
            [[Connection connection] didCreateNewComment:_commentTextView.text forPostId:_post_id];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIView animateWithDuration:0.5 animations:^{
                    _coverView.alpha = 0.0;
                }completion:^(BOOL finished){
                    [self dismissViewControllerAnimated:YES completion:nil];
                }];
            });
        });
        
        
    }
}

- (void)cancelWrite
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"Write comment here..."]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor]; //optional
    }
    [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        textView.text = @"Write comment here...";
        textView.textColor = [UIColor lightGrayColor]; //optional
    }
    [textView resignFirstResponder];
}


@end
