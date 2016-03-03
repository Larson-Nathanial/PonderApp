//
//  CommentCell.h
//  Ponderize
//
//  Created by Nathan Larson on 10/7/15.
//  Copyright © 2015 nathanlarson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *commentUserName;
@property (weak, nonatomic) IBOutlet UILabel *commentText;

@end
