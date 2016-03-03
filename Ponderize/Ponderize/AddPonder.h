//
//  AddPonder.h
//  Ponderize
//
//  Created by Nathan Larson on 10/5/15.
//  Copyright © 2015 nathanlarson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddPonder : UIViewController
- (IBAction)addScriptButtonAction:(id)sender;
@property (weak, nonatomic) IBOutlet UITextView *thoughtsTextview;
@property (weak, nonatomic) IBOutlet UILabel *selectedScriptureLabel;

@end
