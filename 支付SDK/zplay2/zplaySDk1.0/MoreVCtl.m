//
//  MoreVCtl.m
//  zplaySDk1.0
//
//  Created by ZPLAY005 on 14-4-3.
//  Copyright (c) 2014年 ZPLAY005. All rights reserved.
//

#import "MoreVCtl.h"
#import "DefineObjcs.h"
#import "Zplay.h"
@interface MoreVCtl ()<ZplayRequestDelegate>
{
    CGRect rectT;
}
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *activityV;
@property (retain, nonatomic) IBOutlet UILabel *titleLabel;
@property (retain, nonatomic) IBOutlet UILabel *yonghuLabel;
@property (retain, nonatomic) IBOutlet UILabel *fLabel;
@property (retain, nonatomic) IBOutlet UILabel *sLabel;
@property (retain, nonatomic) IBOutlet UILabel *srLabel;
@property (retain, nonatomic) IBOutlet UILabel *foLabel;
@property (retain, nonatomic) IBOutlet UILabel *firLabel;
@property (retain, nonatomic) IBOutlet UILabel *SiLabel;
@property (retain, nonatomic) IBOutlet UIButton *hideBtn;
@end

@implementation MoreVCtl

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:@"MoreVCtl" bundle:ZPLAY_BUNDLE];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.activityV setHidden:YES];
    [self.textV setBackgroundColor:[UIColor whiteColor]];
    self.textV.layer.borderColor=[[UIColor lightGrayColor] CGColor];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
}
- (IBAction)keyBoardHAction:(id)sender {
    [self.textV resignFirstResponder];
}
- (void)keyBoardWillShow:(NSNotification*)nofication
{
    [self.hideBtn setHidden:NO];
    rectT=self.textV.frame;
    
    NSDictionary *userInfo = nofication.userInfo;
    CGFloat timerInterval = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    UIViewAnimationOptions animationOptions = [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    
    [UIView animateWithDuration:timerInterval
                          delay: 0.0
                        options: animationOptions
                     animations:^{
                         self.textV.frame = self.view.frame;
                     }
                     completion:nil];
}
- (void)keyBoardWillHide:(NSNotification*)nofication
{
    
    [self.hideBtn setHidden:YES];
    //处理键盘上的tabbar
    NSDictionary *userInfo = nofication.userInfo;
    CGFloat timerInterval = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    UIViewAnimationOptions animationOptions = [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    [UIView animateWithDuration:timerInterval
                          delay: 0.0
                        options: animationOptions
                     animations:^{
                         self.textV.frame=rectT;
                     }
                     completion:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.hideBtn.layer.cornerRadius=5.0f;
    
    rectT=self.textV.frame;
    self.textV.layer.cornerRadius=5.0f;
    self.textV.layer.borderWidth=1.0f;
    self.textV.layer.borderColor=[[UIColor lightGrayColor]CGColor];
    
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad) {
        _titleLabel.font=[UIFont systemFontOfSize:30.0f];
        _titleLabel.font=[UIFont systemFontOfSize:25.0f];
        _yonghuLabel.font=[UIFont systemFontOfSize:25.0f];
        _fLabel.font=[UIFont systemFontOfSize:25.0f];
        _sLabel.font=[UIFont systemFontOfSize:25.0f];
        _srLabel.font=[UIFont systemFontOfSize:25.0f];
        _foLabel.font=[UIFont systemFontOfSize:25.0f];
        _firLabel.font=[UIFont systemFontOfSize:25.0f];
        _SiLabel.font=[UIFont systemFontOfSize:25.0f];
        _commBtn.titleLabel.font=[UIFont systemFontOfSize:25.0f];
    }
    
    
}
- (IBAction)hidenKeyBoardAction:(id)sender {
    [_textV resignFirstResponder];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_backGV release];
    
    [_textV release];
    
    [_activityV release];
    [_titleLabel release];
    [_yonghuLabel release];
    [_fLabel release];
    [_sLabel release];
    [_srLabel release];
    [_foLabel release];
    [_firLabel release];
    [_SiLabel release];
    [_commBtn release];
    [_hideBtn release];
    [super dealloc];
}
- (IBAction)commitBtnAction:(id)sender {
    
    if (self.textV.text.length==0) {
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                             message:@"请输入信息后提交"
                                                            delegate:nil
                                                   cancelButtonTitle:@"确定"
                                                   otherButtonTitles:nil];
        [alertView show];
        [alertView release];
    }else{
        [self.activityV setHidden:NO];
        [self.activityV startAnimating];
        [self.view setUserInteractionEnabled:NO];
        [[Zplay shareInstance]postServerMsguserId:self.useridStr userMsg:self.textV.text Delegate:self];
    }
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:Nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:Nil];
}

- (IBAction)backUserCenter:(id)sender {
    [_textV resignFirstResponder];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)enterGame:(id)sender
{
     [_textV resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:Nil];
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
    self.textV.text=nil;
}
- (void)request:(ZplayRequest *)request didFinishLoadingWithResult:(id)result
{
    [self.activityV stopAnimating];
    [self.activityV setHidden:YES];
    [self.view setUserInteractionEnabled:YES];
    if ([[[request.params objectForKey:@"data"] objectForKey:@"action"]isEqualToString:@"reportMsg"]) {
        if ([[[result objectForKey:@"msg"] objectForKey:@"text"] caseInsensitiveCompare:@"OK"]==NSOrderedSame) {
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                 message:@"提交成功"
                                                                delegate:nil
                                                       cancelButtonTitle:@"确定"
                                                       otherButtonTitles:nil];
            [alertView show];
            [alertView release];
            self.textV.text=nil;
        }else
        {
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                 message:@"提交失败，请稍后重试"
                                                                delegate:nil
                                                       cancelButtonTitle:@"确定"
                                                       otherButtonTitles:nil];
            [alertView show];
            [alertView release];

        }
        NSLog(@"%@",result);
        
    }
    
}


- (void)viewDidUnload {
    [self setTitleLabel:nil];
    [self setYonghuLabel:nil];
    [self setFLabel:nil];
    [self setSLabel:nil];
    [self setSrLabel:nil];
    [self setFoLabel:nil];
    [self setFirLabel:nil];
    [self setSiLabel:nil];
    [self setCommBtn:nil];
    [self setHideBtn:nil];
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
