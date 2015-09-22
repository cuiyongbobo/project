//
//  loginViewController.m
//  zplaySDk1.0
//
//  Created by ZPLAY005 on 14-2-10.
//  Copyright (c) 2014年 ZPLAY005. All rights reserved.
//

#import "loginViewController.h"
#import "Zplay.h"
#import "ForgetPWDVCtl.h"
#import "AsWerVCtl.h"
#import "DefineObjcs.h"
#import "RegisterViewController.h"
#import "OlderViewController.h"
#import "Slqite.h"
#import "ZplaySendNotify.h"
#import "SUser.h"

@interface loginViewController ()<UITableViewDataSource,ZplayRequestDelegate,UITableViewDelegate,UITextFieldDelegate,UIAlertViewDelegate>
{
    CGRect bRect;
    
//    UIActivityIndicatorView *activityV;
    BOOL isremmber;
    BOOL showList;//是否弹出下拉列表
    CGFloat tabheight;//table下拉列表的高度
    CGFloat frameHeight;//frame的高度
    BOOL rem;
    CGRect contentVF;
    
    NSTimer *time;
    
    NSTimer *timer;
    SUser *_loginMemberInfo;
    MBProgressHUD *tipHUD;
  }
@property (nonatomic,retain) UITableView *tableV;
@property (nonatomic,retain) UITextField *textField;
@property (retain, nonatomic) IBOutlet UILabel *titileLabel;
@property (retain, nonatomic) IBOutlet UILabel *remberLabel;
@property (retain, nonatomic) IBOutlet UIButton *forgetLabel;
@property (retain, nonatomic) IBOutlet UIButton *resgiterBtn;
@property (retain, nonatomic) IBOutlet UIButton *loginBtn;
@property(nonatomic,retain)NSMutableArray *mAry;

- (IBAction)onAswerbtnAction:(id)sender;
@end

