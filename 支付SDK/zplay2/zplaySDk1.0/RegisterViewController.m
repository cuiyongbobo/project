//
//  RegisterViewController.m
//  zplaySDk1.0
//
//  Created by ZPLAY005 on 14-2-25.
//  Copyright (c) 2014年 ZPLAY005. All rights reserved.
//

#import "RegisterViewController.h"
#import "Zplay.h"
#import "SUserDB.h"
#import "loginViewController.h"
#import "Slqite.h"
#import "DefineObjcs.h"
#import "SUser.h"
#import "ZplaySendNotify.h"
#import "MBProgressHUD.h"

@interface RegisterViewController ()<ZplayRequestDelegate,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    UITableView *tv;//下拉列表
    NSArray *tableArray;//下拉列表数据
    BOOL showList;//是否弹出下拉列表
    CGFloat tabheight;//table下拉列表的高度
    CGFloat frameHeight;//frame的高度
    CGRect bRect;
    NSTimer *timer;
    CGRect sRect;
    SUser *_registerMemberInfo;
    MBProgressHUD * tipHUD;
}
@property (retain, nonatomic) IBOutlet UIView *secondV;
@property (nonatomic,retain) UITableView *tv;
@property (nonatomic,retain) NSArray *tableArray;
@property (nonatomic,retain) UITextField *textField;
@property (nonatomic, strong) SUserDB * userDB;


@end

@implementation RegisterViewController
@synthesize tv,tableArray,textField;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:@"RegisterViewController" bundle:ZPLAY_BUNDLE];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    sRect=_secondV.frame;
    bRect=self.view.frame;
    [NSTimer initialize];
