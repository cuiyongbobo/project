//
//  AsWerVCtl.m
//  zplaySDk1.0
//
//  Created by ZPLAY005 on 14-4-3.
//  Copyright (c) 2014年 ZPLAY005. All rights reserved.
//

#import "AsWerVCtl.h"
#import "loginViewController.h"
#import "DefineObjcs.h"

@interface AsWerVCtl ()
- (IBAction)backLoginVctrlAction:(id)sender;
@property (retain, nonatomic) IBOutlet UITextView *textView;

@end

@implementation AsWerVCtl

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:@"AsWerVCtl" bundle:ZPLAY_BUNDLE];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)backLoginVctrlAction:(id)sender {
    loginViewController *loginVctrl=[[loginViewController alloc]init];
    [self.navigationController pushViewController:loginVctrl animated:YES];
    [loginVctrl release];
    loginVctrl=nil;
}
- (void)dealloc {
    [_textView release];
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


@end
