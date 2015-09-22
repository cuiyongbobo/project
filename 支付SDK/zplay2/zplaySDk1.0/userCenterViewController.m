//
//  userCenterViewController.m
//  zplaySDk1.0
//
//  Created by ZPLAY005 on 14-2-8.
//  Copyright (c) 2014年 ZPLAY005. All rights reserved.
//

#import "userCenterViewController.h"
#import "ACCSafetyViewController.h"
#import "MoreVCtl.h"
#import "DefineObjcs.h"
#import "loginViewController.h"
#import "pwdVctrl.h"
#import "rechargeViewController.h"
#import "Zplay.h"
#import "Slqite.h"

@interface userCenterViewController ()<UIAlertViewDelegate,ZplayRequestDelegate>
{
    int bin;
}
@property (retain, nonatomic) IBOutlet UILabel *titleLabel;
@property (retain, nonatomic) IBOutlet UILabel *Namelabel;
@property (retain, nonatomic) IBOutlet UILabel *userNameL2;
@property (retain, nonatomic) IBOutlet UITextField *userTextF;
@property (retain, nonatomic) IBOutlet UIButton *changeBtn;
@property (retain, nonatomic) IBOutlet UIButton *hidenBtn;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *activityView;




@end

@implementation userCenterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    bin=1;
    self.userIdLable.text=self.useridStr;
    self.userTextF.layer.borderWidth=1.0f;
    self.userTextF.layer.cornerRadius=5.0f;
    self.userTextF.layer.borderColor=[[UIColor clearColor]CGColor];
    self.userTextF.text=[[NSUserDefaults standardUserDefaults]objectForKey:USER_LOGINNAME];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
    
}
- (void)keyBoardWillShow:(NSNotification*)nofication
{
    self.hidenBtn.hidden=NO;
   
}
- (void)keyBoardWillHide:(NSNotification*)nofication
{
    self.hidenBtn.hidden=YES;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscape;
}
-(BOOL)shouldAutorotate
{
    return YES;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
    
    [_changeBtn setTitle:@"修改" forState:UIControlStateNormal];
    [self.userTextF setUserInteractionEnabled:NO];
    
    
    
    _changeBtn.layer.cornerRadius=5.0f;
    _useridStr=[[NSUserDefaults standardUserDefaults]objectForKey:USER_LOGINACC];
    
    if ( [[NSUserDefaults standardUserDefaults]boolForKey:ISAUTOLOGIN]) {
        [_autoBtn setBackgroundImage:[UIImage imageNamed:@"8"] forState:UIControlStateNormal];
       
    }else
    {
        [_autoBtn setBackgroundImage:[UIImage imageNamed:@"9"] forState:UIControlStateNormal];
        
    }
   
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad) {
        _Namelabel.font=[UIFont systemFontOfSize:25];
        _titleLabel.font=[UIFont systemFontOfSize:30.0f];
        _userIdLable.font=[UIFont systemFontOfSize:25.0f];
        _userTextF.font=[UIFont systemFontOfSize:25.0f];
        _userNameL2.font=[UIFont systemFontOfSize:25.0f];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
   
}

- (void)dealloc {
    [_userIdLable release];
    
    [_autoBtn release];
    [_Namelabel release];
    [_titleLabel release];
    [_userNameL2 release];
    [_userTextF release];
    [_changeBtn release];
    [_hidenBtn release];
    [_activityView release];
    [super dealloc];
}
-(void)changeSwich:(UISwitch *)sender
{
    if (sender.isOn) {
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:ISAUTOLOGIN];
    }else
    {
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:ISAUTOLOGIN];
    }
}

#pragma mark - Table view delegate
- (IBAction)backGameAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)enterSecureVctrlAction:(id)sender {
    if (_useridStr==nil) {
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                             message:@"账号不为空"
                                                            delegate:nil
                                                   cancelButtonTitle:@"确定"
                                                   otherButtonTitles:nil];
        [alertView show];
        [alertView release];
    }else{
        ACCSafetyViewController *secureVctrl=[[ACCSafetyViewController alloc]init];
        [self.navigationController pushViewController: secureVctrl animated:YES];
        [secureVctrl release];
    }

}

