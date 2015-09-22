//
//  payViewController.h
//  zplaySDk1.0
//
//  Created by ZPLAY005 on 14-2-10.
//  Copyright (c) 2014年 ZPLAY005. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface payViewController : UIViewController
@property (retain, nonatomic) IBOutlet UIView *contentView;
@property (retain, nonatomic) IBOutlet UIView *bottomView;
@property (retain, nonatomic) IBOutlet UILabel *userLabel;
@property (retain, nonatomic) IBOutlet UILabel *gameNameLabel;
@property (retain, nonatomic) IBOutlet UILabel *commodityLabel;
@property (retain, nonatomic) IBOutlet UILabel *priceLabel;
@property (retain, nonatomic) IBOutlet UILabel *shouPayLable;
- (IBAction)onPayBtnAction:(id)sender;
@property(nonatomic,retain)NSString *priceText;//价格

@property(nonatomic,retain)NSString *userStr;
@property(nonatomic,retain)NSString *gameStr;
@property(nonatomic,retain)NSString *commodtyStr;
@property(nonatomic,retain)NSString *cpDInfo;

@end