@implementation loginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:@"loginViewController" bundle:ZPLAY_BUNDLE];
    if (self) {
       
    }
    return self;
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [[Slqite shareInstance]createDBase];
    self.mAry=[NSMutableArray array];
    self.mAry=[[Slqite shareInstance]SelectSqlite];
    contentVF=_contenV.frame;
    _pwdText.text= [[NSUserDefaults standardUserDefaults]objectForKey:USER_LOGINPWD];
    if ([[NSUserDefaults standardUserDefaults]boolForKey:ISAUTOLOGIN])
    {
        if ([[NSUserDefaults standardUserDefaults]boolForKey:USER_ISREMBER]) {
            self.accText.text=[[NSUserDefaults standardUserDefaults] objectForKey:USER_LOGINNAME];
            self.pwdText.text=[[NSUserDefaults standardUserDefaults] objectForKey:USER_LOGINPWD];
            [self sahfkadsbfkanc];
        }
    }
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"erc"]==NO) {
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:USER_ISREMBER];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"erc"];
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:ISAUTOLOGIN];
    }
    _accText.text=[[NSUserDefaults standardUserDefaults]objectForKey:USER_LOGINNAME];
    if ([[NSUserDefaults standardUserDefaults]boolForKey:USER_ISREMBER]) {
        [_rememberBtn setImage:[UIImage imageNamed:@"26"] forState:UIControlStateNormal];
    }else
    {
        [_rememberBtn setImage:[UIImage imageNamed:@"27"] forState:UIControlStateNormal];
    }
    [time invalidate];
    time=nil;
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:ISLOGON];
  

    
    bRect=self.bView.frame;
    self.hidenBtn.hidden=YES;
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}
- (void)keyBoardWillShow:(NSNotification*)nofication
{
    self.hidenBtn.hidden=NO;
    self.hidenBtn.backgroundColor=[UIColor clearColor];
    NSDictionary *userInfo = nofication.userInfo;
    
    CGFloat timerInterval = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    UIViewAnimationOptions animationOptions = [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    

    [UIView animateWithDuration:timerInterval
                          delay: 0.0
                        options: animationOptions
                     animations:^{
                         self.bView.frame = (CGRect){bRect.origin.x,bRect.origin.y-50,bRect.size};
                     }
                     completion:nil];
}
- (void)keyBoardWillHide:(NSNotification*)nofication
{
    self.hidenBtn.hidden=YES;
    
    //处理键盘上的tabbar
    NSDictionary *userInfo = nofication.userInfo;
    CGFloat timerInterval = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    UIViewAnimationOptions animationOptions = [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    [UIView animateWithDuration:timerInterval
                          delay: 0.0
                        options: animationOptions
                     animations:^{
                         self.bView.frame=bRect;
                     }
                     completion:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
    rem=[[NSUserDefaults standardUserDefaults]boolForKey:USER_ISREMBER];

    
    if ([[NSUserDefaults standardUserDefaults]boolForKey:USER_ISREMBER]) {
       self.accText.text=[[NSUserDefaults standardUserDefaults] objectForKey:USER_LOGINNAME];
        self.pwdText.text=[[NSUserDefaults standardUserDefaults] objectForKey:USER_LOGINPWD];
    }else{
        
    }
   

    
    _pwdText.secureTextEntry=YES;
    showList = NO; //默认不显示下拉框
    self.tableV = [[UITableView alloc] initWithFrame:CGRectMake(42, 83, CGRectGetWidth(_contenV.frame)-2, 0) style:UITableViewStylePlain];
    self.tableV.delegate = self;
    self.tableV.dataSource = self;
    self.tableV.hidden = YES;
    [_bView addSubview:self.tableV];
    
    
    self.contenV.layer.cornerRadius=5.0f;
    self.contenV.layer.borderWidth=1.0f;
    
    self.contenV.layer.borderColor=[[UIColor lightGrayColor] CGColor];
//    activityV=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
//    [activityV setCenter:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2)];
//    activityV.activityIndicatorViewStyle=UIActivityIndicatorViewStyleWhiteLarge;
//    activityV.autoresizingMask=UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
//    activityV.color=[UIColor blackColor];
//    [self.view addSubview:activityV];
    tipHUD = [[[MBProgressHUD alloc] initWithView:self.view] autorelease];
    [self.view addSubview:tipHUD];
    tipHUD.delegate = self;
    tipHUD.labelText= @"掌游正在为您加载中...";
    
    
    self.view.layer.cornerRadius=5.0f;
    self.bView.layer.cornerRadius=5.0f;
    [self.bView.layer setMasksToBounds:YES];
    
    

}
-(void)sahfkadsbfkanc
{
    if (_accText.text.length !=0 || _pwdText.text.length !=0)
    {
//        [activityV startAnimating];
        [tipHUD setHidden:YES];
        NSLog(@"%@",_pwdText.text);
        [[Zplay shareInstance]loginToseeverUserId:_accText.text userPwd:_pwdText.text Delegate:self];
    }
}
-(void)dropdown
{
    if (showList) {//如果下拉框已显示，什么都不做
        showList = NO;
        self.tableV.hidden = YES;
        [UIView beginAnimations:@"ResizeFor" context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveLinear];
        _contenV.frame = contentVF;
        self.tableV.backgroundColor=[UIColor lightGrayColor];
        [UIView commitAnimations];

        return;
    }else {
        
        int c=self.mAry.count;
        
        if (c>3) {
            c=3;
        }
            //如果下拉框尚未显示，则进行显示
            self.tableV.hidden = NO;
            showList = YES;//显示下拉框
            
            CGRect frame = self.tableV.frame;
            frame.size.height = 0;
            self.tableV.frame = frame;
            frame.size.height = c*30;
            
            [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
            [UIView setAnimationCurve:UIViewAnimationCurveLinear];
            self.tableV.frame = frame;
        _contenV.frame=CGRectMake(41, 45, CGRectGetWidth(_contenV.frame), 72+c*30);
            self.tableV.backgroundColor=[UIColor lightGrayColor];
            [UIView commitAnimations];
        
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return self.mAry.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.backgroundColor=[UIColor lightGrayColor];


    }
    
    
        NSDictionary *GY=[self.mAry objectAtIndex:indexPath.row];
        cell.textLabel.text=[GY objectForKey:@"UserName"];
        cell.textLabel.font=[UIFont systemFontOfSize:14.0f];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        NSString *useN=[[self.mAry objectAtIndex:indexPath.row] objectForKey:@"UserID"];
        [[Slqite shareInstance]deleteDbaseUserNmae:useN];
        [self.mAry removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];

       
        if (self.mAry.count==1) {
            [self showListaction:nil];
        }
    }
   
}

// Override to support conditional editing of the table view.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [UIView beginAnimations:@"ResizeFor" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    _contenV.frame = contentVF;
    self.tableV.backgroundColor=[UIColor lightGrayColor];
    [UIView commitAnimations];
    
    self.accText.text=[[self.mAry objectAtIndex:indexPath.row] objectForKey:SQLITE_USERNAME];
    self.pwdText.text=[[self.mAry objectAtIndex:indexPath.row] objectForKey:SQLITE_PASSWORD];
    if (rem==NO) {
        if (indexPath.row==0) {
            self.pwdText.text=nil;
        }
        
    }
    
    showList = NO;
    self.tableV.hidden = YES;
    
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

- (void)dealloc {
    [_bView release];
    [_accText release];
    [_pwdText release];
   
    [_rememberBtn release];
    [_hidenBtn release];
    [_showListBtn release];
    [_contenV release];
    [_titileLabel release];
    [_remberLabel release];
    [_forgetLabel release];
    [_resgiterBtn release];
    [_loginBtn release];
    [_aswerBtn release];
    [super dealloc];
}
- (IBAction)showListaction:(id)sender {
    [self dropdown];
}

- (IBAction)rememberPwd:(id)sender {
    isremmber=[[NSUserDefaults standardUserDefaults]boolForKey:USER_ISREMBER];
    if (isremmber) {
        [_rememberBtn setImage:[UIImage imageNamed:@"27"] forState:UIControlStateNormal];
        isremmber=NO;
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:USER_ISREMBER];
    }else
    {
        [_rememberBtn setImage:[UIImage imageNamed:@"26"] forState:UIControlStateNormal];
        isremmber=YES;
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:USER_ISREMBER];
    }

}

- (IBAction)onForgetPwdAction:(id)sender {
    ForgetPWDVCtl *forgetVctrl=[[ForgetPWDVCtl alloc]init];
    forgetVctrl.userIdStr=_accText.text;
    [self.navigationController pushViewController:forgetVctrl animated:YES];
    [forgetVctrl release];
    forgetVctrl=Nil;
}

- (IBAction)onQuickRegisterAction:(id)sender {
    
    [tipHUD setHidden:YES];
    RegisterViewController *registerVctrl=[[RegisterViewController alloc]init];
    [self.navigationController pushViewController:registerVctrl animated:NO];
    
}


- (IBAction)onLoginAction:(id)sender {
   
    if (_accText.text==nil || _pwdText.text==nil) {
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                             message:@"账号密码不为空"
                                                            delegate:nil
                                                   cancelButtonTitle:@"确定"
                                                   otherButtonTitles:nil];
        
        [alertView show];
        [alertView release];
    }else if (_pwdText.text.length>20 || _pwdText.text.length<6)
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
        tipHUD = [[[MBProgressHUD alloc] initWithView:self.view] autorelease];
        [self.view addSubview:tipHUD];
        tipHUD.delegate = self;
        tipHUD.labelText= @"掌游正在为您加载中...";
        [tipHUD show:YES];

        [[Zplay shareInstance]loginToseeverUserId:_accText.text userPwd: _pwdText.text Delegate:self];
        
//        [activityV startAnimating];
        self.view.userInteractionEnabled=NO;
    }

    
}
- (void)request:(ZplayRequest *)request didFailWithError:(NSError *)error
{
//    [activityV stopAnimating];
    [tipHUD setHidden:YES];
    NSLog(@"%@",[error localizedDescription]);
    self.view.userInteractionEnabled=YES;
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                         message:@"网络数据异常，请稍后再尝试操作"
                                                        delegate:nil
                                               cancelButtonTitle:@"确定"
                                               otherButtonTitles:nil];
    
    [alertView show];
    [alertView release];
    
}
- (NSString*)URLDecodedStringstr:(NSString *)s
{
    NSString*result = (NSString*)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,
                                                                                         (CFStringRef)s,
                                                                                         CFSTR(""),
                                                                                         kCFStringEncodingUTF8);
    [result autorelease];
    return result;
}
- (void)request:(ZplayRequest *)request didFinishLoadingWithResult:(id)result
{
    self.view.userInteractionEnabled=YES;
    NSString *str3=[[result objectForKey:@"msg"] objectForKey:@"text"];
    NSString *result10 = (NSString*)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,
                                                                                         (CFStringRef)str3,
                                                                                         CFSTR(""),
                                                                                         kCFStringEncodingUTF8);
    NSLog(@"%@-------%@",result10,result);
    
