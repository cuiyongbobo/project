//
//  pwdVctrl.m
//  zplaySDk1.0
//
//  Created by ZPLAY005 on 14-1-26.
//  Copyright (c) 2014年 ZPLAY005. All rights reserved.
//

#import "pwdVctrl.h"
#import "Zplay.h"
#import "DefineObjcs.h"
#import "Slqite.h"
@interface pwdVctrl ()<ZplayRequestDelegate>
{
    CGRect contentVRect;
}
@property (retain, nonatomic) IBOutlet UIView *jksView;
@property (retain, nonatomic) IBOutlet UILabel *titleLabel;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *activityV;
@end

@implementation pwdVctrl

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:@"pwdVctrl" bundle:ZPLAY_BUNDLE];
    if (self) {
       
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.backBtn.hidden=YES;
    contentVRect=self.jksView.frame;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
}
- (void)keyBoardWillShow:(NSNotification*)nofication
{
    [self.backBtn setHidden:NO];
    NSDictionary *userInfo = nofication.userInfo;
    CGFloat timerInterval = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    UIViewAnimationOptions animationOptions = [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    
    
    [UIView animateWithDuration:timerInterval
                          delay: 0.0
                        options: animationOptions
                     animations:^{
                         self.jksView.frame=(CGRect){contentVRect.origin.x,contentVRect.origin.y-70,contentVRect.size};
                     }
                     completion:nil];
}
- (void)keyBoardWillHide:(NSNotification*)nofication
{
    [self.backBtn setHidden:YES];
    self.backBtn.hidden=YES;
   
    NSDictionary *userInfo = nofication.userInfo;
    CGFloat timerInterval = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    UIViewAnimationOptions animationOptions = [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    [UIView animateWithDuration:timerInterval
                          delay: 0.0
                        options: animationOptions
                     animations:^{
                         self.jksView.frame=contentVRect;
                     }
                     completion:nil];
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.activityV setHidden:YES];
    [self.backBtn setHidden:YES];
    self.contentV.layer.cornerRadius=5.0;
    self.contentV.layer.borderColor=[[UIColor lightGrayColor]CGColor];
    self.contentV.layer.borderWidth=1.0f;
    self.bView.layer.borderColor=[[UIColor redColor]CGColor];
    self.bView.layer.borderWidth=1.0f;
    self.bView.layer.cornerRadius=5.0f;
    [self.bView.layer setMasksToBounds:YES];
    self.backBtn.hidden=NO;
    self.oPwdText.secureTextEntry=YES;
    self.nPwdText.secureTextEntry=YES;
    self.oPwdText.delegate = self;
    self.nPwdText.delegate = self;
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad) {
        _titleLabel.font=[UIFont systemFontOfSize:25.0f];
        self.nPwdText.font = [UIFont systemFontOfSize:23.0f];
        self.oPwdText.font = [UIFont systemFontOfSize:23.0f];
        self.msgLabel.font = [UIFont systemFontOfSize:23.0f];
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc {
    [_oPwdText release];
    [_nPwdText release];
    [_backGV release];
    [_contentV release];
    [_backBtn release];
    [_bView release];
    [_activityV release];
    [_jksView release];
    [_titleLabel release];
    [_msgLabel release];
    [super dealloc];
}
- (IBAction)onCommitBtnAction:(id)sender {
    if (self.oPwdText.text==nil || self.nPwdText.text==nil) {
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                             message:@"密码不为空"
                                                            delegate:nil
                                                   cancelButtonTitle:@"确定"
                                                   otherButtonTitles:nil];
        [alertView show];
        [alertView release];

    }else if (_oPwdText.text.length>20 || _oPwdText.text.length<6)
    {
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                             message:@"密码长度（6-20位）"
                                                            delegate:nil
                                                   cancelButtonTitle:@"确定"
                                                   otherButtonTitles:nil];
        [alertView show];
        [alertView release];
    }else if ([self.oPwdText.text isEqualToString:self.nPwdText.text])
    {
       
        [self.activityV setHidden:NO];
        [self.activityV startAnimating];
        [self.view setUserInteractionEnabled:NO];
        [[Zplay shareInstance]resetPwdFromServerUserId:self.acctr userPwd:self.nPwdText.text Delegate:self];
    }else
    {
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                             message:@"密码不一致"
                                                            delegate:nil
                                                   cancelButtonTitle:@"确定"
                                                   otherButtonTitles:nil];
        [alertView show];
        [alertView release];
    }
    
}

- (IBAction)hidenKeyBoard:(id)sender {
    
  [self.oPwdText resignFirstResponder];
    [self.nPwdText resignFirstResponder];
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
    [[[UIApplication sharedApplication]keyWindow]endEditing:NO];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:Nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:Nil];
}

- (IBAction)backUsercenterAction:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)passIntoGameAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}



- (void)request:(ZplayRequest *)request didReceiveResponse:(NSURLResponse *)response
{
    
}
- (void)request:(ZplayRequest *)request didReceiveRawData:(NSData *)data
{
    
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

}
- (void)request:(ZplayRequest *)request didFinishLoadingWithResult:(id)result
{
    [self.activityV stopAnimating];
    [self.activityV setHidden:YES];
    [self.view setUserInteractionEnabled:YES];
    if ([[[result objectForKey:@"msg"] objectForKey:@"text"] caseInsensitiveCompare:@"OK"]==NSOrderedSame) {
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                             message:@"修改密码成功"
                                                            delegate:nil
                                                   cancelButtonTitle:@"确定"
                                                   otherButtonTitles:nil];
        [alertView show];
        [alertView release];
        [[NSUserDefaults standardUserDefaults]setObject:self.acctr forKey:USER_LOGINACC];
        [[NSUserDefaults standardUserDefaults]setObject:self.nPwdText.text forKey:USER_LOGINPWD];
        [[NSUserDefaults standardUserDefaults]setObject:self.acctr forKey:USER_AUTOLOGINACC];
        [[NSUserDefaults standardUserDefaults]setObject:self.nPwdText.text forKey:USER_AUTOLOGINPWD];
        [[Slqite shareInstance]upDataDbaseOldUserId:self.acctr UserName:Nil Password:_nPwdText.text];
        self.oPwdText.text=nil;
        self.nPwdText.text=nil;
    }
    NSLog(@"%@",result);
}

//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
//    [self.nPwdText resignFirstResponder];
//    [self.oPwdText resignFirstResponder];
//}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder]; //  5, 220, 220, 30
    self.view.transform = CGAffineTransformMakeTranslation(0, 0);
    return YES;
}


- (void)viewDidUnload {
    [self setTitleLabel:nil];
    [self setMsgLabel:nil];
    [super viewDidUnload];
}



-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [self.oPwdText resignFirstResponder];
    [self.nPwdText resignFirstResponder];
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
