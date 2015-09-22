//
//  pwdVctrl.h
//  zplaySDk1.0
//
//  Created by ZPLAY005 on 14-1-26.
//  Copyright (c) 2014年 ZPLAY005. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface pwdVctrl : UIViewController<UITextFieldDelegate>
@property (retain, nonatomic) IBOutlet UILabel *msgLabel;
@property (retain, nonatomic) IBOutlet UITextField *oPwdText;
@property (retain, nonatomic) IBOutlet UITextField *nPwdText;
@property (retain, nonatomic) IBOutlet UIImageView *backGV;
@property (retain, nonatomic) IBOutlet UIView *contentV;
@property (retain, nonatomic) IBOutlet UIButton *backBtn;
@property (retain, nonatomic) IBOutlet UIView *bView;
@property(nonatomic,retain)NSString *acctr;
- (IBAction)onCommitBtnAction:(id)sender;
- (IBAction)hidenKeyBoard:(id)sender;
- (IBAction)backUsercenterAction:(id)sender;
- (IBAction)passIntoGameAction:(id)sender;

@end
