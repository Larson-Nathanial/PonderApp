//
//  PonderViewController.h
//  Ponderize
//
//  Created by Nathan Larson on 10/5/15.
//  Copyright © 2015 nathanlarson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PonderViewController : UIViewController
- (IBAction)addNewPostAction:(id)sender;
- (IBAction)filterAction:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
