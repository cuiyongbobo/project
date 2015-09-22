//
//  UnbindPhoneViewController.m
//  ZplayAppStoreSDK
//
//  Created by ZPLAY005 on 14-3-20.
//  Copyright (c) 2014年 vbdsgfht. All rights reserved.
//

#import "UnbindPhoneViewController.h"
#import "ACCSafetyViewController.h"
#import "Zplay.h"
#import "DefineObjcs.h"

@interface UnbindPhoneViewController ()<ZplayRequestDelegate>
{
    NSTimer *timer;
    int countTimer;
    CGRect bRect;
    
    int numberCode;
     NSString *restr;
    NSString *codeIphStr;
    NSTimer *timer3;
    

}
@property (retain, nonatomic) IBOutlet UITextField *iponeT;
@property (retain, nonatomic) IBOutlet UITextField *codeT;
@property (retain, nonatomic) IBOutlet UILabel *timelabel;
@property (retain, nonatomic) IBOutlet UIButton *aquiceBtn;
@property (retain, nonatomic) IBOutlet UILabel *textLabel;
@property (retain, nonatomic) IBOutlet UILabel *accTextLabel;
@property (retain, nonatomic) IBOutlet UILabel *accLabel;
@property (retain, nonatomic) IBOutlet UIButton *heidenBtn;
@property (retain, nonatomic) IBOutlet UILabel *titleLabel;
@property(nonatomic,retain)NSString *codeString;
@property (retain, nonatomic) IBOutlet UILabel *bdLbale;
@property (retain, nonatomic) IBOutlet UIButton *commitBtn;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *activityV;

@end

