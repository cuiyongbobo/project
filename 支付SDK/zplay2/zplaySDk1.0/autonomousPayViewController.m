//
//  autonomousPayViewController.m
//  zplaySDk1.0
//
//  Created by ZPLAY005 on 14-2-10.
//  Copyright (c) 2014年 ZPLAY005. All rights reserved.
//

#import "autonomousPayViewController.h"
#import "Zplay.h"
#import "ZfbWebViewController.h"
#import "UPOMP.h"
#import "UPOMP_iPad.h"
#import "XMLDictionary.h"
#import "DefineObjcs.h"

@interface autonomousPayViewController ()<ZplayRequestDelegate,UPOMP_iPad_Delegate,UPOMPDelegate,UIAlertViewDelegate>
{
    UPOMP_iPad *ipad;
    UPOMP *iphone;
    float payMoney;
     NSString *orderid;
    NSString *strmoney;
     NSURLConnection *connection3;
    NSMutableData *repostData2;
    MBProgressHUD *tipHUD;
}
@property (retain, nonatomic) IBOutlet UILabel *nameGameLabel;
@property (retain, nonatomic) IBOutlet UILabel *userNameLabel;
@property (retain, nonatomic) IBOutlet UILabel *commNameLabel;
@property (retain, nonatomic) IBOutlet UILabel *uppLabel;

@property (retain, nonatomic) IBOutlet UILabel *kuaishuLabel;
@property (retain, nonatomic) IBOutlet UILabel *shouldLabel;
@property (retain, nonatomic) IBOutlet UILabel *dinggouLabel;
@property (retain, nonatomic) IBOutlet UILabel *textLabel;
@property (retain, nonatomic) IBOutlet UILabel *numberLaber;

@property (retain, nonatomic) IBOutlet UIView *contentView;
@property (retain, nonatomic) IBOutlet UIView *bottomView;
@property (retain, nonatomic) IBOutlet UITextField *numbeitextf;
@property (retain, nonatomic) IBOutlet UILabel *priceLabel;
@property (retain, nonatomic) IBOutlet UILabel *zfbText1;
@property (retain, nonatomic) IBOutlet UILabel *zfbText2;
@property (retain, nonatomic) IBOutlet UIButton *uppBtn;

//@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *activityV;
- (IBAction)onPriceBtnAction:(id)sender;

- (IBAction)onPayBtnAction:(id)sender;
- (IBAction)backGame:(id)sender;
- (IBAction)hidenKeyboardAction:(id)sender;
@property (retain, nonatomic) IBOutlet UILabel *titleLabel;


@end

@implementation autonomousPayViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:@"autonomousPayViewController" bundle:ZPLAY_BUNDLE];
    if (self) {
        // Custom initialization
    }
    return self;
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
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.bgBtn.hidden=YES;
   
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
}
- (void)keyBoardWillShow:(NSNotification*)nofication
{
    [self.bgBtn setHidden:NO];
    
   
}
- (void)keyBoardWillHide:(NSNotification*)nofication
{
    [self.bgBtn setHidden:YES];
    if (self.numbeitextf.text !=nil && self.numbeitextf.text.length !=0) {
        payMoney=[self.numbeitextf.text floatValue]/10;
        self.priceLabel.text=[NSString stringWithFormat:@"%.2f元",payMoney];
    }else
    {
        self.priceLabel.text=@"0元";
        payMoney=0;;
    }
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:Nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:Nil];
    
    self.numbeitextf.layer.cornerRadius=3.0f;
    self.numbeitextf.layer.borderColor=[[UIColor lightGrayColor] CGColor];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [_uppBtn setHidden:YES];
    [_uppLabel setHidden:YES];
    if ([[NSUserDefaults standardUserDefaults]boolForKey:ISSHOWUPPY]) {
        [_uppBtn setHidden:NO];
        [_uppLabel setHidden:NO];
    }
    tipHUD = [[[MBProgressHUD alloc] initWithView:self.view] autorelease];
    [self.view addSubview:tipHUD];
    tipHUD.delegate = self;
    tipHUD.labelText= @"掌游正在为您加载...";
    
    self.priceLabel.text=@"0元";
    [self.bgBtn setHidden:YES];