- (IBAction)enterRechargeVctrlAction:(id)sender {
    if (_useridStr==nil) {
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                             message:@"账号不为空"
                                                            delegate:nil
                                                   cancelButtonTitle:@"确定"
                                                   otherButtonTitles:nil];
        [alertView show];
        [alertView release];
    }else{
    rechargeViewController *rechargeVctrl=[[rechargeViewController alloc]init];
    rechargeVctrl.userId=self.useridStr;
    [self.navigationController pushViewController:rechargeVctrl animated:YES];
    [rechargeVctrl release];
    }
}

- (IBAction)enterMorevctrlAction:(id)sender {
    if (_useridStr==nil) {
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                             message:@"账号不为空"
                                                            delegate:nil
                                                   cancelButtonTitle:@"确定"
                                                   otherButtonTitles:nil];
        [alertView show];
        [alertView release];
    }else{
    MoreVCtl *moreVctrl =[[MoreVCtl alloc]init];
    moreVctrl.useridStr=self.useridStr;
    [self.navigationController pushViewController:moreVctrl animated:YES];
    [moreVctrl release];
    }
}

- (IBAction)automaticAction:(id)sender {

    if (![[NSUserDefaults standardUserDefaults]boolForKey:USER_ISREMBER]) {
        
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                             message:@"您需要在登录时勾选‘记住密码’，才能使用该功能"
                                                            delegate:nil
                                                   cancelButtonTitle:@"确定"
                                                   otherButtonTitles:nil];
        [alertView show];
        [alertView release];
   
    
    }else if ( [[NSUserDefaults standardUserDefaults]boolForKey:ISAUTOLOGIN]) {
        [sender setBackgroundImage:[UIImage imageNamed:@"9"] forState:UIControlStateNormal];
         [[NSUserDefaults standardUserDefaults]setBool:NO forKey:ISAUTOLOGIN];
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                             message:@"自动登录已关闭"
                                                            delegate:nil
                                                   cancelButtonTitle:@"确定"
                                                   otherButtonTitles:nil];
        [alertView show];
        [alertView release];
    }else
    {
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:ISAUTOLOGIN];
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                             message:@"自动登录已启动"
                                                            delegate:nil
                                                   cancelButtonTitle:@"确定"
                                                   otherButtonTitles:nil];
        [alertView show];
        [alertView release];
        [sender setBackgroundImage:[UIImage imageNamed:@"8"] forState:UIControlStateNormal];
         [[NSUserDefaults standardUserDefaults]setBool:YES forKey:ISAUTOLOGIN];
    }
}

- (IBAction)recomposePwdVctrlAction:(id)sender {
    if (_useridStr==nil) {
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                             message:@"账号不为空"
                                                            delegate:nil
                                                   cancelButtonTitle:@"确定"
                                                   otherButtonTitles:nil];
        [alertView show];
        [alertView release];
    }else{
    pwdVctrl *pVctrl=[[pwdVctrl alloc]init];
    pVctrl.acctr=self.useridStr;
   [self.navigationController pushViewController:pVctrl animated:YES];
    [pVctrl release];
    }
}

- (IBAction)logoutAction:(id)sender {
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                         message:@"注销当前账号的登录状态，返回游戏登录界面。是否确定？"
                                                        delegate:nil
                                               cancelButtonTitle:@"取消"
                                               otherButtonTitles:@"确定",Nil];
    [alertView show];
    alertView.tag=1001;
    alertView.delegate=self;
    [alertView release];
    
    
    

}
- (IBAction)hidenKeyBoardAction:(id)sender {
    [_userTextF resignFirstResponder];
}