@implementation UnbindPhoneViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:@"UnbindPhoneViewController" bundle:ZPLAY_BUNDLE];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    bRect=self.view.frame;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];

}
- (void)keyBoardWillShow:(NSNotification*)nofication
{
    [self.heidenBtn setHidden:NO];
    
    NSDictionary *userInfo = nofication.userInfo;
    
    CGFloat timerInterval = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    UIViewAnimationOptions animationOptions = [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    
    
    [UIView animateWithDuration:timerInterval
                          delay: 0.0
                        options: animationOptions
                     animations:^{
                         int i=100;
                         if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
                         {
                             i=130;
                         }
                         self.view.frame = (CGRect){bRect.origin.x,bRect.origin.y-i,bRect.size};
                     }
                     completion:nil];
}
- (void)keyBoardWillHide:(NSNotification*)nofication
{
    [self.heidenBtn setHidden:YES];
    
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
    timer3=[NSTimer scheduledTimerWithTimeInterval:600 target:self selector:@selector(newCode) userInfo:nil repeats:NO];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"iphtextStr"];
    NSLog(@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"iphtextStr"]);
    _accLabel.text=_userStr;
    numberCode=1;
    _textLabel.text=[NSString stringWithFormat:@"绑定%@号码，保障账号安全，在您忘记密码时可通过此方式找回密码\r(可重新设置密码绑定手机号码)",_strStryl];
    _titleLabel.text=[NSString stringWithFormat:@"绑定%@",_strStryl];
    
    
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
    {
        _timelabel.font=[UIFont systemFontOfSize:25.0f];
        _aquiceBtn.titleLabel.font=[UIFont systemFontOfSize:23.0f];
        _textLabel.font=[UIFont systemFontOfSize:25.0f];
        _accLabel.font=[UIFont systemFontOfSize:25.0f];
        _accTextLabel.font=[UIFont systemFontOfSize:25.0f];
        _bdLbale.font=[UIFont systemFontOfSize:25.0f];
        _codeT.font=[UIFont systemFontOfSize:25.0f];
        _iponeT.font=[UIFont systemFontOfSize:25.0f];
        _commitBtn.titleLabel.font=[UIFont systemFontOfSize:25.0f];
        _titleLabel.font=[UIFont systemFontOfSize:25.0f];
        
    }
    _iponeT.layer.borderColor=[[UIColor lightGrayColor]CGColor];
    _iponeT.layer.borderWidth=1.0f;
    _codeT.layer.borderWidth=1.0f;
    _codeT.layer.borderColor=[[UIColor lightGrayColor]CGColor];
    if ([_strStryl isEqualToString:@"邮箱"]) {
        _iponeT.placeholder=@"请输入邮箱地址";
    }

    if ([_strStryl isEqualToString:@"手机"]) {
        _iponeT.placeholder=@"请输入手机号码";
    }else if ([_strStryl isEqualToString:@"邮箱"])
    {
        _iponeT.placeholder=@"请输入邮箱地址";
    }
}
- (IBAction)commitAction:(UIButton *)sender {
    
    BOOL isstryl;
    if ([_strStryl isEqualToString:@"邮箱"]) {
        isstryl=[self validateEmail:_iponeT.text];
    }else
    {
        isstryl=[self validateMobile:_iponeT.text];
    }
    if (isstryl) {
        if (_codeT.text.length!=0) {

                NSString *str3=[[NSUserDefaults standardUserDefaults]objectForKey:@"codeYZ"];
                NSString *string2 = [str3 substringWithRange:NSMakeRange(17, 4)];
                NSString *ipsfv=[[NSUserDefaults standardUserDefaults]objectForKey:@"iphtextStr"];

                
            NSLog(@"验证码:%@",string2);
            
                if ([_codeT.text caseInsensitiveCompare:string2]==NSOrderedSame) {
                    
                    NSString *restersdfcn;
                    if ([_strStryl isEqualToString:@"邮箱"]) {
                        restersdfcn=@"mail";

                        
                    }else{

                        restersdfcn=@"sms";
                    }
                    if ([_iponeT.text isEqualToString:ipsfv]) {
                        [_activityV startAnimating];
                        [[Zplay shareInstance]setBindToFromSeverUserId:_userStr TypeStr:restr KeyStr:_iponeT.text ValueStr:_codeT.text Delegate:self];
                    }else{
                        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                             message:@"验证码与手机号码不匹配"
                                                                            delegate:nil
                                                                   cancelButtonTitle:@"确定"
                                                                   otherButtonTitles:nil];
                        [alertView show];
                        [alertView release];
                        return;
                    }
                    
                    
                }else{
                    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                         message:@"验证码不匹配"
                                                                        delegate:nil
                                                               cancelButtonTitle:@"确定"
                                                               otherButtonTitles:nil];
                    [alertView show];
                    [alertView release];
                    return;
                }
                
            
            
            
        }else{
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                 message:@"验证码不匹配"
                                                                delegate:nil
                                                       cancelButtonTitle:@"确定"
                                                       otherButtonTitles:nil];
            [alertView show];
            [alertView release];
            return;
        }
        
}else{
    NSString *Costr;
    if ([_strStryl isEqualToString:@"邮箱"]) {
        Costr=@"无效邮箱地址";
    }else
    {
        Costr=@"无效手机号码";
    }
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                             message:Costr
                                                            delegate:nil
                                                   cancelButtonTitle:@"确定"
                                                   otherButtonTitles:nil];
        [alertView show];
        [alertView release];
        return;
    }

    
}
-(BOOL)validateMobile:(NSString *)mobile
{
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}
-(BOOL)validateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:email];
}
- (IBAction)aquiceCodeAction:(UIButton *)sender {

    BOOL codeyan;
   
    if ([_strStryl isEqualToString:@"邮箱"]) {
        restr=@"mail";
        codeyan=[self validateEmail:_iponeT.text];
    
    }else{
        codeyan=[self validateMobile:_iponeT.text];
        restr=@"sms";
    }
    if (codeyan) {

        NSLog(@"%@=%@",_iponeT.text,[[NSUserDefaults standardUserDefaults]objectForKey:@"iphtextStr"]);
        if (![_iponeT.text isEqualToString:[[NSUserDefaults standardUserDefaults]objectForKey:@"iphtextStr"]]) {
  _codeString=[[Zplay shareInstance]aquiceCodeStringUserId:_userStr keyStr:_iponeT.text];
            [[NSUserDefaults standardUserDefaults]setObject:_codeString forKey:@"codeYZ"];
        }
            if (numberCode==1) {
                _codeString=[[Zplay shareInstance]aquiceCodeStringUserId:_userStr keyStr:_iponeT.text];
                [[NSUserDefaults standardUserDefaults]setObject:_codeString forKey:@"codeYZ"];
                
            }
        
        

        [[NSUserDefaults standardUserDefaults]setObject:_iponeT.text forKey:@"iphtextStr"];
        [[Zplay shareInstance]reportCodeToSeverUserId:_userStr TypeStr:restr KeyStr:_iponeT.text ValueStr:_codeString ifVefiy:@"0" Delegate:self];
        [_activityV startAnimating];
        timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethodS) userInfo:nil repeats:YES];
        [_timelabel setHidden:NO];
        [sender setUserInteractionEnabled:NO];
        countTimer = 179;

        NSString *str3=[[NSUserDefaults standardUserDefaults]objectForKey:@"codeYZ"];
        NSString *string2 = [str3 substringWithRange:NSMakeRange(17, 4)];
        
        NSLog(@"%@",string2);

        
        NSString *str = [NSString stringWithFormat:@"%d秒后重新获取",countTimer];
        _timelabel.text = str;
        [_iponeT setUserInteractionEnabled:NO];
    }else{
        NSString *Costr;
        if ([_strStryl isEqualToString:@"邮箱"]) {
            Costr=@"无效邮箱地址";
        }else
        {
            Costr=@"无效手机号码";
        }
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                             message:Costr
                                                            delegate:nil
                                                   cancelButtonTitle:@"确定"
                                                   otherButtonTitles:nil];
        [alertView show];
        [alertView release];
        return;
    }

    
    
}

