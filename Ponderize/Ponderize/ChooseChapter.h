//
//  ChooseChapter.h
//  Ponderize
//
//  Created by Nathan Larson on 10/5/15.
//  Copyright © 2015 nathanlarson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChooseChapter : UIViewController

@property (nonatomic) NSString *book1Selected;
@property (nonatomic) NSString *book2Selected;
@property (nonatomic) NSString *titleForView;
@property (nonatomic) NSString *majorBook;
@property (nonatomic) BOOL canUseDBForScriptures;
@property (nonatomic) NSString *minorBookId;

@end
