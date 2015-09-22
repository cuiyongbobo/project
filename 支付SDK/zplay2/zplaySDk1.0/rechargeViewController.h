//
//  rechargeViewController.h
//  zplayXGZSDK
//
//  Created by ZPLAY005 on 14-1-22.
//  Copyright (c) 2014年 ZPLAY005. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface rechargeViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (retain, nonatomic) IBOutlet UIImageView *topImageV;
@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,retain)NSString *userId;

- (IBAction)backUserCentreAction:(id)sender;
- (IBAction)passIntoGameAction:(id)sender;

@end
