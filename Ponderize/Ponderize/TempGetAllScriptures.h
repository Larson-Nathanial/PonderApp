//
//  TempGetAllScriptures.h
//  Ponderize
//
//  Created by Nathan Larson on 10/8/15.
//  Copyright © 2015 nathanlarson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TempGetAllScriptures : NSObject

@property (nonatomic) int currentMajorBook;

+ (TempGetAllScriptures *)getAll;

- (void)kickOff;

@end
