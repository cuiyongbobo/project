//
//  ForgetPWDVCtl.h
//  zplaySDk1.0
//
//  Created by ZPLAY005 on 14-4-3.
//  Copyright (c) 2014年 ZPLAY005. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
@interface ForgetPWDVCtl : UIViewController<MBProgressHUDDelegate>
- (IBAction)backFView:(id)sender;
- (IBAction)showTable:(id)sender;

- (IBAction)showTableOfAnswerQuestion:(id)sender;

- (IBAction)commitToSeverAction:(id)sender;
@property (retain, nonatomic) IBOutlet UITextField *accTextf;
@property (retain, nonatomic) IBOutlet UIButton *showTableBtn;
@property (retain, nonatomic) IBOutlet UITextField *ziplocText;
@property (retain, nonatomic) IBOutlet UITextField *aswerText;
@property (retain, nonatomic) IBOutlet UIButton *showListBtn;
- (IBAction)showListAction:(id)sender;
@property (retain, nonatomic) IBOutlet UIButton *hidenBtn;

- (IBAction)hidenKeyBoardAction:(id)sender;
@property (retain, nonatomic) IBOutlet UIButton *commitBtn;
@property(nonatomic,retain)NSString *userIdStr;

@end