//    [self.activityV setHidden:YES];
    self.useridLabel.text=self.useridStr;
    self.gameNameLabel.text=self.gamestr;
    self.contentView.layer.cornerRadius=5.0f;
    self.contentView.layer.borderWidth=1.0f;
    self.contentView.layer.borderColor=[[UIColor redColor] CGColor];
    
    self.bottomView.layer.cornerRadius=5.0f;
    self.bottomView.layer.borderColor=[[UIColor redColor] CGColor];
    self.bottomView.layer.borderWidth=1.0f;
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad) {
        _titleLabel.font=[UIFont systemFontOfSize:25.0f];
        _nameGameLabel.font=[UIFont systemFontOfSize:25.0f];
        _userNameLabel.font=[UIFont systemFontOfSize:25.0f];
        _commNameLabel.font=[UIFont systemFontOfSize:25.0f];
       
        _kuaishuLabel.font=[UIFont systemFontOfSize:25.0f];
        _shouldLabel.font=[UIFont systemFontOfSize:25.0f];
        _dinggouLabel.font=[UIFont systemFontOfSize:25.0f];
        _textLabel.font=[UIFont systemFontOfSize:25.0f];
        _useridLabel.font=[UIFont systemFontOfSize:25.0f];
        _gameNameLabel.font=[UIFont systemFontOfSize:25.0f];
        _numberLaber.font=[UIFont systemFontOfSize:25.0f];
        _numbeitextf.font=[UIFont systemFontOfSize:25.0f];
        _priceLabel.font=[UIFont systemFontOfSize:25.0f];
        _zfbText1.font=[UIFont systemFontOfSize:28.0f];
        _zfbText2.font=[UIFont systemFontOfSize:28.0f];
        _uppLabel.font=[UIFont systemFontOfSize:28.0f];
        
    }
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    
    [_useridLabel release];
    [_gameNameLabel release];
    [_numbeitextf release];
    [_priceLabel release];
    [_contentView release];
    [_bottomView release];
//    [_activityV release];
    [_bgBtn release];
    [_bgBtn release];
    [_bgBtn release];
    [_titleLabel release];
    
    [_nameGameLabel release];
    [_userNameLabel release];
    [_commNameLabel release];
    
    [_kuaishuLabel release];
    [_shouldLabel release];
    [_dinggouLabel release];
    [_textLabel release];
    [_numberLaber release];
    [_zfbText1 release];
    [_zfbText2 release];
    [_uppLabel release];
    [_uppBtn release];
    [super dealloc];
}
- (IBAction)onPriceBtnAction:(id)sender {
    UIButton *btn=(UIButton *)sender;
    self.priceLabel.text=[NSString  stringWithFormat:@"%ld元",(long)btn.tag];
    payMoney=btn.tag;
    self.numbeitextf.text=[NSString stringWithFormat:@"%ld",(long)btn.tag*10];
}
- (IBAction)onUPPayAction:(id)sender {
    self.useridStr=[[NSUserDefaults standardUserDefaults]objectForKey:USER_LOGINACC];
    if (self.useridStr==nil) {
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                             message:@"账号不会空"
                                                            delegate:nil
                                                   cancelButtonTitle:@"确定"
                                                   otherButtonTitles:nil];
        [alertView show];
        [alertView release];
    }else
    {
        if (payMoney==0) {
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                 message:@"价格不为0"
                                                                delegate:nil
                                                       cancelButtonTitle:@"确定"
                                                       otherButtonTitles:nil];
            [alertView show];
            [alertView release];
        }else
        {
            strmoney=[NSString stringWithFormat:@"%.2f",payMoney ];
            self.view.userInteractionEnabled=NO;
//            [_activityV startAnimating];
//            [_activityV setHidden:NO];
            
            [tipHUD show:YES];

            [[Zplay shareInstance]getOrderidFromServerUserId:self.useridStr payMoney:strmoney paypattern:@"10" cpdefineinfo:self.cpDefineInfo Delegate:self];
        }
        
    }

}

- (IBAction)onPayBtnAction:(id)sender {
    
    
    
    self.useridStr=[[NSUserDefaults standardUserDefaults]objectForKey:USER_LOGINACC];
    if (self.useridStr==nil) {
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                             message:@"账号不会空"
                                                            delegate:nil
                                                   cancelButtonTitle:@"确定"
                                                   otherButtonTitles:nil];
        [alertView show];
        [alertView release];
    }else
    {
        if (payMoney==0) {
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                 message:@"价格不为0"
                                                                delegate:nil
                                                       cancelButtonTitle:@"确定"
                                                       otherButtonTitles:nil];
            [alertView show];
            [alertView release];
        }else
        {
           strmoney=[NSString stringWithFormat:@"%0.2f",payMoney];
            self.view.userInteractionEnabled=NO;
            [tipHUD show:YES];
//            [_activityV startAnimating];
//            [_activityV setHidden:NO];
            [[Zplay shareInstance]getOrderidFromServerUserId:self.useridStr payMoney:strmoney paypattern:@"3" cpdefineinfo:self.cpDefineInfo Delegate:self];
        }
       
    }
   
}

