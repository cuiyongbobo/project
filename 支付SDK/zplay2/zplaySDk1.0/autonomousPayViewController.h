//
//  autonomousPayViewController.h
//  zplaySDk1.0
//
//  Created by ZPLAY005 on 14-2-10.
//  Copyright (c) 2014年 ZPLAY005. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
@interface autonomousPayViewController : UIViewController<MBProgressHUDDelegate>
@property (retain, nonatomic) IBOutlet UILabel *useridLabel;
@property (retain, nonatomic) IBOutlet UILabel *gameNameLabel;
@property (retain, nonatomic) IBOutlet UIButton *bgBtn;
@property(nonatomic,retain)NSString *useridStr;
@property(nonatomic,retain)NSString *gamestr;
@property(nonatomic,retain)NSString *cpDefineInfo;

@end
