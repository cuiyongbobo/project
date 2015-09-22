//
//  helloViewController.m
//  zplayXGZSDK
//
//  Created by ZPLAY005 on 14-1-23.
//  Copyright (c) 2014年 ZPLAY005. All rights reserved.
//


#import "helloViewController.h"
#import "sdk.h"
#import "Zplay.h"
#import "ZfbWebViewController.h"
#import "ZplaySendNotify.h"



@interface helloViewController ()<ZplayRequestDelegate,AddObserverDelegate>
- (IBAction)onloginAction:(id)sender;


@end

@implementation helloViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [ZplaySendNotify sharedInstance].myDelegate = self;
    

}
- (void)addObserver:(id)info result:(resultType)type{
    NSLog(@"+++++++++++++++++%@",(NSDictionary *)info);

}


#pragma mark -旋转代码

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
    
}
- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscape;
}
-(BOOL)shouldAutorotate
{
    return YES;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_loginView release];

    [super dealloc];
}
- (IBAction)pay:(id)sender {
    //支付
      sdk*s=[[sdk alloc]init];
   [s payViewGameText:@"仙国志" commodityText:@"点数" priceText:@"0.01" cpDefineInfo:@"123" ViewController:self];

}

- (IBAction)pay2:(id)sender {
    
    //支付2
   
    [[sdk shareInstance] payView2GameText:@"仙国志" cpDefineInfo:@"123" ViewController:self];

}

- (IBAction)YHcontenterV:(id)sender {
    
    
    
   //用户中心
    
    [[sdk shareInstance] userCente:self];
}




- (IBAction)onloginAction:(id)sender {
    //登录
        [[sdk shareInstance] login:self];
}

-(void)UPPayPluginResult:(NSString*)result
{
    NSLog(@"%@",result);
}


@end
