//
//  ReplacePwdVCtl.h
//  zplaySDk1.0
//
//  Created by ZPLAY005 on 14-4-3.
//  Copyright (c) 2014年 ZPLAY005. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReplacePwdVCtl : UIViewController
@property (retain, nonatomic) IBOutlet UILabel *topLabel;
@property (retain, nonatomic) IBOutlet UITextField *pwdTextf;
- (IBAction)commitAction:(id)sender;
@property(nonatomic,retain)NSString *useridStr;
@end
