//
//  VerseCell.h
//  Ponderize
//
//  Created by Nathan Larson on 10/6/15.
//  Copyright © 2015 nathanlarson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VerseCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *verseNumber;
@property (weak, nonatomic) IBOutlet UILabel *verseText;

@end
