//
//  ACCSafetyViewController.m
//  ZplayAppStoreSDK
//
//  Created by ZPLAY005 on 14-3-20.
//  Copyright (c) 2014年 vbdsgfht. All rights reserved.
//

#import "ACCSafetyViewController.h"
#import "UnbindPhoneViewController.h"
#import "RemoveBindViewController.h"
#import "secureViewController.h"
#import "Zplay.h"
#import "DefineObjcs.h"
#import "MBProgressHUD.h"
@interface ACCSafetyViewController ()<ZplayRequestDelegate,MBProgressHUDDelegate>
@property (retain, nonatomic) IBOutlet UIButton *sBtn3;
@property (retain, nonatomic) IBOutlet UIButton *sBtn2;
@property (retain, nonatomic) IBOutlet UIButton *sBtn1;
@property (retain, nonatomic) IBOutlet UIButton *ipad_sBtn1;
@property (retain, nonatomic) IBOutlet UIButton *ipad_sBtn3;
@property (retain, nonatomic) IBOutlet UIButton *ipad_sBtn2;
@property (retain, nonatomic) IBOutlet UILabel *ipad_gaTextL;
@property (retain, nonatomic) IBOutlet UILabel *ipad_mailTextL;
@property (retain, nonatomic) IBOutlet UILabel *ipad_iphTextL;
@property (retain, nonatomic) IBOutlet UILabel *ipad_AcctextLabel;
@property (retain, nonatomic) IBOutlet UIView *ipad_BelowV;
@property (retain, nonatomic) IBOutlet UIView *ipad_CentralV;
@property (retain, nonatomic) IBOutlet UIView *ipad_TopV;
@property (retain, nonatomic) IBOutlet UIView *ipad_V;
@property (retain, nonatomic) IBOutlet UIView *ipone_V;
@property (retain, nonatomic) IBOutlet UIView *topV;
@property (retain, nonatomic) IBOutlet UIView *centralV;
@property (retain, nonatomic) IBOutlet UIView *belowV;
@property (retain, nonatomic) IBOutlet UILabel *accTextLabel;
@property (retain, nonatomic) IBOutlet UILabel *iphTextL;
@property (retain, nonatomic) IBOutlet UILabel *mailTextL;
@property (retain, nonatomic) IBOutlet UILabel *gaTextL;
//@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *activityV;
@property (retain, nonatomic) IBOutlet UIButton *backBtn;
@property(nonatomic,retain)NSString *useridStr;
- (IBAction)touchBtnAction:(id)sender;

@end