-(void)newCode
{
    if (_iponeT.text.length!=0) {
        _codeString=[[Zplay shareInstance]aquiceCodeStringUserId:_userStr keyStr:_iponeT.text];
         [[NSUserDefaults standardUserDefaults]setObject:_codeString forKey:@"codeYZ"];

    }

}
-(void)timeFireMethodS{
    countTimer--;
    numberCode++;
    
    NSString *str = [NSString stringWithFormat:@"%d秒后重新获取",countTimer];

    [_aquiceBtn setTitle:str forState:UIControlStateNormal];
   if (countTimer == 0) {
        [_aquiceBtn setUserInteractionEnabled:YES];
       [_iponeT setUserInteractionEnabled:YES];
        [timer invalidate];
       [_aquiceBtn setTitleColor:normal forState:UIControlStateNormal];
       [_aquiceBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    }
    
}
- (IBAction)BackUserCenterVctrlAction:(UIButton *)sender {

    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];

}
- (IBAction)backGameAction:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:NO];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)hidenKeyboardAction:(id)sender {
    [self.iponeT resignFirstResponder];
    [self.codeT resignFirstResponder];
}

- (void)dealloc {
    [_iponeT release];
    [_codeT release];
    [_timelabel release];
    [_aquiceBtn release];
    [_textLabel release];
    [_accTextLabel release];
    [_accLabel release];
   
    [_heidenBtn release];
    [_titleLabel release];
    [_bdLbale release];
    [_commitBtn release];
    [_activityV release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setIponeT:nil];
    [self setCodeT:nil];
    [self setTimelabel:nil];
    [self setAquiceBtn:nil];
    [self setTextLabel:nil];
    [self setAccTextLabel:nil];
    [self setAccLabel:nil];
    [self setHeidenBtn:nil];
    [self setTitleLabel:nil];
    [self setBdLbale:nil];
    [self setCommitBtn:nil];
    [self setActivityV:nil];
    [super viewDidUnload];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [timer3 invalidate];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"iphtextStr"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"codeYZ"];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:Nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:Nil];
}
- (void)request:(ZplayRequest *)request didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"我已经连接上了");
}
- (void)request:(ZplayRequest *)request didReceiveRawData:(NSData *)data
{
    NSLog(@"正在传输数据");
}
- (void)request:(ZplayRequest *)request didFailWithError:(NSError *)error
{
    NSLog(@"%@",[error localizedDescription]);
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                         message:@"网络数据异常，请稍后再尝试操作"
                                                        delegate:nil
                                               cancelButtonTitle:@"确定"
                                               otherButtonTitles:nil];
    [alertView show];
    [alertView release];
    NSLog(@"%@",[error localizedDescription]);
    [_activityV stopAnimating];

    countTimer=1;
    countTimer=1;
}
- (void)request:(ZplayRequest *)request didFinishLoadingWithResult:(id)result
{
    [_activityV stopAnimating];
    NSString *str3=[[result objectForKey:@"msg"] objectForKey:@"text"];
    NSString *result10 = (NSString*)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,
                                                                                            (CFStringRef)str3,
                                                                                            CFSTR(""),
                                                                                            kCFStringEncodingUTF8);
    NSLog(@"上传参数%@，返回参数%@",request.params,result);
    
    NSString *str=[[result objectForKey:@"msg"] objectForKey:@"text"];
    if ([[[request.params objectForKey:@"data"] objectForKey:@"action"]isEqualToString:@"reportCode"]) {
        if ([str isEqualToString:@"OK"]) {
            codeIphStr=_iponeT.text;
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                 message:@"已发送，请注意接收"
                                                                delegate:nil
                                                       cancelButtonTitle:@"确定"
                                                       otherButtonTitles:nil];
            [alertView show];
            [alertView release];
            [_aquiceBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [_commitBtn  setUserInteractionEnabled:YES];
            
            
        }else{
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                 message:result10
                                                                delegate:nil
                                                       cancelButtonTitle:@"确定"
                                                       otherButtonTitles:nil];
            [alertView show];
            [alertView release];
            [_commitBtn  setUserInteractionEnabled:NO];
            countTimer=1;
        }
        
    }else
    {
    if ([[[request.params objectForKey:@"data"] objectForKey:@"action"]isEqualToString:@"setBind"]) {
        int r=[[[result objectForKey:@"msg"] objectForKey:@"code"] intValue];
        if (r==1) {
            _bdLbale.text=@"已绑定";
            if ([_strStryl isEqualToString:@"手机"]) {
                NSString *useriph=[NSString stringWithFormat:@"%@iph",_userStr];
                [[NSUserDefaults standardUserDefaults]setBool:YES forKey:useriph];
            }else{
                NSString *userMail=[NSString stringWithFormat:@"%@mail",_userStr];
                [[NSUserDefaults standardUserDefaults]setBool:YES forKey:userMail];
            }
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                 message:@"绑定成功"
                                                                delegate:nil
                                                       cancelButtonTitle:@"确定"
                                                       otherButtonTitles:nil];
            [alertView show];
            [alertView release];

             [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
            
        }else{
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                 message:result10
                                                                delegate:nil
                                                       cancelButtonTitle:@"确定"
                                                       otherButtonTitles:nil];
            [alertView show];
            [alertView release];
        }
    }
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
@end
