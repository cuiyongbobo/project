//
//  secureViewController.h
//  zplaySDk1.0
//
//  Created by ZPLAY005 on 14-2-11.
//  Copyright (c) 2014年 ZPLAY005. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface secureViewController : UIViewController
@property (retain, nonatomic) IBOutlet UIView *bgView;
@property (retain, nonatomic) IBOutlet UILabel *userIdLable;
- (IBAction)commitAction:(id)sender;

- (IBAction)showListaction:(id)sender;

@property (retain, nonatomic) IBOutlet UITextField *aswerText;
@property (retain, nonatomic) IBOutlet UITextField *ziplocText;
@property (retain, nonatomic) IBOutlet UITextField *userIdText;
@property (retain, nonatomic) IBOutlet UIButton *hidenBtn;
- (IBAction)hidenKeyBoardAction:(id)sender;
- (IBAction)enterGameAction:(id)sender;
- (IBAction)backUserVctrlAction:(id)sender;
@property(nonatomic,retain)NSString *useridStr;
@property (retain, nonatomic) IBOutlet UILabel *aserLabel;
@end