//    [[Slqite shareInstance]createDBase];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}
- (void)keyBoardWillShow:(NSNotification*)nofication
{
    self.bgViewBtn.hidden=NO;

    NSDictionary *userInfo = nofication.userInfo;
    
    CGFloat timerInterval = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    UIViewAnimationOptions animationOptions = [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    
    
    [UIView animateWithDuration:timerInterval
                          delay: 0.0
                        options: animationOptions
                     animations:^{
                         self.view.frame = (CGRect){bRect.origin.x,bRect.origin.y-50,bRect.size};
                     }
                     completion:nil];
}
- (void)keyBoardWillHide:(NSNotification*)nofication
{
    self.bgViewBtn.hidden=YES;
    //处理键盘上的tabbar
    NSDictionary *userInfo = nofication.userInfo;
    CGFloat timerInterval = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    UIViewAnimationOptions animationOptions = [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    [UIView animateWithDuration:timerInterval
                          delay: 0.0
                        options: animationOptions
                     animations:^{
                         self.view.frame=bRect;
                     }
                     completion:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[Zplay shareInstance]onekeyRegisterDelegate:self];
    self.userIdTextF.delegate=self;
    self.userDB = [[SUserDB alloc] init];
    self.tableArray=@[@"您母亲的生日是？",@"您的学号(或工号)是？",@"您小学班主任是谁？",@"您最熟悉的好友生日是?",@"您最崇拜的偶像名字是?",@"您印象最深的一组数字是?"];
    self.view.layer.cornerRadius=5.0f;
    self.bgView.layer.cornerRadius=5.0f;
    [self.bgView.layer setMasksToBounds:YES];
    
    [timer invalidate];
    timer=nil;
    
    showList = NO; //默认不显示下拉框
    tv = [[UITableView alloc] initWithFrame:CGRectMake(1, 114, CGRectGetWidth(_secondV.frame)-2, 0)];

    tv.delegate = self;
    tv.dataSource = self;

    tv.hidden = YES;
    [_secondV addSubview:tv];
    _secondV.layer.cornerRadius=5.0f;
    _secondV.layer.borderColor=[[UIColor lightGrayColor]CGColor];
    _secondV.layer.borderWidth=1.0f;

    self.userIdTextF.text=_userstr;
    
    tipHUD = [[[MBProgressHUD alloc] initWithView:self.view] autorelease];
    [self.view addSubview:tipHUD];
    tipHUD.delegate = self;
    tipHUD.labelText= @"掌游正在为您加载中...";
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
//    [_activityV release];
    [tipHUD release];
    [_aswerTextF release];
    [_thickTextF release];
    [_pwdTextF release];
    [_userIdTextF release];
    [_bgViewBtn release];
    [_bgView release];

    [_secondV release];

    [super dealloc];
}
- (void)viewDidUnload {
//    [self setActivityV:nil];
//    tipHUD = nil;
    [self setAswerTextF:nil];
    [self setThickTextF:nil];
    [self setPwdTextF:nil];
    [self setUserIdTextF:nil];
    [self setBgViewBtn:nil];
    [self setBgView:nil];

    [self setSecondV:nil];

    [super viewDidUnload];
}
- (IBAction)loginAction:(id)sender {
    
    if (_userIdTextF.text.length==0 || _pwdTextF.text.length==0) {
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                             message:@"账号密码不为空"
                                                            delegate:nil
                                                   cancelButtonTitle:@"确定"
                                                   otherButtonTitles:nil];
        
        [alertView show];
        [alertView release];
    }else if (_pwdTextF.text.length>20 || _pwdTextF.text.length<6)
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
        if (_thickTextF.text.length !=0 ) {
            if (_aswerTextF.text.length==0) {
                UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                     message:@"密保答案不为空"
                                                                    delegate:nil
                                                           cancelButtonTitle:@"确定"
                                                           otherButtonTitles:nil];
                [alertView show];
                [alertView release];
            }else
            {
                
                NSString *regex = @"(z|Z)\\d{8}";
                NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
                if(![pred2 evaluateWithObject:_userIdTextF.text])
                {
                    NSString *regex = @"^[A-Za-z0-9]+$";
                    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
                    
                    if([pred evaluateWithObject:_pwdTextF.text])                    {
                        [tipHUD show:YES];
                        [[Zplay shareInstance]registerToServerUserId:_userIdTextF.text pwd:_pwdTextF.text userQ:_thickTextF.text userA:_aswerTextF.text Delegate:self];

                    }else{
                        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"密码格式不规范，请重新输入" delegate:Nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                        [alertView show];
                        [alertView release];
                        alertView=Nil;
                    }
                }else
                {
                    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"用户名已存在" delegate:Nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                    [alertView show];
                    [alertView release];
                    alertView=Nil;
                    
                }
                
                
            }
            
            
        }else
        {
            if (_aswerTextF.text.length !=0) {
                UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                     message:@"密保问题不为空"
                                                                    delegate:nil
                                                           cancelButtonTitle:@"确定"
                                                           otherButtonTitles:nil];
                [alertView show];
                [alertView release];
            }else{
                NSString *regex = @"(z|Z)\\d{8}";
                NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
                if(![pred2 evaluateWithObject:_userIdTextF.text])
                {
                    NSString *regex = @"^[A-Za-z0-9]+$";
                    
                    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
                    
                    
                    
                    if([pred evaluateWithObject:_pwdTextF.text])
                    {
                        [tipHUD show:YES];

                        [[Zplay shareInstance]registerToServerUserId:_userIdTextF.text pwd:_pwdTextF.text userQ:_thickTextF.text userA:_aswerTextF.text Delegate:self];

//                        [_activityV startAnimating];
                    }else{
                        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"密码格式不规范，请重新输入" delegate:Nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                        [alertView show];
                        [alertView release];
                        alertView=Nil;
                    }
                }else
                {
                    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"用户名已存在" delegate:Nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                    [alertView show];
                    [alertView release];
                    alertView=Nil;
                    
                }
                
            }
        }
        
    }

}

