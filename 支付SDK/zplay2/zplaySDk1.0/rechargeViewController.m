//
//  rechargeViewController.m
//  zplayXGZSDK
//
//  Created by ZPLAY005 on 14-1-22.
//  Copyright (c) 2014年 ZPLAY005. All rights reserved.
//

#import "rechargeViewController.h"
#import "Zplay.h"
#import "DefineObjcs.h"

@interface rechargeViewController ()<ZplayRequestDelegate>
{
    UIButton *btn;
  
}

@property(nonatomic,retain)NSMutableArray *textMutableAry;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *activityV;
@property (retain, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation rechargeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:@"rechargeViewController" bundle:ZPLAY_BUNDLE];
    if (self) {
        
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    if (self.userId !=nil) {
        [self.view setUserInteractionEnabled:NO];
        [[Zplay shareInstance]getPaylistFromServeruserId:self.userId lastId:@"-1"Delegate:self];
    
    }
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.activityV startAnimating];
    self.textMutableAry=[NSMutableArray array];
    self.topImageV.userInteractionEnabled=YES;
    self.tableView.dataSource=self;
    self.tableView.showsVerticalScrollIndicator=YES;
    
    btn=[[UIButton alloc]init];
    btn.userInteractionEnabled=NO;
//    btn.autoresizingMask=UIViewAutoresizingFlexibleBottomMargin;
    [btn setTitle:@"更多....." forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
   
//    [btn setBackgroundColor:[UIColor lightGrayColor]];
//    [btn setBackgroundImage:[UIImage imageNamed:@"11"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(morePaylist) forControlEvents:UIControlEventTouchUpInside];
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad) {
        _titleLabel.font=[UIFont systemFontOfSize:30.0f];
        
    }
    // Do any additional setup after loading the view from its nib.
}


-(void)morePaylist
{
    if (_textMutableAry.count !=0) {
        if (self.userId !=nil)
        {
            
            [self.activityV setHidden:NO];
            [self.activityV startAnimating];
            
            NSString *lastId=[[self.textMutableAry lastObject]objectForKey:@"id"];
            [[Zplay shareInstance]getPaylistFromServeruserId:self.userId lastId:lastId Delegate:self];
        }
    }else{
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                             message:@"无更多数据"
                                                            delegate:nil
                                                   cancelButtonTitle:@"确定"
                                                   otherButtonTitles:nil];
        [alertView show];
        [alertView release];
    
    }
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_topImageV release];
    [_tableView release];
    [_activityV release];
    [_titleLabel release];
    [super dealloc];
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *str=Nil;
    if (section==0) {
        str=[NSString stringWithFormat:@"通行证: %@",self.userId];
    }
    return str;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
    
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        CGSize size=cell.contentView.frame.size;
        UILabel *lable1=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, size.width/3, size.height)];
        [lable1 setTextAlignment:NSTextAlignmentCenter];
        lable1.font=[UIFont systemFontOfSize:11.0];
        lable1.backgroundColor=[UIColor clearColor];
        lable1.autoresizingMask=UIViewAutoresizingFlexibleRightMargin;
        UILabel *lable2=[[UILabel alloc]initWithFrame:CGRectMake(115, 0, size.width/3, size.height)];
        [lable2 setTextAlignment:NSTextAlignmentCenter];
        lable2.font=[UIFont systemFontOfSize:10.0];
        lable2.backgroundColor=[UIColor clearColor];
        lable2.autoresizingMask=UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        UILabel *lable3=[[UILabel alloc]initWithFrame:CGRectMake(0+2*(size.width/3), 0, size.width/3, size.height)];
        [lable3 setTextAlignment:NSTextAlignmentCenter];
        lable3.font=[UIFont systemFontOfSize:11.0];
        lable3.backgroundColor=[UIColor clearColor];
        lable3.autoresizingMask=UIViewAutoresizingFlexibleLeftMargin;
        lable1.tag=101;
        lable2.tag=112;
        lable3.tag=103;
        [cell.contentView addSubview:lable1];
        [cell.contentView addSubview:lable2];
        [cell.contentView addSubview:lable3];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    if (self.textMutableAry.count !=0) {
        UILabel *lable1=(UILabel *)[cell.contentView viewWithTag:101];
        UILabel *lable2=(UILabel *)[cell.contentView viewWithTag:112];
        UILabel *lable3=(UILabel *)[cell viewWithTag:103];
        lable1.text=[[self.textMutableAry objectAtIndex:indexPath.section]objectForKey:@"gamename"];
        lable2.text=[[self.textMutableAry objectAtIndex:indexPath.section]objectForKey:@"paytime"];
        lable3.text=[[self.textMutableAry objectAtIndex:indexPath.section]objectForKey:@"money"];
    }
    
    return cell;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.textMutableAry.count;
}
- (void)request:(ZplayRequest *)request didReceiveResponse:(NSURLResponse *)response
{
    
}

- (void)request:(ZplayRequest *)request didReceiveRawData:(NSData *)data
{
    
}
- (void)request:(ZplayRequest *)request didFailWithError:(NSError *)error
{
    [self.activityV startAnimating];
    [self.activityV setHidesWhenStopped:YES];
    NSLog(@"%@",[error localizedDescription]);
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
    NSArray *ary=[result objectForKey:@"data"];
    btn.userInteractionEnabled=YES;
    if (ary.count !=0 && ary !=nil) {
        [self.textMutableAry addObjectsFromArray:[result objectForKey:@"data"]];
        
        
        UIView *moreV=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 70)];
        btn.frame=CGRectMake(CGRectGetWidth(self.view.frame)/2-70, 10, 140, 50);
        self.tableView.tableFooterView=moreV;
        
        [moreV addSubview:btn];
    }
    else
    {
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                             message:@"没有更多数据了！"
                                                            delegate:nil
                                                   cancelButtonTitle:@"确定"
                                                   otherButtonTitles:nil];
        [alertView show];
        [alertView release];

    }
    [self.tableView reloadData];
    NSLog(@"%@                    %lu",result,(unsigned long)self.textMutableAry.count);
}

- (IBAction)backUserCentreAction:(id)sender {
 [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)passIntoGameAction:(id)sender {
     [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)viewDidUnload {
    [self setTitleLabel:nil];
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