@implementation ACCSafetyViewController
{
    MBProgressHUD *tipHUD;

}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:@"ACCSafetyViewController" bundle:ZPLAY_BUNDLE];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
//    NSString *userf=[NSString stringWithFormat:@"%@Frist",_useridStr];
//        [_activityV startAnimating];
        [_backBtn setHidden:NO];
    tipHUD = [[[MBProgressHUD alloc] initWithView:self.view] autorelease];
    [self.view addSubview:tipHUD];
    tipHUD.delegate = self;
    tipHUD.labelText= @"掌游为您加载中...";
    [tipHUD show:YES];
    [[Zplay shareInstance]getBindsFromSeverUserId:self.useridStr Delegate:self];
    [self textLalekasd];
    _ipad_mailTextL.text=@"未绑定";
    _mailTextL.text=@"未绑定";
    _ipad_iphTextL.text=@"未绑定";
    _iphTextL.text=@"未绑定";
    _ipad_gaTextL.text=@"未绑定";
    _gaTextL.text=@"未绑定";
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _useridStr=[[NSUserDefaults standardUserDefaults]objectForKey:USER_LOGINACC];
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
    {
       

        [_ipone_V setHidden:YES];
        [_ipad_V setHidden:NO];
         _ipad_AcctextLabel.text=_useridStr;
        _ipad_AcctextLabel.font=[UIFont systemFontOfSize:25.0f];
        _ipad_TopV.layer.borderWidth=1.0f;
        _ipad_TopV.layer.borderColor=[[UIColor lightGrayColor]CGColor];
        _ipad_CentralV.layer.borderWidth=1.0f;
        _ipad_CentralV.layer.borderColor=[[UIColor lightGrayColor]CGColor];
        _ipad_BelowV.layer.borderWidth=1.0f;
        _ipad_BelowV.layer.borderColor=[[UIColor lightGrayColor]CGColor];
        
        
    }else
    {
        [_ipad_V setHidden:YES];
        [_ipone_V setHidden:NO];
         _accTextLabel.text=_useridStr;
        _accTextLabel.font=[UIFont systemFontOfSize:17.0f];
        _topV.layer.borderWidth=1.0f;
        _topV.layer.borderColor=[[UIColor lightGrayColor]CGColor];
        _centralV.layer.borderWidth=1.0f;
        _centralV.layer.borderColor=[[UIColor lightGrayColor]CGColor];
        _belowV.layer.borderWidth=1.0f;
        _belowV.layer.borderColor=[[UIColor lightGrayColor]CGColor];
    }
    
    
    

}
-(void)textLalekasd
{
    
    
    _ipad_mailTextL.text=@"未绑定";
    _mailTextL.text=@"未绑定";
    _ipad_iphTextL.text=@"未绑定";
    _iphTextL.text=@"未绑定";
    _ipad_gaTextL.text=@"未绑定";
    _gaTextL.text=@"未绑定";
    
    [_ipad_sBtn3 setTitle:@"设置>" forState:UIControlStateNormal];
    [_sBtn3 setTitle:@"设置>" forState:UIControlStateNormal];
    [_ipad_sBtn1 setTitle:@"设置>" forState:UIControlStateNormal];

    [_sBtn1 setTitle:@"设置>" forState:UIControlStateNormal];
    [_ipad_sBtn2 setTitle:@"设置>" forState:UIControlStateNormal];
    [_sBtn2 setTitle:@"设置>" forState:UIControlStateNormal];
    
   
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {

    [_ipone_V release];
    [_ipad_V release];
    [_ipad_TopV release];
    [_ipad_CentralV release];
    [_ipad_BelowV release];
    [_accTextLabel release];
    [_ipad_AcctextLabel release];
    [_iphTextL release];
    [_mailTextL release];
    [_gaTextL release];
    [_ipad_iphTextL release];
    [_ipad_mailTextL release];
    [_ipad_gaTextL release];
//    [_activityV release];
//    [tipHUD release];
    [_backBtn release];
    [_ipad_sBtn3 release];
    [_ipad_sBtn2 release];
    [_ipad_sBtn1 release];
    [_sBtn1 release];
    [_sBtn2 release];
    [_sBtn3 release];
    [super dealloc];
}
- (IBAction)backUserVctrlAction:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (IBAction)backGameAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)viewDidUnload {

    [self setIpone_V:nil];
    [self setIpad_V:nil];
    [self setIpad_TopV:nil];
    [self setIpad_CentralV:nil];
    [self setIpad_BelowV:nil];
    [self setAccTextLabel:nil];
    [self setIpad_AcctextLabel:nil];
    [self setIphTextL:nil];
    [self setMailTextL:nil];
    [self setGaTextL:nil];
    [self setIpad_iphTextL:nil];
    [self setIpad_mailTextL:nil];
    [self setIpad_gaTextL:nil];
//    [self setActivityV:nil];
    tipHUD = nil;
    [self setBackBtn:nil];
    [self setIpad_sBtn3:nil];
    [self setIpad_sBtn2:nil];
    [self setIpad_sBtn1:nil];
    [self setSBtn1:nil];
    [self setSBtn2:nil];
    [self setSBtn3:nil];
    [super viewDidUnload];
}
- (IBAction)touchBtnAction:(UIButton *)sender {
    switch (sender.tag) {
        case 1990:
        {
            NSLog(@"手机");
           
            NSString *userIph=[NSString  stringWithFormat:@"%@iph",_useridStr];
           
            
            
            if ([[NSUserDefaults standardUserDefaults]boolForKey:userIph]) {
                RemoveBindViewController *romveIponeBind=[[RemoveBindViewController alloc]init];
                romveIponeBind.strStryl=@"手机";
                romveIponeBind.userStr=_useridStr;
                [self.navigationController pushViewController:romveIponeBind animated:YES];
                [romveIponeBind release];
            }else{
                UnbindPhoneViewController *iponeBind=[[UnbindPhoneViewController alloc]init];
                iponeBind.strStryl=@"手机";
                iponeBind.userStr=_useridStr;
            [self.navigationController pushViewController:iponeBind animated:YES];
                [iponeBind release];
            }
            
        }
            break;
        case 1991:
        {
            NSLog(@"邮箱");
            NSString *userMail=[NSString stringWithFormat:@"%@mail",_useridStr];
            
            if ([[NSUserDefaults standardUserDefaults]boolForKey:userMail]) {
                RemoveBindViewController *romveIponeBind=[[RemoveBindViewController alloc]init];
                romveIponeBind.strStryl=@"邮箱";
                romveIponeBind.userStr=_useridStr;
                [self.navigationController pushViewController:romveIponeBind animated:YES];
                [romveIponeBind release];
            }else{
                UnbindPhoneViewController *emailBind=[[UnbindPhoneViewController alloc]init];
                emailBind.strStryl=@"邮箱";
                emailBind.userStr=_useridStr;
                [self.navigationController pushViewController:emailBind animated:YES];
                [emailBind release];
            }
            
            
        }
            break;
        case 1992:
        {
            NSString *userGa=[NSString stringWithFormat:@"%@ga",_useridStr];
            if ([[NSUserDefaults standardUserDefaults]boolForKey:userGa]) {
                secureViewController *remo=[[secureViewController alloc]init];
                remo.useridStr=_useridStr;
                
                [self.navigationController pushViewController:remo animated:YES];
                [remo release];
            }else{
                secureViewController *remo=[[secureViewController alloc]init];
                remo.useridStr=_useridStr;
                
                [self.navigationController pushViewController:remo animated:YES];
                [remo release];
            }
            
        }
            break;
        default:
            break;
    }

}
- (void)request:(ZplayRequest *)request didFailWithError:(NSError *)error;
{
//    [_activityV stopAnimating];
    [tipHUD setHidden:YES];
 NSLog(@"参数======%@",request.params);
    _ipad_mailTextL.text=@"绑定数据获取失败";
    _mailTextL.text=@"绑定数据获取失败";
    _ipad_iphTextL.text=@"绑定数据获取失败";
    _iphTextL.text=@"绑定数据获取失败";
    _ipad_gaTextL.text=@"绑定数据获取失败";
    _gaTextL.text=@"绑定数据获取失败";
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                         message:@"网络数据异常，请稍后再试"
                                                        delegate:nil
                                               cancelButtonTitle:@"确定"
                                               otherButtonTitles:nil];
    [alertView show];
    [alertView release];
     NSLog(@"%@",[error localizedDescription]);
}
- (void)request:(ZplayRequest *)request didFinishLoadingWithResult:(id)result
{
//    [_activityV stopAnimating];
    NSLog(@"reslut====%@",result);

    NSLog(@"参数======%@",request.params);
    NSString *str3=[[result objectForKey:@"msg"] objectForKey:@"text"];
    NSString *useriph=[NSString stringWithFormat:@"%@iph",_useridStr];
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:useriph];
    NSString *userGa=[NSString stringWithFormat:@"%@ga",_useridStr];
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:userGa];
    NSString *userMail=[NSString stringWithFormat:@"%@mail",_useridStr];
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:userMail];
   
    NSString *result101 = (NSString*)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,
                                                                                            (CFStringRef)str3,
                                                                                            CFSTR(""),
                                                                                            kCFStringEncodingUTF8);
    int i=[[[result objectForKey:@"msg"]objectForKey:@"code"] intValue];
    if (i==1) {
        [tipHUD setHidden:YES];
        [_backBtn setHidden:YES];
        NSString *userf=[NSString stringWithFormat:@"%@Frist",_useridStr];
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:userf];
        
    
        for (NSDictionary *dic in [result objectForKey:@"data"]) {
        
        
        
            
            if ([[dic objectForKey:@"type"]isEqualToString:@"mail"])
            {
            NSString *userMail=[NSString stringWithFormat:@"%@mail",_useridStr];
            [[NSUserDefaults standardUserDefaults]setBool:YES forKey:userMail];
            _ipad_mailTextL.text=@"已绑定";
            _mailTextL.text=@"已绑定";
            [_ipad_sBtn2 setTitle:@"修改>" forState:UIControlStateNormal];
            [_sBtn2 setTitle:@"修改>" forState:UIControlStateNormal];

            
            }
            
            
            
            
            if ([[dic objectForKey:@"type"]isEqualToString:@"qa"]){
            NSString *userga=[NSString stringWithFormat:@"%@ga",_useridStr];
            [[NSUserDefaults standardUserDefaults]setBool:YES forKey:userga];
            _gaTextL.text=@"已绑定";
            _ipad_gaTextL.text=@"已绑定";
            [_ipad_sBtn3 setTitle:@"修改>" forState:UIControlStateNormal];
            [_sBtn3 setTitle:@"修改>" forState:UIControlStateNormal];
            
            }
            NSLog(@"%@",[dic objectForKey:@"type"]);
            
            
            if ([[dic objectForKey:@"type"]isEqualToString:@"sms"])
            {
           
                NSString *useriph=[NSString stringWithFormat:@"%@iph",_useridStr];
            
                [[NSUserDefaults standardUserDefaults]setBool:YES forKey:useriph];
            _ipad_iphTextL.text=@"已绑定";
            _iphTextL.text=@"已绑定";
            [_ipad_sBtn1 setTitle:@"修改>" forState:UIControlStateNormal];
            [_sBtn1 setTitle:@"修改>" forState:UIControlStateNormal];
            }
            
        
    }
        
    }else
    {
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                             message:result101
                                                            delegate:nil
                                                   cancelButtonTitle:@"确定"
                                                   otherButtonTitles:nil];
        [alertView show];
        [alertView release];
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

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [tipHUD setHidden:YES];
    ZplayRequest *zr=[[ZplayRequest alloc]init];
    [zr disconnect];
    [zr release];
    zr=Nil;
}

@end
