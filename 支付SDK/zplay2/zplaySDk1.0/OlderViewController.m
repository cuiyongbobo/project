//
//  OlderViewController.m
//  zplaySDk1.0
//
//  Created by ZPLAY005 on 14-3-14.
//  Copyright (c) 2014年 ZPLAY005. All rights reserved.
//

#import "OlderViewController.h"
#import "Zplay.h"
#import "DefineObjcs.h"
#import "Slqite.h"
@interface OlderViewController ()<ZplayRequestDelegate>
{
    CGRect bRect;
}
@property (retain, nonatomic) IBOutlet UIView *cView;
@property (retain, nonatomic) IBOutlet UIView *bView;
@property (retain, nonatomic) IBOutlet UITextField *userNameTextF;
@property (retain, nonatomic) IBOutlet UIButton *hidenBtn;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *activityView;



@end

@implementation OlderViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:@"OlderViewController" bundle:ZPLAY_BUNDLE];
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
    bRect=self.bView.frame;
    self.hidenBtn.hidden=NO;

    NSDictionary *userInfo = nofication.userInfo;
    
    CGFloat timerInterval = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    UIViewAnimationOptions animationOptions = [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    
    
    [UIView animateWithDuration:timerInterval
                          delay: 0.0
                        options: animationOptions
                     animations:^{
                         self.bView.frame = (CGRect){bRect.origin.x,bRect.origin.y-70,bRect.size};
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
    self.cView.layer.cornerRadius=5.0f;
    self.bView.layer.cornerRadius=5.0f;
    self.cView.layer.borderColor=[[UIColor lightGrayColor]CGColor];
    self.cView.layer.borderWidth=1.0f;
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)commitBtnAction:(UIButton *)sender {
    if (_userNameTextF.text.length<20 && _userNameTextF.text.length>6) {
        
    
        NSString *regex = @"^[A-Za-z0-9]+$";
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        if([pred evaluateWithObject:_userNameTextF.text])
        {
            
            NSString *regex = @"^.*(.)\\1{4}.*$";
            NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
            if([pred2 evaluateWithObject:_userNameTextF.text])
            {
                UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                     message:@"用户名不符合规范，请重新输入"
                                                                    delegate:nil
                                                           cancelButtonTitle:@"确定"
                                                           otherButtonTitles:nil];
                [alertView show];
                [alertView release];
                 alertView=Nil;
                
            }else
            {
                NSString *regex = @"(z|Z)\\d{8}";
                NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
                if(![pred2 evaluateWithObject:_userNameTextF.text])
                {
                    [_activityView startAnimating];
                    [[Zplay shareInstance]changeNameFromServerUserId:_userstr UserName:_userNameTextF.text Delegate:self];
                
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
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                 message:@"用户名不符合规范，请重新输入"
                                                                delegate:nil
                                                       cancelButtonTitle:@"确定"
                                                       otherButtonTitles:nil];
            [alertView show];
            [alertView release];
             alertView=Nil;
        }
        
    }else
    {
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                             message:@"用户名长度(6-20位)"
                                                            delegate:nil
                                                   cancelButtonTitle:@"确定"
                                                   otherButtonTitles:nil];
        [alertView show];
        [alertView release];
        alertView=Nil;
    }
   
}
- (void)request:(ZplayRequest *)request didFailWithError:(NSError *)error
{
    [_activityView stopAnimating];
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
        [_activityView stopAnimating];

    NSString *str3=[[result objectForKey:@"msg"] objectForKey:@"text"];
    NSString *result10 = (NSString*)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,
                                                                                            (CFStringRef)str3,
                                                                                            CFSTR(""),
                                                                                            kCFStringEncodingUTF8);
    NSLog(@"%@-------%@",result10,result);
     if ([[[request.params objectForKey:@"data"] objectForKey:@"action"]isEqualToString:@"changeName"])
    {
        NSString *code3=[[result objectForKey:@"msg"] objectForKey:@"code"];
        if ([[[result objectForKey:@"msg"] objectForKey:@"text"] caseInsensitiveCompare:@"OK"]==NSOrderedSame)
        {
            [[NSUserDefaults standardUserDefaults]setObject:_userNameTextF.text forKey:USER_LOGINNAME];
            [[Slqite shareInstance]upDataDbaseOldUserId:_userstr UserName:_userNameTextF.text Password:nil];
            [self dismissViewControllerAnimated:YES completion:Nil];
            
        }else if ([code3 isEqualToString:@"3"])
        {
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                 message:@"用户名已存在，请重新输入"
                                                                delegate:nil
                                                       cancelButtonTitle:@"确定"
                                                       otherButtonTitles:nil];
            [alertView show];
            [alertView release];
            alertView=Nil;
        }else{
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                 message:@"用户名绑定失败，请重新输入"
                                                                delegate:nil
                                                       cancelButtonTitle:@"确定"
                                                       otherButtonTitles:nil];
            [alertView show];
            [alertView release];
            alertView=Nil;
        }
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)keyBoardHidenAction:(id)sender {
    [_userNameTextF resignFirstResponder];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:Nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:Nil];
}
- (void)dealloc {
    [_cView release];
    [_bView release];
    [_userNameTextF release];
    [_hidenBtn release];
    [_activityView release];
    [super dealloc];
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

- (void)viewDidUnload {
    [self setCView:nil];
    [self setBView:nil];
    [self setUserNameTextF:nil];
    [self setHidenBtn:nil];
    [self setActivityView:nil];
    [super viewDidUnload];
}
@end
