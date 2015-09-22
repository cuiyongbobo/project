//
//  secureViewController.m
//  zplaySDk1.0
//
//  Created by ZPLAY005 on 14-2-11.
//  Copyright (c) 2014年 ZPLAY005. All rights reserved.
//

#import "secureViewController.h"
#import "Zplay.h"
#import "DefineObjcs.h"

@interface secureViewController ()<ZplayRequestDelegate,UITableViewDataSource,UITableViewDelegate>
{
    CGRect vRect;
    NSMutableArray *mAry;
    BOOL isremmber;
    UITableView *tv;//下拉列表
    NSArray *tableArray;//下拉列表数据
    BOOL showList;//是否弹出下拉列表
    CGFloat tabheight;//table下拉列表的高度
    CGFloat frameHeight;//frame的高度
}
@property (nonatomic,retain) UITableView *tv;
@property (nonatomic,retain) NSArray *tableArray;
@property (nonatomic,retain) UITextField *textField;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *activityV;
@property (retain, nonatomic) IBOutlet UILabel *titleLabel;
@property (retain, nonatomic) IBOutlet UILabel *nameLabel;
@property (retain, nonatomic) IBOutlet UIButton *commBtn;
@property (retain, nonatomic) IBOutlet UILabel *textLabel;
@property (retain, nonatomic) IBOutlet UILabel *nameText;
@property (retain, nonatomic) IBOutlet UILabel *userTextLabel;
@property (retain, nonatomic) IBOutlet UIView *bigView;
@property (retain, nonatomic) IBOutlet UILabel *textLables;


@end

@implementation secureViewController
@synthesize tv,tableArray,textField;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:@"secureViewController" bundle:ZPLAY_BUNDLE];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    vRect=self.view.frame;
   
    NSString *userga=[NSString stringWithFormat:@"%@ga",_useridStr];
    
    if ([[NSUserDefaults standardUserDefaults]boolForKey:userga]) {
        _aserLabel.text=@"已绑定";
        
    }else
    {
        _aserLabel.text=@"未绑定";
    }
    [self.hidenBtn setHidden:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}
