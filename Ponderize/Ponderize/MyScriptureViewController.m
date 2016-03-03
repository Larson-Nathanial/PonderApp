//
//  MyScriptureViewController.m
//  Ponderize
//
//  Created by Nathan Larson on 10/7/15.
//  Copyright © 2015 nathanlarson. All rights reserved.
//

#import "MyScriptureViewController.h"

@implementation MyScriptureViewController

- (void)viewDidLoad
{
    if (!_fromFeed) {
        _scriptureReference.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"currentScriptureReference"];
        _scriptureTextArea.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"currentScriptureText"];
    }else {
        
        NSString *verseText = nil;
        
        if (![[_postObject valueForKey:@"book"] isEqualToString:@"none"]) {
           _scriptureTextArea.text = [_postObject valueForKey:@"verse"];
            if ([[_postObject valueForKey:@"verse1"] intValue] == [[_postObject valueForKey:@"verse2"] intValue]) {
                verseText = [NSString stringWithFormat:@"%@ %@:%@", [_postObject valueForKey:@"book"],[_postObject valueForKey:@"chapter"], [_postObject valueForKey:@"verse1"]];
            }else {
                verseText = [NSString stringWithFormat:@"%@ %@:%@ - %@", [_postObject valueForKey:@"book"],[_postObject valueForKey:@"chapter"], [_postObject valueForKey:@"verse1"], [_postObject valueForKey:@"verse2"]];
            }
            _scriptureReference.text = verseText;
        }else {
            _scriptureTextArea.text = [_postObject valueForKey:@"verse"];
        }
        
        
        
        
        
        
    }
    
}

- (IBAction)continueButtonAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
