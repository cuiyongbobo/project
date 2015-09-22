//
//  userCenterViewController.h
//  zplaySDk1.0
//
//  Created by ZPLAY005 on 14-2-8.
//  Copyright (c) 2014年 ZPLAY005. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface userCenterViewController : UIViewController
@property (retain, nonatomic) IBOutlet UILabel *userIdLable;
@property (retain, nonatomic) IBOutlet UIButton *autoBtn;

@property(nonatomic,retain) IBOutlet NSString *accText;//账号
- (IBAction)backGameAction:(id)sender;
- (IBAction)enterSecureVctrlAction:(id)sender;
- (IBAction)enterRechargeVctrlAction:(id)sender;
- (IBAction)enterMorevctrlAction:(id)sender;
- (IBAction)automaticAction:(id)sender;
- (IBAction)recomposePwdVctrlAction:(id)sender;
- (IBAction)logoutAction:(id)sender;
- (IBAction)backComeGameAction:(id)sender;
@property(nonatomic,retain)NSString *useridStr;
@end
