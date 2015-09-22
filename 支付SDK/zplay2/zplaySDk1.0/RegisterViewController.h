//
//  RegisterViewController.h
//  zplaySDk1.0
//
//  Created by ZPLAY005 on 14-2-25.
//  Copyright (c) 2014年 ZPLAY005. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
@interface RegisterViewController : UIViewController<MBProgressHUDDelegate>
//@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *activityV;
@property (retain, nonatomic) IBOutlet UITextField *aswerTextF;
@property (retain, nonatomic) IBOutlet UITextField *thickTextF;
@property (retain, nonatomic) IBOutlet UITextField *pwdTextF;
@property (retain, nonatomic) IBOutlet UITextField *userIdTextF;
@property(nonatomic,retain)NSString *userstr;
- (IBAction)loginAction:(id)sender;
@property (retain, nonatomic) IBOutlet UIButton *bgViewBtn;
- (IBAction)hidenKeyBoardAction:(id)sender;
@property (retain, nonatomic) IBOutlet UIView *bgView;

- (IBAction)showTableList:(id)sender;
- (IBAction)showTableBtn:(id)sender;


@end
