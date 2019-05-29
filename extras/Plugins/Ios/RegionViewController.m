//
//  RegionViewController.m
//  Unity-iPhone
//
//  Created by ZEROwolf Hwang on 2019/5/20.
//

#import "RegionViewController.h"
#import "UnityIOSBridge.h"
@interface RegionViewController ()

@end

@implementation RegionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor =[UIColor whiteColor];
    
    // Do any additional setup after loading the view.
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(100, 300, 160, 60)];
    [button setTitle:@"点击跳转返回" forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor purpleColor]];
    [button addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:button];
}
-(void)click{
    [[UnityIOSBridge sharedManager] setupUnity];
}

@end
