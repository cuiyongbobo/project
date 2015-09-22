//
//  payViewController.m
//  zplaySDk1.0
//
//  Created by ZPLAY005 on 14-2-10.
//  Copyright (c) 2014年 ZPLAY005. All rights reserved.
//

#import "payViewController.h"
#import "Zplay.h"
#import "ZfbWebViewController.h"
#import "UPOMP_iPad.h"
#import "UPOMP.h"
#import "XMLDictionary.h"
#import "AppDelegate.h"
#import "DefineObjcs.h"

@interface payViewController ()<ZplayRequestDelegate,UPOMP_iPad_Delegate,UPOMPDelegate,NSURLConnectionDelegate,UIAlertViewDelegate>
{
    UPOMP_iPad *ipad;
    UPOMP *iphone;
    NSString *strmoney;
    NSMutableData *repostData;
    NSURLConnection *connection2;
   
}
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *activityV;
@property (retain, nonatomic) IBOutlet UILabel *titleLabel;
@property (retain, nonatomic) IBOutlet UILabel *nameLabel;
@property (retain, nonatomic) IBOutlet UILabel *gameLabelName;
@property (retain, nonatomic) IBOutlet UILabel *priceNameLabel;
@property (retain, nonatomic) IBOutlet UILabel *priceLabelText;
@property (retain, nonatomic) IBOutlet UILabel *shouldLabelText;
@property (retain, nonatomic) IBOutlet UILabel *zfbTextLabel;
@property (retain, nonatomic) IBOutlet UILabel *textLabel;
@property (retain, nonatomic) IBOutlet UILabel *zfbT;
@property (retain, nonatomic) IBOutlet UILabel *zfbT2;
@property (retain, nonatomic) IBOutlet UILabel *payTextLabel;
@property (retain, nonatomic) IBOutlet UILabel *uPPayLabel;
@property (retain, nonatomic) IBOutlet UIButton *uppBtn;


- (IBAction)backAction:(id)sender;

- (IBAction)backGameAction:(id)sender;
@end