//        NSDictionary * infoDict = [[NSDictionary alloc]initWithObjectsAndKeys:uid,@"userid",name,@"username",code,@"code",text,@"text", nil];
    
    
    if ([[[request.params objectForKey:@"data"] objectForKey:@"action"]isEqualToString:@"login"]) {

        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:ISSHOWUPPY];
        if ([[[result objectForKey:@"msg"] objectForKey:@"text"] caseInsensitiveCompare:@"OK"]==NSOrderedSame)
        {
            
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
//            _loginMemberInfo = [[SUser alloc]initWithDict:mDic];
            if ([[ZplaySendNotify sharedInstance].myDelegate respondsToSelector:@selector(addObserver:result:)]) {
                [[ZplaySendNotify sharedInstance].myDelegate addObserver:mDic result:ZplayLoginResult];
                NSLog(@"888888888888888888888%@",_loginMemberInfo);
            }
            
            [[NSUserDefaults standardUserDefaults]setObject:self.accText.text forKey:USER_AUTOLOGINACC];
            [[NSUserDefaults standardUserDefaults]setObject:self.pwdText.text forKey:USER_AUTOLOGINPWD];
            [[NSUserDefaults standardUserDefaults]setObject:[[result objectForKey:@"data"] objectForKey:@"username"] forKey:USER_LOGINNAME];
            [[NSUserDefaults standardUserDefaults]setObject:[[result objectForKey:@"data"] objectForKey:@"userid"] forKey:USER_LOGINACC];
            [[NSUserDefaults standardUserDefaults]setObject:self.pwdText.text forKey:USER_LOGINPWD];
            [[Zplay shareInstance]enterGamePostServerruserId:[[result objectForKey:@"data"] objectForKey:@"userid"] userPwd:self.pwdText.text  Delegate:self];
            
          
            
            [[NSUserDefaults standardUserDefaults]setBool:YES forKey:ISLOGON];
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
            [[Slqite shareInstance]insertDbaseUserId:[[result objectForKey:@"data"] objectForKey:@"userid"] UserName:[[result objectForKey:@"data"] objectForKey:@"username"] Password:_pwdText.text];
            

            NSString *userNstr=[[result objectForKey:@"data"] objectForKey:@"username"];
            if (userNstr.length !=0) {
                [self performSelector:@selector(dsfjaklsdf) withObject:nil afterDelay:0.5f];
                }else{
                    [tipHUD setHidden:YES];
//                [activityV stopAnimating];
                    
                OlderViewController *olderVcytl=[[OlderViewController alloc]init];

                olderVcytl.userstr=[[result objectForKey:@"data"] objectForKey:@"userid"];
                    if (olderVcytl.userstr.length !=0) {
                        [self.navigationController pushViewController:olderVcytl animated:YES];
                    }else{
                        NSLog(@"userid  no fount");
                    }
                
                [olderVcytl release];
                olderVcytl=Nil;
            
                }
           
            
            timer=[NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
            
        }else{
//            [activityV stopAnimating];
            [tipHUD setHidden:YES];
			UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示"
																 message:result10
																delegate:nil
													   cancelButtonTitle:@"确定"
													   otherButtonTitles:nil];
			[alertView show];
			[alertView release];
            
        }
    }else if ([[[request.params objectForKey:@"data"] objectForKey:@"action"]isEqualToString:@"changeName"])
    {
        if ([[[result objectForKey:@"msg"] objectForKey:@"text"] caseInsensitiveCompare:@"OK"]==NSOrderedSame)
        {
            [[NSUserDefaults standardUserDefaults]setObject:[[result objectForKey:@"data"]objectForKey:@"username"] forKey:USER_LOGINNAME];
            [self dismissViewControllerAnimated:YES completion:Nil];
        }
    }
    
    
    [tipHUD setHidden:YES];
}
-(void)timerAction
{
    [[Zplay shareInstance]acquireGameEndtime];
}
-(void)dsfjaklsdf
{
//    [activityV stopAnimating];
    [tipHUD setHidden:YES];
    [self dismissViewControllerAnimated:YES completion:Nil];
}
- (IBAction)hidenKeyBoardAction:(id)sender {
    [self.accText resignFirstResponder];
    [self.pwdText resignFirstResponder];
}
- (IBAction)onAswerbtnAction:(id)sender {
    AsWerVCtl *aswerVctrl=[[AsWerVCtl alloc]init];
    [self.navigationController pushViewController:aswerVctrl animated:YES];
    [aswerVctrl release];
    aswerVctrl=Nil;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:Nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:Nil];
}



@end