- (void)request:(ZplayRequest *)request didFailWithError:(NSError *)error
{
    [tipHUD setHidden:YES];
//    [_activityV stopAnimating];
    NSLog(@"%@",[error localizedDescription]);
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
     NSString *str3=[[result objectForKey:@"msg"] objectForKey:@"text"];
    NSString *result10 = (NSString*)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,
                                                                                            (CFStringRef)str3,
                                                                                            CFSTR(""),
                                                                                            kCFStringEncodingUTF8);
    NSLog(@"%@-------%@",result10,result);
     if ([[[request.params objectForKey:@"data"] objectForKey:@"action"]isEqualToString:@"register"])
    {
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:ISSHOWUPPY];
        
        NSString *strCode=[[result objectForKey:@"msg"] objectForKey:@"code"];
        if ([[[result objectForKey:@"msg"] objectForKey:@"text"] caseInsensitiveCompare:@"OK"]==NSOrderedSame)
        {
            [[NSUserDefaults standardUserDefaults]setBool:YES forKey:ISLOGON];
            [[NSUserDefaults standardUserDefaults]setObject:[[result objectForKey:@"data"] objectForKey:@"userid"] forKey:USER_LOGINACC];
            [[NSUserDefaults standardUserDefaults]setObject:_pwdTextF.text forKey:USER_LOGINPWD];
            
            NSString* uid = [[result objectForKey:@"data"] objectForKey:@"userid"];
            NSString* name = [[result objectForKey:@"data"] objectForKey:@"username"];
            NSString * code = [[result objectForKey:@"msg"] objectForKey:@"code"];
            NSString * text = [[result objectForKey:@"msg"] objectForKey:@"text"];
            NSMutableDictionary *mDic=[NSMutableDictionary dictionaryWithCapacity:100];
            if (uid.length!=0&&name.length!=0&&code.length!=0&&text.length!=0) {
                [mDic setObject:uid forKey:@"userid"];
                [mDic setObject:name forKey:@"username"];
                [mDic setObject:code forKey:@"code"];
                [mDic setObject:text forKey:@"text"];
            }
//            _registerMemberInfo = [[SUser alloc]initWithDict:mDic];

            if ([[NSUserDefaults standardUserDefaults]boolForKey:USER_ISREMBER]) {
                [[NSUserDefaults standardUserDefaults]setBool:YES forKey:ISAUTOLOGIN];
            }else{
                [[NSUserDefaults standardUserDefaults]setBool:NO forKey:ISAUTOLOGIN];
            }
           [[NSUserDefaults standardUserDefaults]setObject:[[result objectForKey:@"data"] objectForKey:@"username"] forKey:USER_LOGINNAME] ;
            NSString *partent=[[result objectForKey:@"data"] objectForKey:@"pattern"];
            NSArray *parAry=[partent componentsSeparatedByString:@","];
            if (parAry.count !=0) {
                for (int i=0; i<parAry.count; i++) {
                    NSString *st=[parAry objectAtIndex:i];
                    
                    if ([st intValue]==10) {
                        
                        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:ISSHOWUPPY];
                    }
                }
            }
           

                [[Slqite shareInstance]insertDbaseUserId:[[result objectForKey:@"data"] objectForKey:@"userid"] UserName:[[result objectForKey:@"data"] objectForKey:@"username"] Password:_pwdTextF.text];

            
            [[Zplay shareInstance]enterGamePostServerruserId:[[result objectForKey:@"data"] objectForKey:@"userid"] userPwd:_pwdTextF.text Delegate:self];
            timer=[NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
            
            if ([[ZplaySendNotify sharedInstance].myDelegate respondsToSelector:@selector(addObserver:result:)]) {
                [[ZplaySendNotify sharedInstance].myDelegate addObserver:mDic result:ZplayRegisterResult];
            }
            
            [self dismissViewControllerAnimated:YES completion:Nil];
        
        
        }else if ([strCode isEqualToString:@"3"])
        {
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                 message:@"用户名已存在"
                                                                delegate:nil
                                                       cancelButtonTitle:@"确定"
                                                       otherButtonTitles:nil];
            [alertView show];
            [alertView release];
            _userIdTextF.text=nil;
            [tipHUD setHidden:YES];

        }else{
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                 message:@"注册失败"
                                                                delegate:nil
                                                       cancelButtonTitle:@"确定"
                                                       otherButtonTitles:nil];
            [alertView show];
            [alertView release];
            [tipHUD setHidden:YES];

        }
    }

    
}
-(void)timerAction
{
    [[Zplay shareInstance]acquireGameEndtime];
    
    
}
- (IBAction)hidenKeyBoardAction:(id)sender {
    [self.userIdTextF resignFirstResponder];
    [self.pwdTextF resignFirstResponder];
    [self.aswerTextF resignFirstResponder];
}
- (IBAction)showTableList:(id)sender {
    [self showTableView];
   }

