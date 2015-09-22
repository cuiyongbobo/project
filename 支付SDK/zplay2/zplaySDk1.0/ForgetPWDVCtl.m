//
//  ForgetPWDVCtl.m
//  zplaySDk1.0
//
//  Created by ZPLAY005 on 14-4-3.
//  Copyright (c) 2014年 ZPLAY005. All rights reserved.
//

#import "ForgetPWDVCtl.h"
#import "Zplay.h"
#import "ReplacePwdVCtl.h"
#import "loginViewController.h"
#import "DefineObjcs.h"

@interface ForgetPWDVCtl ()<UITableViewDelegate,UITableViewDataSource,ZplayRequestDelegate>
{
    NSTimer *timer;
    int countTimer;
    NSMutableArray *mAry;
    CGRect jRect;
    BOOL isremmber;
    UITableView *tv;//下拉列表
    NSArray *tableArray;//下拉列表数据
    BOOL showList;//是否弹出下拉列表
    CGFloat tabheight;//table下拉列表的高度
    CGFloat frameHeight;//frame的高度
    int i;
    int numberCode;
    NSString *restr;
    NSTimer *timer3;
    MBProgressHUD * tipHUD;
}
@property (nonatomic,retain) UITableView *tv;
@property (nonatomic,retain) NSArray *tableArray;
@property (nonatomic,retain) UITextField *textField;
//@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *activityV;
@property (retain, nonatomic) IBOutlet UITextField *aquiceT;
@property (retain, nonatomic) IBOutlet UILabel *timeLabel;
@property (retain, nonatomic) IBOutlet UIButton *aquiceBtn;
@property (retain, nonatomic) IBOutlet UITextField *codeT;

@property (retain, nonatomic) IBOutlet UILabel *titleLabel;
@property (retain, nonatomic) IBOutlet UITextField *selectQuestionT;
@property(nonatomic,retain)NSString *strStryl;
@property(nonatomic,retain)NSString *codeString;
@property (retain, nonatomic) IBOutlet UILabel *textLabelTop;
@property (retain, nonatomic) IBOutlet UIButton *listBtn;

@end

@implementation ForgetPWDVCtl
@synthesize tv,tableArray,textField;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:@"ForgetPWDVCtl" bundle:ZPLAY_BUNDLE];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:YES];
    
    jRect=self.view.frame;
    
    self.hidenBtn.hidden=YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}
- (void)keyBoardWillShow:(NSNotification*)nofication
{
    [self.ziplocText setUserInteractionEnabled:NO];
    self.hidenBtn.hidden=NO;
    self.hidenBtn.backgroundColor=[UIColor clearColor];
    NSDictionary *userInfo = nofication.userInfo;
    
    CGFloat timerInterval = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    UIViewAnimationOptions animationOptions = [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    int hi;
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad) {
        hi=160;
    }else{
        hi=60;
    }
    CGRect kbTopBarViewShowFrame = (CGRect){jRect.origin.x,jRect.origin.y-hi,jRect.size.width,jRect.size.height};
    [UIView animateWithDuration:timerInterval
                          delay: 0.0
                        options: animationOptions
                     animations:^{
                         self.view.frame = kbTopBarViewShowFrame;
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
                         self.view.frame=jRect;
                     }
                     completion:nil];
}
- (IBAction)backGameAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:Nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    timer3=[NSTimer scheduledTimerWithTimeInterval:600 target:self selector:@selector(newCode) userInfo:nil repeats:NO];
    showList = NO; //默认不显示下拉框
    _aquiceT.layer.borderColor=[[UIColor lightGrayColor]CGColor];
    _aquiceT.layer.borderWidth=1.0f;
    _aquiceT.layer.cornerRadius=2.0f;
    _codeT.layer.borderColor=[[UIColor lightGrayColor]CGColor];
    _codeT.layer.borderWidth=1.0f;
    _codeT.layer.cornerRadius=2.0f;
    
    _selectQuestionT.layer.borderColor=[[UIColor lightGrayColor]CGColor];
    _selectQuestionT.layer.borderWidth=1.0f;
    _selectQuestionT.layer.cornerRadius=2.0f;
    _ziplocText.layer.borderColor=[[UIColor lightGrayColor]CGColor];
    _ziplocText.layer.borderWidth=1.0f;
    _ziplocText.layer.cornerRadius=2.0f;
    _aswerText.layer.borderColor=[[UIColor lightGrayColor]CGColor];
    _aswerText.layer.borderWidth=1.0f;
    _aswerText.layer.cornerRadius=2.0f;
    _accTextf.layer.borderColor=[[UIColor lightGrayColor]CGColor];
    _accTextf.layer.borderWidth=1.0f;
    _accTextf.layer.cornerRadius=2.0f;
    
    
    tv = [[UITableView alloc] initWithFrame:CGRectMake(CGRectGetMinX(_selectQuestionT.frame), CGRectGetMaxY(_selectQuestionT.frame), CGRectGetWidth(_selectQuestionT.frame), 0)];
    tv.autoresizingMask=UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    tv.delegate = self;
    tv.dataSource = self;
    tv.backgroundColor=[UIColor lightGrayColor];
    isremmber=YES;
    tv.hidden = YES;
    [self.view addSubview:tv];
