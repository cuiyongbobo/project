//
//  ZfbWebViewController.h
//  zplaySDk1.0
//
//  Created by ZPLAY005 on 14-2-25.
//  Copyright (c) 2014年 ZPLAY005. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZfbWebViewController : UIViewController

- (IBAction)leftBtnAction:(id)sender;
- (IBAction)rightBtnAction:(id)sender;

@property (retain, nonatomic) IBOutlet UIWebView *webV;
@property (retain, nonatomic)NSString *paraStr;
@property (nonatomic,retain)NSString *commodityStr;
@property (nonatomic ,retain)NSString *priceStr;
@end