- (IBAction)showTableBtn:(id)sender {
    [self showTableView];

}

- (void)showTableView{
    if (showList) {//如果下拉框已显示，什么都不做
        showList = NO;
        tv.hidden = YES;
        [UIView beginAnimations:@"Res" context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveLinear];
        _secondV.frame = sRect;
        [UIView commitAnimations];
        return;
    }else {
        //如果下拉框尚未显示，则进行显示
        tv.hidden = NO;
        showList = YES;//显示下拉框
        
        CGRect frame = tv.frame;
        frame.size.height = 0;
        tv.frame = frame;
        frame.size.height = 60;
        
        [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveLinear];
        tv.frame = frame;
        _secondV.frame=CGRectMake(41, 45, CGRectGetWidth(_secondV.frame), 210);
        tv.backgroundColor=[UIColor lightGrayColor];
        [UIView commitAnimations];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [tableArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.backgroundColor=[UIColor lightGrayColor];
    }
    
    cell.textLabel.text = [tableArray objectAtIndex:[indexPath row]];
    cell.textLabel.font = [UIFont systemFontOfSize:11.0f];
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _thickTextF.text = [tableArray objectAtIndex:[indexPath row]];
    showList = NO;
    tv.hidden = YES;
    [UIView beginAnimations:@"Res" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    _secondV.frame = sRect;
    [UIView commitAnimations];
    
}


-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:Nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:Nil];
    
}
- (IBAction)backLoginVctrl:(id)sender {
    loginViewController *loginVctrl=[[loginViewController alloc]init];
    [self.navigationController pushViewController:loginVctrl animated:YES];
    [loginVctrl release];
    loginVctrl=nil;
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

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (_userIdTextF.text.length<=20 && _userIdTextF.text.length>=6) {
        NSString *regex = @"^[A-Za-z0-9]+$";
        
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        
        if([pred evaluateWithObject:_userIdTextF.text])
        {
            
            NSString *regex = @"^.*(.)\\1{4}.*$";
            
            NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
            if([pred2 evaluateWithObject:_userIdTextF.text])
            {
                UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                     message:@"用户名不符合规范，请重新输入"
                                                                    delegate:nil
                                                           cancelButtonTitle:@"确定"
                                                           otherButtonTitles:nil];
                [alertView show];
                [alertView release];
                
                _userIdTextF.text=nil;
                
            }
        }else
        {
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                 message:@"用户名不符合规范，请重新输入"
                                                                delegate:nil
                                                       cancelButtonTitle:@"确定"
                                                       otherButtonTitles:nil];
            [alertView show];
            [alertView release];
            _userIdTextF.text=nil;
        }
    }else
    {
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                             message:@"用户名不符合规范，请重新输入"
                                                            delegate:nil
                                                   cancelButtonTitle:@"确定"
                                                   otherButtonTitles:nil];
        [alertView show];
        [alertView release];
        _userIdTextF.text=nil;
    }

}
@end
