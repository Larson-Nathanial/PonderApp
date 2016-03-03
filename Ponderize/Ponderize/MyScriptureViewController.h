//
//  MyScriptureViewController.h
//  Ponderize
//
//  Created by Nathan Larson on 10/7/15.
//  Copyright © 2015 nathanlarson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyScriptureViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *scriptureReference;
@property (weak, nonatomic) IBOutlet UITextView *scriptureTextArea;
- (IBAction)continueButtonAction:(id)sender;
@property (nonatomic) BOOL fromFeed;
@property (nonatomic) NSDictionary *postObject;

@end