- (IBAction)backComeGameAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:Nil];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==1001) {
        if (buttonIndex==0) {
            
        }else
        {
            [[NSUserDefaults standardUserDefaults]setBool:NO forKey:ISLOGON];
            [[Zplay shareInstance]acquireGameEndtime];
            [_autoBtn setBackgroundImage:[UIImage imageNamed:@"9"] forState:UIControlStateNormal];
            [[NSUserDefaults standardUserDefaults]setBool:YES forKey:ISAUTOLOGIN];
            
            if ( [[NSUserDefaults standardUserDefaults]boolForKey:ISAUTOLOGIN]) {
                [_autoBtn setBackgroundImage:[UIImage imageNamed:@"8"] forState:UIControlStateNormal];
                [[NSUserDefaults standardUserDefaults]setBool:NO forKey:ISAUTOLOGIN];
            }
            loginViewController *loginVctrl =[[loginViewController alloc]init];
            [self.navigationController pushViewController:loginVctrl animated:YES];
            [loginVctrl release];
        }
    }
    

}
- (IBAction)changeNameAction:(id)sender {
    
    if (bin==1) {
        self.userTextF.layer.borderColor=[[UIColor lightGrayColor]CGColor];
        [_changeBtn setTitle:@"完成" forState:UIControlStateNormal];
        [_userTextF setUserInteractionEnabled:YES];
        bin=2;
    }else{
    
    if (_userTextF.text.length<20 && _userTextF.text.length>=6) {
       
        NSString *regex = @"^[A-Za-z0-9]+$";
        
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        
        
        
        if([pred evaluateWithObject:_userTextF.text])
        {
            
            NSString *regex = @"^.*(.)\\1{4}.*$";
            
            NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
            if(![pred2 evaluateWithObject:_userTextF.text])
            {
                
                
                    [_activityView stopAnimating];
                    self.userTextF.layer.borderColor=[[UIColor clearColor]CGColor];
                    NSString *regex = @"(z|Z)\\d{8}";
                    NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
                    if(![pred2 evaluateWithObject:_userTextF.text])
                    {
                        [self.changeBtn setUserInteractionEnabled:NO];
                        [[Zplay shareInstance]changeNameFromServerUserId:_useridStr UserName:_userTextF.text Delegate:self];
                    }else
                    {
                        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"用户名已存在" delegate:Nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                        [alertView show];
                        [alertView release];
                        alertView=Nil;
                        
                    }
                
            }else{
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"用户名不符合标准" delegate:Nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alertView show];
                [alertView release];
                alertView=Nil;

            }
        }else
        {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"用户名不符合标准" delegate:Nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
            [alertView release];
            alertView=Nil;
            
        }
    }else{
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"用户名(6-20位字母和数字)" delegate:Nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        [alertView release];
        alertView=Nil;
    }
    }
}
- (void)request:(ZplayRequest *)request didFailWithError:(NSError *)error
{
    [self.changeBtn setUserInteractionEnabled:YES];
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                         message:@"网络数据异常，请稍后再尝试操作"
                                                        delegate:nil
                                               cancelButtonTitle:@"确定"
                                               otherButtonTitles:nil];
    [alertView show];
    [alertView release];
    self.userTextF.layer.borderColor=[[UIColor lightGrayColor]CGColor];
}
- (void)request:(ZplayRequest *)request didFinishLoadingWithResult:(id)result
{
    NSLog(@"%@",result);
    [self.changeBtn setUserInteractionEnabled:YES];
    if ([[[request.params objectForKey:@"data"] objectForKey:@"action"]isEqualToString:@"changeName"])
    {
        NSString *codeStr=[[result objectForKey:@"msg"] objectForKey:@"code"];
        if ([[[result objectForKey:@"msg"] objectForKey:@"text"] caseInsensitiveCompare:@"OK"]==NSOrderedSame) {
            
            [[NSUserDefaults standardUserDefaults]setObject:_userTextF.text forKey:USER_LOGINNAME];
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                 message:@"修改成功"
                                                                delegate:nil
                                                       cancelButtonTitle:@"确定"
                                                       otherButtonTitles:nil];
            [alertView show];
            [alertView release];
            [[Slqite shareInstance]upDataDbaseOldUserId:_useridStr UserName:_userTextF.text Password:Nil];
            [_changeBtn setTitle:@"修改" forState:UIControlStateNormal];
            
            [_userTextF setUserInteractionEnabled:NO];
            bin=1;
        
        }else if ([codeStr isEqualToString:@"3"])
        {
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                 message:@"用户名已存在"
                                                                delegate:nil
                                                       cancelButtonTitle:@"确定"
                                                       otherButtonTitles:nil];
            [alertView show];
            [alertView release];
            self.userTextF.layer.borderColor=[[UIColor lightGrayColor]CGColor];
        }
    }

}
- (void)viewDidUnload {
    [self setTitleLabel:nil];
    [self setUserNameL2:nil];
    [self setUserTextF:nil];
    [self setChangeBtn:nil];
    [self setHidenBtn:nil];
    [self setActivityView:nil];
    [super viewDidUnload];
}
@end
