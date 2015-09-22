//
//  loginViewController.h
//  zplaySDk1.0
//
//  Created by ZPLAY005 on 14-2-10.
//  Copyright (c) 2014年 ZPLAY005. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "ZplaySendNotify.h"

@interface loginViewController : UIViewController<MBProgressHUDDelegate>
@property (retain, nonatomic) IBOutlet UIView *bView;
@property (retain, nonatomic) IBOutlet UIButton *showListBtn;
@property (retain, nonatomic) IBOutlet UITextField *accText;
@property (retain, nonatomic) IBOutlet UIButton *rememberBtn;
- (IBAction)hidenKeyBoardAction:(id)sender;
@property (retain, nonatomic) IBOutlet UIButton *hidenBtn;
@property (retain, nonatomic) IBOutlet UITextField *pwdText;
- (IBAction)showListaction:(id)sender;
- (IBAction)rememberPwd:(id)sender;
- (IBAction)onForgetPwdAction:(id)sender;
- (IBAction)onQuickRegisterAction:(id)sender;
- (IBAction)onLoginAction:(id)sender;
@property (retain, nonatomic) IBOutlet UIView *contenV;
@property (retain, nonatomic) IBOutlet UIButton *aswerBtn;

@end