@implementation payViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:@"payViewController" bundle:ZPLAY_BUNDLE];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    self.view.hidden=NO;

    
    [self.activityV setHidden:YES];
    [[_contentView layer] setCornerRadius:5];
    [[_contentView layer] setBorderWidth:1];
    [[_contentView layer] setBorderColor:[UIColor redColor].CGColor];
    [[_contentView layer] setMasksToBounds:YES];
    
    [[_bottomView layer] setCornerRadius:5];
    [[_bottomView layer] setBorderWidth:1];
    [[_bottomView layer] setBorderColor:[UIColor redColor].CGColor];
    [[_bottomView layer] setMasksToBounds:YES];
    
    self.userLabel.text=self.userStr;
    self.priceLabel.text=[NSString stringWithFormat:@"%@元",self.priceText];
    self.commodityLabel.text=self.commodtyStr;
    self.shouPayLable.text=[NSString stringWithFormat:@"%@元",self.priceText];
    self.gameNameLabel.text=self.gameStr;
    
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad) {
        _titleLabel.font=[UIFont systemFontOfSize:30.0f];
        _nameLabel.font=[UIFont systemFontOfSize:25.0f];
        _gameLabelName.font=[UIFont systemFontOfSize:25.0f];
        _userLabel.font=[UIFont systemFontOfSize:25.0f];
        _commodityLabel.font=[UIFont systemFontOfSize:25.0f];
        _priceLabel.font=[UIFont systemFontOfSize:25.0f];
        _priceNameLabel.font=[UIFont systemFontOfSize:25.0f];
        _priceLabelText.font=[UIFont systemFontOfSize:25.0f];
        _shouldLabelText.font=[UIFont systemFontOfSize:25.0f];
        _zfbTextLabel.font=[UIFont systemFontOfSize:25.0f];
        _textLabel.font=[UIFont systemFontOfSize:25.0f];
        _gameNameLabel.font=[UIFont systemFontOfSize:25.0f];
        _shouPayLable.font=[UIFont systemFontOfSize:25.0f];
        _zfbT.font=[UIFont systemFontOfSize:28.0f];
        _zfbT2.font=[UIFont systemFontOfSize:28.0f];
        _payTextLabel.font=[UIFont systemFontOfSize:25.0f];
        _uPPayLabel.font=[UIFont systemFontOfSize:28.0f];
        
    }
    [_uppBtn setHidden:YES];
    [_uPPayLabel setHidden:YES];
    if ([[NSUserDefaults standardUserDefaults]boolForKey:ISSHOWUPPY]) {
        [_uppBtn setHidden:NO];
        [_uPPayLabel setHidden:NO];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
   
    [_contentView release];
    [_bottomView release];
    [_userLabel release];
    [_gameNameLabel release];
    [_commodityLabel release];
    [_priceLabel release];
    [_shouPayLable release];
    [_activityV release];
    [_titleLabel release];
    [_nameLabel release];
    
    [_gameLabelName release];
    [_priceNameLabel release];
    [_priceLabelText release];
    [_shouldLabelText release];
    [_zfbTextLabel release];
    [_textLabel release];
    [_zfbT release];
   
    [_zfbT2 release];
    [_payTextLabel release];
    [_uPPayLabel release];
    [_uppBtn release];
    [super dealloc];
}
- (IBAction)onPayBtnAction:(id)sender {
    self.userStr=[[NSUserDefaults standardUserDefaults]objectForKey:USER_LOGINACC];
    if (self.userStr==nil) {
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                             message:@"账号不会空"
                                                            delegate:nil
                                                   cancelButtonTitle:@"确定"
                                                   otherButtonTitles:nil];
        [alertView show];
        [alertView release];
    }else
    {
     [self.activityV setHidden:NO];
    strmoney=[NSString stringWithFormat:@"%.2f",[self.priceText floatValue]];
    [self.view setUserInteractionEnabled:NO];
    [_activityV startAnimating];
    [[Zplay shareInstance]getOrderidFromServerUserId:self.userStr payMoney:strmoney paypattern:@"3" cpdefineinfo:self.cpDInfo  Delegate:self];
    }
}
- (IBAction)onPayWebAction:(id)sender {
    self.userStr=[[NSUserDefaults standardUserDefaults]objectForKey:USER_LOGINACC];
    if (self.userStr==nil) {
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                             message:@"账号不会空"
                                                            delegate:nil
                                                   cancelButtonTitle:@"确定"
                                                   otherButtonTitles:nil];
        [alertView show];
        [alertView release];
    }else
    {
    [self.activityV setHidden:NO];
    strmoney=[NSString stringWithFormat:@"%.2f",[self.priceText floatValue]];
    [self.view setUserInteractionEnabled:NO];
    [_activityV startAnimating];
    [[Zplay shareInstance]getOrderidFromServerUserId:self.userStr payMoney:strmoney paypattern:@"9" cpdefineinfo:self.cpDInfo  Delegate:self];
    }
    
    

}
- (IBAction)onUPPayAction:(id)sender {
    self.userStr=[[NSUserDefaults standardUserDefaults]objectForKey:USER_LOGINACC];
    if (self.userStr==nil) {
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                             message:@"账号不会空"
                                                            delegate:nil
                                                   cancelButtonTitle:@"确定"
                                                   otherButtonTitles:nil];
        [alertView show];
        [alertView release];
    }else
    {
        [self.activityV setHidden:NO];
        strmoney=[NSString stringWithFormat:@"%.2f",[self.priceText floatValue]];
        [self.view setUserInteractionEnabled:NO];
        [_activityV startAnimating];
        [[Zplay shareInstance]getOrderidFromServerUserId:self.userStr payMoney:strmoney paypattern:@"10" cpdefineinfo:self.cpDInfo  Delegate:self];
    }


}
- (IBAction)backAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)backGameAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)request:(ZplayRequest *)request didFailWithError:(NSError *)error
{
    NSLog(@"%@",[error localizedDescription]);
    [_activityV stopAnimating];
     [self.activityV setHidden:YES];
    [self.view setUserInteractionEnabled:YES];
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                         message:@"网络数据异常，请稍后再尝试操作"
                                                        delegate:nil
                                               cancelButtonTitle:@"确定"
                                               otherButtonTitles:nil];
    [alertView show];
    [alertView release];
}
- (void)request:(ZplayRequest *)request didFinishLoadingWithResult:(id)result
{
    NSLog(@"%@",result);
    
     [self.activityV setHidden:YES];
    [_activityV stopAnimating];
   [self.view setUserInteractionEnabled:YES];
    if ([[[request.params objectForKey:@"data"] objectForKey:@"action"]isEqualToString:@"getOrderid"]) {
        if ([[[result objectForKey:@"msg"] objectForKey:@"text"] caseInsensitiveCompare:@"OK"]==NSOrderedSame) {
            NSString *orderid=[[result objectForKey:@"data"]objectForKey:@"orderid"];
            [[NSUserDefaults standardUserDefaults]setObject:orderid forKey:@"orderStr"];
            
            if ([[[request.params objectForKey:@"data"] objectForKey:@"paypattern"]isEqualToString:@"3"]) {
                [[Zplay shareInstance]callZFBorderid:orderid productName:self.commodtyStr productDescription:@"一元一个元宝" productAmount:strmoney];
                [self dismissViewControllerAnimated:YES completion:nil];
            }else if ([[[request.params objectForKey:@"data"] objectForKey:@"paypattern"]isEqualToString:@"9"])
            {
                ZfbWebViewController *zfbWeb=[[ZfbWebViewController alloc]init];
                zfbWeb.paraStr=orderid;
                zfbWeb.commodityStr=_commodtyStr;
                zfbWeb.priceStr=strmoney;
                [self.navigationController pushViewController:zfbWeb animated:YES];
                [zfbWeb release];
            }else if ([[[request.params objectForKey:@"data"] objectForKey:@"paypattern"]isEqualToString:@"10"])
            {
                if ([[[result objectForKey:@"msg"] objectForKey:@"text"] caseInsensitiveCompare:@"OK"]==NSOrderedSame)
                {
                 NSLog(@"%@",result);
                 NSString *paStr=[NSString stringWithFormat:@"%.0f",[self.priceText floatValue]*100];
                NSString *postStr=[NSString stringWithFormat:@"merchantOrderTime=%@&orderid=%@&merchantOrderAmt=%@&merchantOrderDesc=%@",[[Zplay shareInstance]acquireTimeStr],[[result objectForKey:@"data"]objectForKey:@"orderid"],paStr,@"一元一个元宝"];
                NSURL *urls=[NSURL URLWithString:SubmitSUrl];
                NSMutableURLRequest *request=[[NSMutableURLRequest alloc]init];
                
                [request setURL:urls];
                [request setHTTPMethod:@"POST"];
                [request setTimeoutInterval:30];
                [request setHTTPBody:[postStr dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES]];
                [request setHTTPBody:[NSData dataWithBytes:[postStr UTF8String] length:strlen([postStr UTF8String])]];
                connection2 = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
                [request release];
                    self.view.hidden=YES;
                }else
                {
                    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                         message:@"网络数据异常，请稍后再尝试操作"
                                                                        delegate:nil
                                                               cancelButtonTitle:@"确定"
                                                               otherButtonTitles:nil];
                    [alertView show];
                    [alertView release];
                }
            }
            
        }else
        {
            
			UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示"
																 message:@"账号密码错误"
																delegate:nil
													   cancelButtonTitle:@"确定"
													   otherButtonTitles:nil];
			[alertView show];
			[alertView release];
        }
        
        
    }
    
    
}