- (void)keyBoardWillShow:(NSNotification*)nofication
{
    [self.ziplocText setUserInteractionEnabled:NO];
    [self.hidenBtn setHidden:NO];
    self.hidenBtn.backgroundColor=[UIColor clearColor];
    NSDictionary *userInfo = nofication.userInfo;
    CGRect keyboardFrame = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSLog(@"%f",keyboardFrame.size.width);
    CGFloat timerInterval = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    UIViewAnimationOptions animationOptions = [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    
   
    [UIView animateWithDuration:timerInterval
                          delay: 0.0
                        options: animationOptions
                     animations:^{
                         int i=100;
                         if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
                         {
                             i=180;
                         }
                         self.view.frame = (CGRect){vRect.origin.x,vRect.origin.y-i,vRect.size};
                     }
                     completion:nil];
}
- (void)keyBoardWillHide:(NSNotification*)nofication
{
    [self.hidenBtn setHidden:YES];
    
    //处理键盘上的tabbar
    NSDictionary *userInfo = nofication.userInfo;
    CGFloat timerInterval = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    UIViewAnimationOptions animationOptions = [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    [UIView animateWithDuration:timerInterval
                          delay: 0.0
                        options: animationOptions
                     animations:^{
                            self.view.frame=vRect;
                     }
                     completion:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.userIdLable.text=self.useridStr;
     [self.activityV setHidden:YES];
    self.bgView.layer.borderColor=[[UIColor lightGrayColor]CGColor];
    self.bgView.layer.borderWidth=1.0f;
    self.bgView.layer.cornerRadius=5.0f;
    showList = NO; //默认不显示下拉框
    tv = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_ziplocText.frame)+5, CGRectGetWidth(_bgView.frame)-1, 0)];
    tv.autoresizingMask=UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    tv.delegate = self;
    tv.dataSource = self;
    isremmber=YES;
    tv.hidden = YES;
    tv.backgroundColor=[UIColor lightGrayColor];
    [self.bgView addSubview:tv];
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
    {
        _titleLabel.font=[UIFont systemFontOfSize:30.0f];
        _commBtn.titleLabel.font=[UIFont systemFontOfSize:25.0f];
        _textLabel.font=[UIFont systemFontOfSize:25.0f];
        _nameText.font=[UIFont systemFontOfSize:25.0f];
        _userTextLabel.font=[UIFont systemFontOfSize:25.0f];
        _aserLabel.font=[UIFont systemFontOfSize:25.0f];
        _textLables.font=[UIFont systemFontOfSize:25.0f];
        _ziplocText.font=[UIFont systemFontOfSize:25.0f];
        _aswerText.font=[UIFont systemFontOfSize:25.0f];
        _userIdText.font=[UIFont systemFontOfSize:25.0f];
        _commBtn.titleLabel.font=[UIFont systemFontOfSize:25.0f];
    }
    self.bgView.layer.cornerRadius=5.0f;
    self.bgView.layer.borderColor=[[UIColor lightGrayColor]CGColor];
    self.bgView.layer.borderWidth=1.0f;
    self.userIdText.secureTextEntry=YES;
    self.bigView.layer.cornerRadius=5.0f;
    self.bigView.layer.borderColor=[[UIColor redColor]CGColor];
    self.bigView.layer.borderWidth=1.0f;
    [self.bigView.layer setMasksToBounds:YES];
    self.tableArray=@[@"您母亲的生日是？",@"您的学号(或工号)是？",@"您小学班主任是谁？",@"您最熟悉的好友生日是?",@"您最崇拜的偶像名字是?",@"您印象最深的一组数字是?"];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)enterGameAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)backUserVctrlAction:(id)sender {
   [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
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
    cell.textLabel.font = [UIFont systemFontOfSize:16.0f];
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
    _ziplocText.text = [tableArray objectAtIndex:[indexPath row]];
    showList = NO;
    tv.hidden = YES;
    
}

- (void)dealloc {
    [_userIdLable release];
    [_aswerText release];
    [_ziplocText release];
    [_userIdText release];
    [_hidenBtn release];
    [_bgView release];
    [_activityV release];
    [_titleLabel release];
    [_nameLabel release];
    [_commBtn release];
    [_textLabel release];
    [_nameText release];
    [_userTextLabel release];
    [_bigView release];
    [_aserLabel release];
    [_textLables release];
    [super dealloc];
}
- (IBAction)commitAction:(id)sender {
    
    if (_ziplocText.text==nil || _userIdText.text==nil || _aswerText.text==nil) {
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                             message:@"密码 密保不为空 如有问题请联系客服"
                                                            delegate:nil
                                                   cancelButtonTitle:@"确定"
                                                   otherButtonTitles:nil];
        
        [alertView show];
        [alertView release];
        
    }else
    {
        [self.activityV setHidden:NO];
        [self.activityV startAnimating];
        [self.view setUserInteractionEnabled:NO];
        [[Zplay shareInstance]senderToSeveruserId:self.useridStr Zptext:self.ziplocText.text aswerText:self.aswerText.text pwdtext:_userIdText.text Delegate:self];
    }

    
}
- (IBAction)showListaction:(id)sender {
    
    if (showList) {//如果下拉框已显示，什么都不做
        showList = NO;
        tv.hidden = YES;
        return;
    }else {//如果下拉框尚未显示，则进行显示
        
        
        
        tv.hidden = NO;
        showList = YES;//显示下拉框
        
        CGRect frame = tv.frame;
        frame.size.height = 0;
        tv.frame = frame;
        if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
        {
         frame.size.height = 90;
        }else{
            frame.size.height = 60;
        }
       
        
        [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveLinear];
        tv.frame = frame;
        [UIView commitAnimations];
    }

}
- (IBAction)hidenKeyBoardAction:(id)sender {
    [[[UIApplication sharedApplication]keyWindow]endEditing:NO];
}
- (void)request:(ZplayRequest *)request didReceiveResponse:(NSURLResponse *)response
{
    
}
- (void)request:(ZplayRequest *)request didReceiveRawData:(NSData *)data{
    
}
- (void)request:(ZplayRequest *)request didFailWithError:(NSError *)error
{
    [self.activityV stopAnimating];
    [self.activityV setHidden:YES];
    [self.view setUserInteractionEnabled:YES];
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                         message:@"网络数据异常，请稍后再尝试操作"
                                                        delegate:nil
                                               cancelButtonTitle:@"确定"
                                               otherButtonTitles:nil];
    [alertView show];
    [alertView release];
    self.aswerText.text=nil;
    self.ziplocText.text=nil;
    self.userIdText.text=nil;
    NSLog(@"%@",[error localizedDescription]);
}
- (void)request:(ZplayRequest *)request didFinishLoadingWithResult:(id)result
{
    [self.activityV stopAnimating];
    [self.activityV setHidden:YES];
    [self.view setUserInteractionEnabled:YES];
    if ([[[request.params objectForKey:@"data"] objectForKey:@"action"]isEqualToString:@"setQA"]) {
        if ([[[result objectForKey:@"msg"] objectForKey:@"text"] caseInsensitiveCompare:@"OK"]==NSOrderedSame) {
            
            
            NSString *userga=[NSString stringWithFormat:@"%@ga",_useridStr];
            [[NSUserDefaults standardUserDefaults]setBool:YES forKey:userga];
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                 message:@"密保问题设置成功"
                                                                delegate:nil
                                                       cancelButtonTitle:@"确定"
                                                       otherButtonTitles:nil];
            [alertView show];
            [alertView release];
            self.aswerText.text=nil;
            self.ziplocText.text=nil;
            self.userIdText.text=nil;
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:[[request.params objectForKey:@"data"] objectForKey:@"userid"]];
            
            
        
        }else
        {
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                 message:@"密保问题设置失败"
                                                                delegate:nil
                                                       cancelButtonTitle:@"确定"
                                                       otherButtonTitles:nil];
            [alertView show];
            [alertView release];
            self.aswerText.text=nil;
            self.ziplocText.text=nil;
            self.userIdText.text=nil;
        }

    }else if ([[[request.params objectForKey:@"data"] objectForKey:@"action"]isEqualToString:@"checkQA"])
    {
        if ([[[result objectForKey:@"msg"] objectForKey:@"text"] caseInsensitiveCompare:@"OK"]==NSOrderedSame) {
        
            if ([[[result objectForKey:@"data"]objectForKey:@"checkQA"]isEqualToString:@"1"]) {
                _aserLabel.text=@"已设置";
                [[NSUserDefaults standardUserDefaults]setBool:YES forKey:[[request.params objectForKey:@"data"] objectForKey:@"userid"]];
                
            }else{
                _aserLabel.text=@"未设置";
            }
        
        }
    
    }
    
    NSLog(@"%@",result);
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [[[UIApplication sharedApplication]keyWindow]endEditing:NO];
    self.view.frame=vRect;
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}
- (void)viewDidUnload {
    [self setTitleLabel:nil];
    [self setNameLabel:nil];
    [self setCommBtn:nil];
    [self setTextLabel:nil];
    [self setNameText:nil];
    [self setUserTextLabel:nil];
    [self setBigView:nil];
    [self setAserLabel:nil];
    [self setTextLables:nil];
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
