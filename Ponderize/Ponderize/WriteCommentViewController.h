//
//  WriteCommentViewController.h
//  Ponderize
//
//  Created by Nathan Larson on 10/7/15.
//  Copyright © 2015 nathanlarson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WriteCommentViewController : UIViewController

@property (nonatomic) NSString *post_id;
@property (weak, nonatomic) IBOutlet UITextView *commentTextView;

@end
