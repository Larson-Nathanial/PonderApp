//
//  WorldViewController.h
//  Ponderize
//
//  Created by Nathan Larson on 10/5/15.
//  Copyright © 2015 nathanlarson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WorldViewController : UIViewController

- (IBAction)addVerseAction:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
