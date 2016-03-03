

//
//  AddPonder.m
//  Ponderize
//
//  Created by Nathan Larson on 10/5/15.
//  Copyright © 2015 nathanlarson. All rights reserved.
//

#import "AddPonder.h"
#import "ChooseBook.h"
#import "PostVisibilityOptionsViewController.h"

@interface AddPonder ()<UITextViewDelegate>

@property (nonatomic) UILabel *titleLabel;

@end

@implementation AddPonder

- (void)viewDidLoad
{
    self.view.backgroundColor = [UIColor colorWithRed:245.0 / 255.0 green:245.0 / 255.0 blue:245.0 / 255.0 alpha:1.0];
    
    _titleLabel = [UILabel new];
    _titleLabel.text = @"Add Scripture";
    _titleLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:22.0];
    _titleLabel.frame = CGRectMake(0, 0, 150, 30);
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = _titleLabel;
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:67.0 / 255.0 green:213.0 / 255.0 blue:81.0 / 255.0 alpha:0.5];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStylePlain target:self action:@selector(postScripture)];
    self.navigationItem.rightBarButtonItem = barItem;
    
    _thoughtsTextview.delegate = self;
    _thoughtsTextview.textColor = [UIColor lightGrayColor];
}

- (void)viewWillAppear:(BOOL)animated
{
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"chosenScripture"] == nil) {
        _selectedScriptureLabel.alpha = 0.0;
    }else {
        _selectedScriptureLabel.alpha = 1.0;
        
        UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelAddingScription)];
        self.navigationItem.leftBarButtonItem = barButton;
        
        _selectedScriptureLabel.text = @"";
        _selectedScriptureLabel.text = [_selectedScriptureLabel.text stringByAppendingString:[NSString stringWithFormat:@"%@ \n\n", [[NSUserDefaults standardUserDefaults] valueForKey:@"chosenScripture"]]];
        _selectedScriptureLabel.text = [_selectedScriptureLabel.text stringByAppendingString:[NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults] valueForKey:@"scriptureText"]]];
        
        
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    CGSize size = [_selectedScriptureLabel.text boundingRectWithSize:CGSizeMake(self.view.bounds.size.width - 16.0, MAXFLOAT)
                                                             options:NSStringDrawingUsesLineFragmentOrigin
                                                          attributes:@{
                                                                       NSFontAttributeName : [UIFont fontWithName:@"AvenirNext-Regular" size:14.0]
                                                                       }
                                                             context:nil].size;
    
    _selectedScriptureLabel.frame = CGRectMake(_selectedScriptureLabel.frame.origin.x, _selectedScriptureLabel.frame.origin.y, _selectedScriptureLabel.frame.size.width, size.height);
}

- (void)cancelAddingScription
{
    [[NSUserDefaults standardUserDefaults] setValue:nil forKey:@"chosenScripture"];
    [[NSUserDefaults standardUserDefaults] setValue:nil forKey:@"scriptureText"];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)postScripture
{
    if (_selectedScriptureLabel.alpha == 0.0 && [_thoughtsTextview.text isEqualToString:@"Add thoughts..."]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Add Scripture" message:@"Add Scripture and/or some thoughts to proceed." preferredStyle:UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
            
        }]];
        
        [self presentViewController:alert animated:YES completion:nil];
    }else {
        PostVisibilityOptionsViewController *viewController = [PostVisibilityOptionsViewController new];
        if (![_thoughtsTextview.text isEqualToString:@"Add thoughts..."]) {
            viewController.thoughtsText = _thoughtsTextview.text;
        }
        [self.navigationController pushViewController:viewController animated:YES];
    }

}

- (IBAction)addScriptButtonAction:(id)sender {
    ChooseBook *viewController = [ChooseBook new];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:viewController];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"Add thoughts..."]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor]; //optional
    }
    [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        textView.text = @"Add thoughts...";
        textView.textColor = [UIColor lightGrayColor]; //optional
    }
    [textView resignFirstResponder];
}

@end