- (IBAction)backGame:(id)sender {
[self dismissViewControllerAnimated:YES completion:nil];
    
}

- (IBAction)hidenKeyboardAction:(id)sender {
    
    if (self.numbeitextf.text !=nil && self.numbeitextf.text.length !=0) {
        payMoney=[self.numbeitextf.text floatValue]/10;
        self.priceLabel.text=[NSString stringWithFormat:@"%.2f元",payMoney];
    }else
    {
        self.priceLabel.text=@"0元";
        payMoney=0;;
    }
    
    
    [self.numbeitextf resignFirstResponder];
}

- (void)request:(ZplayRequest *)request didFailWithError:(NSError *)error
{
    NSLog(@"%@",[error localizedDescription]);
    
    [self.view setUserInteractionEnabled:YES];
//    [_activityV stopAnimating];
    [tipHUD setHidden:YES];

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

//        [_activityV stopAnimating];
    [tipHUD setHidden:YES];
    self.view.userInteractionEnabled=YES;
    if ([[[request.params objectForKey:@"data"] objectForKey:@"action"]isEqualToString:@"getOrderid"]) {
        if ([[[result objectForKey:@"msg"] objectForKey:@"text"] caseInsensitiveCompare:@"OK"]==NSOrderedSame) {
            
        
        orderid=[[result objectForKey:@"data"]objectForKey:@"orderid"];
        [[NSUserDefaults standardUserDefaults]setObject:orderid forKey:@"orderStr"];
        
        
        if ([[[request.params objectForKey:@"data"] objectForKey:@"paypattern"]isEqualToString:@"3"]) {
            [[Zplay shareInstance]callZFBorderid:orderid productName:@"点数" productDescription:@"一元十点数" productAmount:strmoney];
            [self dismissViewControllerAnimated:YES completion:nil];
        }else if ([[[request.params objectForKey:@"data"] objectForKey:@"paypattern"]isEqualToString:@"9"])
        {
            ZfbWebViewController *zfbWeb=[[ZfbWebViewController alloc]init];
            zfbWeb.paraStr=orderid;
            zfbWeb.commodityStr=@"点数";
            zfbWeb.priceStr=strmoney;
            [self.navigationController pushViewController:zfbWeb animated:YES];
            [zfbWeb release];
        }else if ([[[request.params objectForKey:@"data"] objectForKey:@"paypattern"]isEqualToString:@"10"])
        {
//             [_activityV startAnimating];
            [tipHUD show:YES];
            self.view.userInteractionEnabled=NO;
            NSLog(@"%@",result);
           
        
                NSString *paStr=[NSString stringWithFormat:@"%.0f",payMoney*100];
            NSString *postStr=[NSString stringWithFormat:@"merchantOrderTime=%@&orderid=%@&merchantOrderAmt=%@&merchantOrderDesc=%@",[[Zplay shareInstance]acquireTimeStr],[[result objectForKey:@"data"]objectForKey:@"orderid"],paStr,@"点数"];
            NSURL *urls=[NSURL URLWithString:SubmitSUrl];
            NSMutableURLRequest *request=[[NSMutableURLRequest alloc]init];
            
            [request setURL:urls];
            [request setHTTPMethod:@"POST"];
            [request setTimeoutInterval:30];
            [request setHTTPBody:[postStr dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES]];
            [request setHTTPBody:[NSData dataWithBytes:[postStr UTF8String] length:strlen([postStr UTF8String])]];
            connection3 = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
            [request release];
            self.view.hidden=YES;
        }

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
    
    NSLog(@"%@",result);
}
- (IBAction)onPayWebAction:(id)sender {
    self.useridStr=[[NSUserDefaults standardUserDefaults]objectForKey:USER_LOGINACC];
    if (self.useridStr==nil) {
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                             message:@"账号不会空"
                                                            delegate:nil
                                                   cancelButtonTitle:@"确定"
                                                   otherButtonTitles:nil];
        [alertView show];
        [alertView release];
    }else
    {
        if (payMoney==0) {
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                 message:@"价格不为0"
                                                                delegate:nil
                                                       cancelButtonTitle:@"确定"
                                                       otherButtonTitles:nil];
            [alertView show];
            [alertView release];
        }else
        {
            strmoney=[NSString stringWithFormat:@"%.2f",payMoney ];
            self.view.userInteractionEnabled=NO;
//            [_activityV startAnimating];
//            [_activityV setHidden:NO];
            [tipHUD show:YES];
            [[Zplay shareInstance]getOrderidFromServerUserId:self.useridStr payMoney:strmoney paypattern:@"9" cpdefineinfo:self.cpDefineInfo Delegate:self];
        }
        
    }

}
#pragma  mark - NSURLConnection 代理方法
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	repostData2 = [[NSMutableData alloc] init];
	
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
   	[repostData2 appendData:data];
    
}
- (void)connectionDidFinishLoading:(NSURLConnection *)theConnection
{
//    [_activityV stopAnimating];
    [tipHUD setHidden:YES];
    self.view.userInteractionEnabled=YES;
    NSDictionary *dic=[[XMLDictionaryParser sharedInstance]dictionaryWithData:repostData2];
    if ([dic objectForKey:@"merchantOrderId"]) {
        if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad) {
            ipad=[UPOMP_iPad new];
            ipad.viewDelegate=self;
            [self presentModalViewController: ipad animated: YES];
            [ipad setXmlData:repostData2]; //初始接口传入支付报文（报文数据格式为NSData）
            //    ipad的调用是这样的
 
        }else{
            iphone=[UPOMP new];
            iphone=[[UPOMP alloc] init];
            iphone.viewDelegate=self;
//            [[[UIApplication sharedApplication]keyWindow].rootViewController.view addSubview:iphone.view];
            [self presentModalViewController:iphone animated:YES];
            [iphone setXmlData:repostData2];
//            [[[[[UIApplication sharedApplication]keyWindow]subviews]objectAtIndex:0]addSubview:iphone.view];
        }
        
    }
    [theConnection cancel];
	[theConnection release];
	theConnection = nil;
    
    
}
-(void)viewClose:(NSData*)data
{
	
    NSDictionary *dic=[[XMLDictionaryParser sharedInstance] dictionaryWithData:data];
    if (dic) {
        

        
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                             message:[[dic objectForKey:@"respDesc"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
                                                            delegate:nil
                                                   cancelButtonTitle:@"确定"
                                                   otherButtonTitles:nil];
        [alertView show];
        alertView.delegate=self;
        alertView.tag=1111;
        [alertView release];
        NSString *postStr=[NSString stringWithFormat:@"merchantOrderTime=%@&orderid=%@&merchantOrderId=%@",[dic objectForKey:@"merchantOrderTime"],[dic objectForKey:@"merchantOrderId"],[dic objectForKey:@"respDesc"]];
        NSURL *urls=[NSURL URLWithString:QuerySUrl];
        NSMutableURLRequest *requestSp=[[NSMutableURLRequest alloc]init];
        [requestSp setURL:urls];
        [requestSp setHTTPMethod:@"POST"];
        [requestSp setTimeoutInterval:30];
        [requestSp setHTTPBody:[postStr dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES]];
        [requestSp setHTTPBody:[NSData dataWithBytes:[postStr UTF8String] length:strlen([postStr UTF8String])]];
        connection3 = [[NSURLConnection alloc] initWithRequest:requestSp delegate:self startImmediately:YES];
        [requestSp release];
        
    }
}

- (void)connection:(NSURLConnection *)theConnection didFailWithError:(NSError *)error
{
//    [_activityV stopAnimating];
    [tipHUD setHidden:YES];
    self.view.userInteractionEnabled=YES;

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
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==1111) {
        if (buttonIndex==0) {
            [self dismissViewControllerAnimated:YES completion:Nil];
        }
    }
    
}

- (void)viewDidUnload {
    [self setTitleLabel:nil];
    [self setGameNameLabel:nil];
    [self setNameGameLabel:nil];
    [self setUserNameLabel:nil];
    [self setCommNameLabel:nil];
    
    [self setKuaishuLabel:nil];
    [self setShouldLabel:nil];
    [self setDinggouLabel:nil];
    [self setTextLabel:nil];
    [self setNumberLaber:nil];
    [self setZfbText1:nil];
    [self setZfbText2:nil];
    [self setUppLabel:nil];
    [self setUppBtn:nil];
    [super viewDidUnload];
}

@end