#pragma  mark - NSURLConnection 代理方法
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	repostData = [[NSMutableData alloc] init];
	
	}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
   	[repostData appendData:data];
    
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
				  willCacheResponse:(NSCachedURLResponse*)cachedResponse
{
	return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)theConnection
{
    NSDictionary *dic=[[XMLDictionaryParser sharedInstance]dictionaryWithData:repostData];
    if ([dic objectForKey:@"merchantOrderId"]) {
         if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad) {
        ipad=[UPOMP_iPad new];
        ipad.viewDelegate=self;
             NSLog(@"111111111111_iphone:%@",ipad);
        [self presentModalViewController: ipad animated: YES];
        [ipad setXmlData:repostData]; //初始接口传入支付报文（报文数据格式为NSData）
        //    ipad的调用是这样的
             
         }else
         {

             iphone=[UPOMP new];
             iphone=[[UPOMP alloc] init];
             iphone.viewDelegate=self;
             NSLog(@"111111111111_iphone:%@",iphone);
//             [[ [[UIApplication sharedApplication] delegate] window] addSubview:iphone.view];
             [self presentModalViewController:iphone animated:YES];
             [iphone setXmlData:repostData];
//             [repostData release];
//             repostData=Nil;
         }
    }
    [theConnection cancel];
	[theConnection release];
	theConnection = nil;
   
  
}
-(void)viewClose:(NSData*)data
{
    
	NSLog(@"---------------------%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    NSDictionary *dic=[[XMLDictionaryParser sharedInstance] dictionaryWithData:data];
    if (dic) {
        
//
        
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                             message:[[dic objectForKey:@"respDesc"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
                                                            delegate:nil
                                                   cancelButtonTitle:@"确定"
                                                   otherButtonTitles:nil];
        [alertView show];
        alertView.delegate=self;
        alertView.tag=1110;
        [alertView release];
        NSString *postStr=[NSString stringWithFormat:@"merchantOrderTime=%@&orderid=%@&merchantOrderId=%@",[dic objectForKey:@"merchantOrderTime"],[dic objectForKey:@"merchantOrderId"],[dic objectForKey:@"respDesc"]];
        NSURL *urls=[NSURL URLWithString:QuerySUrl];
         NSMutableURLRequest *requestSp=[[NSMutableURLRequest alloc]init];
        [requestSp setURL:urls];
        [requestSp setHTTPMethod:@"POST"];
        [requestSp setTimeoutInterval:30];
        [requestSp setHTTPBody:[postStr dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES]];
        [requestSp setHTTPBody:[NSData dataWithBytes:[postStr UTF8String] length:strlen([postStr UTF8String])]];
        connection2 = [[NSURLConnection alloc] initWithRequest:requestSp delegate:self startImmediately:YES];
        [requestSp release];
        
    }
}

- (void)connection:(NSURLConnection *)theConnection didFailWithError:(NSError *)error
{
	UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                         message:@"网络数据异常，请稍后再尝试操作"
                                                        delegate:nil
                                               cancelButtonTitle:@"确定"
                                               otherButtonTitles:nil];
    [alertView show];
    [alertView release];
    [theConnection cancel];
	[theConnection release];
	theConnection = nil;
   
    
}

- (void)viewDidUnload {
    [self setTitleLabel:nil];
    [self setNameLabel:nil];
    [self setGameNameLabel:nil];
    [self setGameLabelName:nil];
    [self setPriceNameLabel:nil];
    [self setPriceLabelText:nil];
    [self setShouldLabelText:nil];
    [self setZfbTextLabel:nil];
    [self setTextLabel:nil];
    [self setZfbT:nil];
    
    [self setZfbT2:nil];
    [self setPayTextLabel:nil];
    [self setUPPayLabel:nil];
    [self setUppBtn:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
    
}
- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscape;
}
-(BOOL)shouldAutorotate
{
    return NO;
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==1110) {
        if (buttonIndex==0) {
            [self dismissViewControllerAnimated:YES completion:Nil];
        }
    }
    
}
@end
