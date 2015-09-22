//
//  ReplacePwdVCtl.m
//  zplaySDk1.0
//
//  Created by ZPLAY005 on 14-4-3.
//  Copyright (c) 2014年 ZPLAY005. All rights reserved.
//

#import "ReplacePwdVCtl.h"
#import "Zplay.h"
#import "ForgetPWDVCtl.h"
#import "loginViewController.h"
#import "DefineObjcs.h"
#import "Slqite.h"
@interface ReplacePwdVCtl ()<ZplayRequestDelegate>
- (IBAction)backLoginVctrlAction:(id)sender;
@property (retain, nonatomic) IBOutlet UIButton *jBtn;
@property (retain, nonatomic) IBOutlet UILabel *titleLabel;
- (IBAction)hidenKeyBoardAction:(id)sender;
@end

@implementation ReplacePwdVCtl

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:@"ReplacePwdVCtl" bundle:ZPLAY_BUNDLE];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}
- (void)keyBoardWillShow:(NSNotification*)nofication
{
    
    self.jBtn.hidden=NO;
    
}
- (void)keyBoardWillHide:(NSNotification*)nofication
{
    self.jBtn.hidden=YES;
    
    //处理键盘上的tabbar
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSString *regex = @"(z|Z)\\d{8}";
    NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if(![pred2 evaluateWithObject:_useridStr])
    {
        self.topLabel.text=[NSString stringWithFormat:@"请为用户名:%@重新设置密码",_useridStr];
    }else{
        self.topLabel.text=[NSString stringWithFormat:@"请为通行证:%@重新设置密码",_useridStr];
    }
    
    
    
    [self.jBtn setHidden:YES];
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad) {
        _titleLabel.font=[UIFont systemFontOfSize:25.0f];
        _pwdTextf.font=[UIFont systemFontOfSize:25.0f];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_topLabel release];
    [_pwdTextf release];
    [_jBtn release];
    [_titleLabel release];
    [super dealloc];
}
- (IBAction)commitAction:(id)sender {
    if (self.pwdTextf.text.length==0) {
        
    }else if (self.pwdTextf.text.length>20 || self.pwdTextf.text.length<6)
    {
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                             message:@"密码长度（6-20位）"
                                                            delegate:nil
                                                   cancelButtonTitle:@"确定"
                                                   otherButtonTitles:nil];
        [alertView show];
        [alertView release];
    }else
    {
        [[Zplay shareInstance]resetPwdFromServerUserId:_useridStr userPwd:self.pwdTextf.text Delegate:self];
    }
}
- (void)request:(ZplayRequest *)request didFailWithError:(NSError *)error
{
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
    NSString *str=[[result objectForKey:@"msg"] objectForKey:@"text"];
    if ([str isEqualToString:@"OK"]) {
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                             message:@"提交成功"
                                                            delegate:nil
                                                   cancelButtonTitle:@"确定"
                                                   otherButtonTitles:nil];
        [alertView show];
        [alertView release];
        [[NSUserDefaults standardUserDefaults]setObject:_useridStr forKey:USER_LOGINACC];
        [[NSUserDefaults standardUserDefaults]setObject:self.pwdTextf.text forKey:USER_LOGINPWD];
        loginViewController *loginVctrl=[[loginViewController alloc]init];
        [self.navigationController pushViewController:loginVctrl animated:YES];
        NSString *userid=[[result objectForKey:@"data"] objectForKey:@"userid"];
        [[Slqite shareInstance]upDataDbaseOldUserId:userid UserName:Nil Password:self.pwdTextf.text];
        [loginVctrl release];
    }
    else
    {
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                             message:@"提交失败"
                                                            delegate:nil
                                                   cancelButtonTitle:@"确定"
                                                   otherButtonTitles:nil];
        [alertView show];
        [alertView release];
    }
}
- (IBAction)backLoginVctrlAction:(id)sender {
    ForgetPWDVCtl *forVctrl=[[ForgetPWDVCtl alloc]init];
    forVctrl.userIdStr=_useridStr;
    [self.navigationController pushViewController:forVctrl animated:YES];
    [forVctrl release];
    forVctrl=nil;
}
- (IBAction)hidenKeyBoardAction:(id)sender {
    [[[UIApplication sharedApplication]keyWindow]endEditing:NO];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [[[UIApplication sharedApplication] keyWindow] endEditing:NO];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    
    
}
- (void)viewDidUnload {
    [self setTitleLabel:nil];
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
    return YES;
}



@end