//    [_activityV setHidden:YES];
    tipHUD = [[[MBProgressHUD alloc] initWithView:self.view] autorelease];
    [self.view addSubview:tipHUD];
    tipHUD.delegate = self;
    tipHUD.labelText= @"掌游正在为您加载中...";

    
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad) {
        _titleLabel.font=[UIFont systemFontOfSize:25.0f];
        _accTextf.font=[UIFont systemFontOfSize:25.0];
        _ziplocText.font=[UIFont systemFontOfSize:25.0];
        _aswerText.font=[UIFont systemFontOfSize:25.0f];
        _timeLabel.font=[UIFont systemFontOfSize:25.0f];
        _aquiceBtn.titleLabel.font=[UIFont systemFontOfSize:25.0f];
        _textLabelTop.font=[UIFont systemFontOfSize:25.0f];
        _selectQuestionT.font=[UIFont systemFontOfSize:25.0f];
        _codeT.font=[UIFont systemFontOfSize:25.0f];
        _aquiceT.font=[UIFont systemFontOfSize:25.0f];
        _commitBtn.titleLabel.font=[UIFont systemFontOfSize:25.0f];
    }
    
    _accTextf.text=_userIdStr;
    
    numberCode=1;
    _strStryl=@"手机";
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backFView:(id)sender {
    loginViewController *loginVctrl=[[loginViewController alloc]init];
    [self.navigationController pushViewController:loginVctrl animated:YES];
    [loginVctrl release];
    loginVctrl=nil;
}

- (IBAction)showTable:(id)sender {
    [self showTableView:sender];
}

- (IBAction)showTableOfAnswerQuestion:(id)sender {
    [self showTableView:sender];
}

