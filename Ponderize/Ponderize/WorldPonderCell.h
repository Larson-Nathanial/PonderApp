//
//  WorldPonderCell.h
//  Ponderize
//
//  Created by Nathan Larson on 10/5/15.
//  Copyright © 2015 nathanlarson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WorldPonderCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *postName;
@property (weak, nonatomic) IBOutlet UILabel *postDate;
@property (weak, nonatomic) IBOutlet UILabel *postText;
@property (weak, nonatomic) IBOutlet UIButton *viewMoreOutlet;
- (IBAction)viewMoreAction:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *likesText;
@property (weak, nonatomic) IBOutlet UILabel *commentsOutlet;
- (IBAction)commentButton:(id)sender;
- (IBAction)likeButton:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *likeButtonOutlet;
@property (weak, nonatomic) IBOutlet UIButton *likedButtonOutlet;

@property (nonatomic, copy) void (^viewMoreActionButton)(id sender);
@property (nonatomic, copy) void (^commentAction)(id sender);
@property (nonatomic, copy) void (^likeAction)(id sender);

@end
