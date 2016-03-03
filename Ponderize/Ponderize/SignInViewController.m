//
//  SignInViewController.m
//  Ponderize
//
//  Created by Nathan Larson on 10/8/15.
//  Copyright © 2015 nathanlarson. All rights reserved.
//

#import "SignInViewController.h"
#import "Connection.h"

@interface SignInViewController ()
@property (nonatomic) UIActivityIndicatorView *activityIndicator;
@property (nonatomic) UIView *coverView;
@end

@implementation SignInViewController

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

- (IBAction)goButtonAction:(id)sender {
    
    if (_emailTextField.text.length == 0 || _passwordTextField.text.length == 0 || _userNameTextField.text.length == 0) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Missing Fields" message:@"All fields are required." preferredStyle:UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
            
        }]];
        
        [self presentViewController:alert animated:YES completion:nil];
    }else {
        [UIView animateWithDuration:0.3 animations:^{
            _coverView.alpha = 1.0;
        }];
        
        dispatch_queue_t aQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(aQueue, ^{
            
            BOOL completed = [[Connection connection] didCreateAccountWithUserName:_userNameTextField.text email:_emailTextField.text password:_passwordTextField.text];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (completed) {
                    [UIView animateWithDuration:0.5 animations:^{
                        _coverView.alpha = 0.0;
                    }completion:^(BOOL finished){
                        [self dismissViewControllerAnimated:YES completion:nil];
                    }];
                }else {
                    [UIView animateWithDuration:0.5 animations:^{
                        _coverView.alpha = 0.0;
                    }completion:^(BOOL finished){
                        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Invalid Password" message:@"An account with this email address already exists. Please try again." preferredStyle:UIAlertControllerStyleAlert];
                        
                        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
                            
                        }]];
                        
                        [self presentViewController:alert animated:YES completion:nil];
                    }];
                }
                
                
            });
        });
    }
    
}
@end