- (IBAction)commitToSeverAction:(id)sender {
    NSString *corStr=[[NSUserDefaults standardUserDefaults]objectForKey:@"codeYZ"];
    
    NSString *string2 = [corStr substringWithRange:NSMakeRange(17, 4)];
    if ([_strStryl isEqualToString:@"密保"]) {
        if (_accTextf.text.length==0 || _ziplocText.text.length==0 || _aswerText.text.length==0) {
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                 message:@"账号 密保不为空 如无密保问题请联系客服进行修改"
                                                                delegate:nil
                                                       cancelButtonTitle:@"确定"
                                                       otherButtonTitles:nil];
            
            [alertView show];
            [alertView release];
            
            
        }else
        {
//            [_activityV setHidden:NO];
//            [_activityV startAnimating];
            [tipHUD show:YES];
            [[Zplay shareInstance]getPwdFromServerUserId:self.accTextf.text userQ:_ziplocText.text userA:_aswerText.text Delegate:self];
            
        }
        return;
    }
    if ([_strStryl isEqualToString:@"手机"]) {
        if (_accTextf.text.length==0 ||_aquiceT.text.length==0 || _codeT.text.length==0) {
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                 message:@"账号或手机，验证码不为空 如无密保问题请联系客服进行修改"
                                                                delegate:nil
                                                       cancelButtonTitle:@"确定"
                                                       otherButtonTitles:nil];
            
            [alertView show];
            [alertView release];
        }else{
            
            if ([_codeT.text caseInsensitiveCompare:string2]==NSOrderedSame) {
                ReplacePwdVCtl *replacevctrl=[[ReplacePwdVCtl alloc]init];
                replacevctrl.useridStr=_accTextf.text;
                
                [self.navigationController pushViewController:replacevctrl animated:YES];
                [replacevctrl release];
            }else{
                UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                     message:@"验证码不匹配，请重新输入"
                                                                    delegate:nil
                                                           cancelButtonTitle:@"确定"
                                                           otherButtonTitles:nil];
                
                [alertView show];
                [alertView release];
            }
            
            
        }
        return;
    }
    if ([_strStryl isEqualToString:@"邮箱"]) {
        if (_accTextf.text.length==0 ||_aquiceT.text.length==0 || _codeT.text.length==0) {
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                 message:@"账号或手机，验证码不为空 如无密保问题请联系客服进行修改"
                                                                delegate:nil
                                                       cancelButtonTitle:@"确定"
                                                       otherButtonTitles:nil];
            
            [alertView show];
            [alertView release];
        }else{
            
            if ([_codeT.text caseInsensitiveCompare:string2]==NSOrderedSame) {
                ReplacePwdVCtl *replacevctrl=[[ReplacePwdVCtl alloc]init];
                replacevctrl.useridStr=_accTextf.text;
                
                [self.navigationController pushViewController:replacevctrl animated:YES];
                [replacevctrl release];
            }else{
                UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                     message:@"验证码不匹配，请重新输入"
                                                                    delegate:nil
                                                           cancelButtonTitle:@"确定"
                                                           otherButtonTitles:nil];
                
                [alertView show];
                [alertView release];
            }
            
        }
        return;
    }
    
}
- (IBAction)aquiceCodeAction:(id)sender {
    
    BOOL codeyan;
    
    if ([_strStryl isEqualToString:@"邮箱"]) {
        restr=@"mail";
        codeyan=[self validateEmail:_aquiceT.text];
        
    }
    if ([_strStryl isEqualToString:@"手机"]) {
        codeyan=[self validateMobile:_aquiceT.text];
        restr=@"sms";
    }
    
    if ([_strStryl isEqualToString:@"密保"]) {
        restr=@"ga";
    }
    if (codeyan) {
        
        if (numberCode==1) {
            _codeString=[[Zplay shareInstance]aquiceCodeStringUserId:_accTextf.text keyStr:_aquiceT.text];
            [[NSUserDefaults standardUserDefaults]setObject:_codeString forKey:@"codeYZ"];
        }
        
        
        
        [[Zplay shareInstance]reportCodeToSeverUserId:_accTextf.text TypeStr:restr KeyStr:_aquiceT.text ValueStr:_codeString ifVefiy:@"1" Delegate:self];
        timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethodS) userInfo:nil repeats:YES];
        [_timeLabel setHidden:NO];
        [sender setUserInteractionEnabled:NO];
        countTimer = 179;
        [_listBtn setUserInteractionEnabled:NO];
        
        NSString *str3=[[NSUserDefaults standardUserDefaults]objectForKey:@"codeYZ"];
        NSString *string2 = [str3 substringWithRange:NSMakeRange(17, 4)];
        
        NSLog(@"%@",string2);
        
        
        NSString *str = [NSString stringWithFormat:@"%d秒後重新获取",countTimer];
        _timeLabel.text = str;
        [_aquiceT setUserInteractionEnabled:NO];
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
    if (_aquiceT.text.length!=0) {
        _codeString=[[Zplay shareInstance]aquiceCodeStringUserId:_accTextf.text keyStr:_aquiceT.text];
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
        [_aquiceT setUserInteractionEnabled:YES];
        [_listBtn setUserInteractionEnabled:YES];
        [_aquiceBtn setTitleColor:normal forState:UIControlStateNormal];
        [timer invalidate];
        [_aquiceBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        
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

- (void)dealloc {
    
    [_accTextf release];
    [_ziplocText release];
    [_aswerText release];
    [_showListBtn release];
    [_hidenBtn release];
    //    [_bView release];
//    [_activityV release];
    
    [_commitBtn release];
    [_titleLabel release];
    [_selectQuestionT release];
    [_aquiceBtn release];
    [_timeLabel release];
    [_aquiceT release];
    [_codeT release];
    [_textLabelTop release];
    [_listBtn release];
    [_showTableBtn release];
    [super dealloc];
}
- (IBAction)showListAction:(UIButton *)sender {
    [self showTableView:sender];
    
}
- (void)showTableView:(UIButton *)sender{
    if (showList) {//如果下拉框已显示，什么都不做
        showList = NO;
        tv.hidden = YES;
        
    }else {
        //如果下拉框尚未显示，则进行显示
        tv.hidden = NO;
        showList = YES;//显示下拉框
        CGRect frame;
        if ((sender.tag==801)||(sender.tag == 802)) {
            self.tableArray=@[@"密保手机找回",@"密保邮箱找回",@"密保问题找回"];
            frame=CGRectMake(CGRectGetMinX(_selectQuestionT.frame), CGRectGetMaxY(_selectQuestionT.frame), CGRectGetWidth(_selectQuestionT.frame), 0);
            [self.tv reloadData];
            i=1;
            tv.frame = frame;
            frame.size.height = _selectQuestionT.frame.size.height*self.tableArray.count;
            
        }else{
            self.tableArray=@[@"您母亲的生日是？",@"您的学号(或工号)是？",@"您小学班主任是谁？",@"您最熟悉的好有生日是?",@"您最崇拜的偶像名字是?",@"您印象最深的一组数字是?"];
            self.tv.frame=CGRectMake(CGRectGetMinX(_ziplocText.frame), CGRectGetMaxY(_ziplocText.frame), CGRectGetWidth(_ziplocText.frame), 0);
            [self.tv reloadData];
            i=2;
            frame = tv.frame;
            tv.frame = frame;
            frame.size.height = _selectQuestionT.frame.size.height*3;
        }
        
        [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveLinear];
        tv.frame = frame;
        tv.backgroundColor=[UIColor lightGrayColor];
        [UIView commitAnimations];
        
    }
}

- (IBAction)hidenKeyBoardAction:(id)sender {
    [[[UIApplication sharedApplication]keyWindow]endEditing:NO];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tableArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.backgroundColor=[UIColor lightGrayColor];
    }
    if (iPhone) {
        cell.textLabel.font = [UIFont systemFontOfSize:16.0f];
    }
    if (iPad) {
        cell.textLabel.font = [UIFont systemFontOfSize:23.0f];

    }
    
    cell.textLabel.text = [tableArray objectAtIndex:[indexPath row]];
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return _selectQuestionT.frame.size.height;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (i==1) {
        _selectQuestionT.text=[tableArray objectAtIndex:[indexPath row]];
        if ([indexPath row]==2) {
            [_codeT setHidden:YES];
            [_aquiceT setHidden:YES];
            [_timeLabel setHidden:YES];
            [_aquiceBtn setHidden:YES];
            _strStryl=@"密保";
            [_commitBtn setUserInteractionEnabled:YES];
            [_aswerText setHidden:NO];
            [_ziplocText setHidden:NO];
            [_showListBtn setHidden:NO];
            [_showTableBtn setHidden:NO];
        }else if ([indexPath row]==1){
            [_codeT setHidden:NO];
            [_aquiceT setHidden:NO];
            [_timeLabel setHidden:NO];
            [_aquiceBtn setHidden:NO];
            _aquiceT.placeholder=@"请输入邮箱地址";
            _strStryl=@"邮箱";
            [_showTableBtn setHidden:YES];
            [_aswerText setHidden:YES];
            [_ziplocText setHidden:YES];
            [_showListBtn setHidden:YES];
        }else{
            [_codeT setHidden:NO];
            [_aquiceT setHidden:NO];
            [_timeLabel setHidden:NO];
            [_aquiceBtn setHidden:NO];
            _aquiceT.placeholder=@"请输入手机号码";
            _strStryl=@"手机";
            [_showTableBtn setHidden:YES];
            [_aswerText setHidden:YES];
            [_ziplocText setHidden:YES];
            
            [_showListBtn setHidden:YES];
        }
        
        
        
        
        
    }else{
        _ziplocText.text = [tableArray objectAtIndex:[indexPath row]];
    }
    showList = NO;
    tv.hidden = YES;
    
}
- (void)request:(ZplayRequest *)request didReceiveResponse:(NSURLResponse *)response
{
    
}
- (void)request:(ZplayRequest *)request didReceiveRawData:(NSData *)data
{
    
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
    NSLog(@"%@",[error localizedDescription]);
//    [_activityV setHidden:YES];
//    [_activityV stopAnimating];
    [tipHUD setHidden:YES];
    countTimer=1;
}
- (void)request:(ZplayRequest *)request didFinishLoadingWithResult:(id)result
{
//    [_activityV setHidden:YES];
//    [_activityV stopAnimating];
    NSString *str3=[[result objectForKey:@"msg"] objectForKey:@"text"];
    
    NSString *result10 = (NSString*)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,
                                                                                            (CFStringRef)str3,
                                                                                            CFSTR(""),
                                                                                            kCFStringEncodingUTF8);
    NSString *str=[[result objectForKey:@"msg"] objectForKey:@"text"];
    if ([[[request.params objectForKey:@"data"] objectForKey:@"action"]isEqualToString:@"reportCode"]) {
        if ([str isEqualToString:@"OK"]) {
            [_aquiceBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                 message:@"已发送，请注意接收"
                                                                delegate:nil
                                                       cancelButtonTitle:@"确定"
                                                       otherButtonTitles:nil];
            [alertView show];
            [alertView release];
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
        
    }else{
        if ([str isEqualToString:@"OK"]) {
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                 message:@"提交成功"
                                                                delegate:nil
                                                       cancelButtonTitle:@"确定"
                                                       otherButtonTitles:nil];
            [alertView show];
            [alertView release];
            ReplacePwdVCtl *replacevctrl=[[ReplacePwdVCtl alloc]init];
            replacevctrl.useridStr=_accTextf.text;
            
            [self.navigationController pushViewController:replacevctrl animated:YES];
            [replacevctrl release];
        }else
        { UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                               message:result10
                                                              delegate:nil
                                                     cancelButtonTitle:@"确定"
                                                     otherButtonTitles:nil];
            [alertView show];
            [alertView release];
            
        }
    }
    NSLog(@"上传参数%@，返回参数%@",request.params,result);
    [tipHUD setHidden:YES];
}


-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    self.view.frame=jRect;
    [timer3 invalidate];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"codeYZ"];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}
- (void)viewDidUnload {
    [self setTitleLabel:nil];
    
    [self setSelectQuestionT:nil];
    [self setAquiceBtn:nil];
    [self setTimeLabel:nil];
    [self setAquiceT:nil];
    [self setCodeT:nil];
    [self setTextLabelTop:nil];
    [self setListBtn:nil];
    [self setShowTableBtn:nil];
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
