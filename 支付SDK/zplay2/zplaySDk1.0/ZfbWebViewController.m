//
//  ZfbWebViewController.m
//  zplaySDk1.0
//
//  Created by ZPLAY005 on 14-2-25.
//  Copyright (c) 2014年 ZPLAY005. All rights reserved.
//

#import "ZfbWebViewController.h"
#import "Zplay.h"
#import "DefineObjcs.h"
@interface ZfbWebViewController ()<UIWebViewDelegate>
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *activityV;

@end

@implementation ZfbWebViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:@"ZfbWebViewController" bundle:ZPLAY_BUNDLE];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self para:_paraStr commodity:_commodityStr price:_priceStr];
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"parshow"]) {
        
    }
    // Do any additional setup after loading the view from its nib.
}
-(void)para:(NSString *)paraS commodity:(NSString *)commodityS price:(NSString *)priceS
{
    NSString *plistPath=[[NSBundle mainBundle]pathForResource:@"zplaySDk" ofType:@"plist"];
    NSDictionary *mDic=[[[NSDictionary alloc]initWithContentsOfFile:plistPath] autorelease];
    NSString *channelId=[mDic objectForKey:@"channelid"];
    NSString *gameId=[mDic objectForKey:@"gameId"];
    NSString *macStr=[[Zplay shareInstance]macaddress];
    NSString *idfa;
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>6) {
        idfa=[[[UIDevice currentDevice]identifierForVendor] UUIDString];
        
    }else
    {
        idfa=@"";
    }
    commodityS=[commodityS stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *str=[NSString stringWithFormat:@"http://op.zplay.cn/onlinepay/wap/inlet.php?para=%@,%@,%@,%@,%@,%@,%@,W",paraS,commodityS,gameId,macStr,idfa,channelId,priceS];
    NSURL *url=[NSURL URLWithString:str];
    NSMutableURLRequest *request=[[NSMutableURLRequest alloc]init];
    
    [request setURL:url];
    [request setHTTPMethod:@"POST"];
    [request setTimeoutInterval:30];
    [_webV loadRequest:request];
    _webV.delegate=self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {

    [_webV release];

    [_activityV release];
    [super dealloc];
}
- (void)viewDidUnload {
 
    [self setWebV:nil];

    [self setActivityV:nil];
    [super viewDidUnload];
}
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [_activityV startAnimating];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
     [_activityV stopAnimating];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [_activityV stopAnimating];

}
- (IBAction)leftBtnAction:(id)sender {
    if (_webV.canGoBack) {
        [_webV goBack];
    }else
    {
        [self.navigationController dismissViewControllerAnimated:YES completion:Nil];
    }
    
}
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
- (IBAction)rightBtnAction:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
@end
