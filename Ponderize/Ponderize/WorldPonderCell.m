//
//  WorldPonderCell.m
//  Ponderize
//
//  Created by Nathan Larson on 10/5/15.
//  Copyright © 2015 nathanlarson. All rights reserved.
//

#import "WorldPonderCell.h"

@implementation WorldPonderCell

- (IBAction)viewMoreAction:(id)sender {
    
    self.viewMoreActionButton(sender);
    
}
- (IBAction)commentButton:(id)sender {
    self.commentAction(sender);
}

- (IBAction)likeButton:(id)sender {
    self.likeAction(sender);
}
@end
