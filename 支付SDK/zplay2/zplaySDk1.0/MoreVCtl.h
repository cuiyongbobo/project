//
//  MoreVCtl.h
//  zplaySDk1.0
//
//  Created by ZPLAY005 on 14-4-3.
//  Copyright (c) 2014年 ZPLAY005. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoreVCtl : UIViewController
@property (retain, nonatomic) IBOutlet UIImageView *backGV;

- (IBAction)commitBtnAction:(id)sender;
- (IBAction)backUserCenter:(id)sender;
- (IBAction)enterGame:(id)sender;
@property (retain, nonatomic) IBOutlet UITextView *textV;
@property (retain, nonatomic) IBOutlet UIButton *commBtn;
@property(nonatomic,retain)NSString *useridStr;

@end
