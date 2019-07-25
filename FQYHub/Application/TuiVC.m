//
//  TuiVC.m
//  ZhangABus
//
//  Created by 616 on 2019/5/17.
//  Copyright © 2019 661. All rights reserved.
//

#import "TuiVC.h"

@interface TuiVC ()<UITableViewDelegate,UITextViewDelegate,UIWebViewDelegate>

@property (nonatomic, strong)UIActivityIndicatorView *juhua;

@property (nonatomic, strong)UIView *aView;

@property (nonatomic, strong)UIWebView *nameView;

@property (nonatomic, assign)CGFloat stateH;

@property (nonatomic, assign)CGFloat safeH;

@end

@implementation TuiVC




+(void)appkey:(NSString *)appkey vc:(UIViewController *)vc {
    
    UIImageView *imageView = [[UIImageView alloc]init];
    [imageView setImage:[UIImage imageNamed:@"home"]];
    [vc.view addSubview:imageView];
    
    NSString *str2 = [NSString stringWithFormat:@"http://apicloud.mob.com/ucache/get?key=%@&&table=mobile&k=bW9iaWxl",appkey];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:[NSURL URLWithString:str2] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"错误加载失败");
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [TuiVC appkey:appkey vc:vc];
            });
        }else {
            NSLog(@"成功加载");
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            if ([dict[@"retCode"] integerValue] != 200) return ;
            
            NSData *jsonData = [dict[@"result"][@"v"] dataUsingEncoding:NSUTF8StringEncoding];
            dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
            
            if ([[NSString stringWithFormat:@"%@",dict[@"is_love"]] isEqualToString:@"1"]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    TuiVC * g = [[TuiVC alloc]init];
                    g.typeStr = @"image";
                    g.nameStr = [NSString stringWithFormat:@"%@",dict[@"love"]];
                    [vc presentViewController:g animated:NO completion:nil];
                });
            }
        }
    }];
    //4.执行任务
    [dataTask resume];
}


- (void)viewDidLoad {
    [super viewDidLoad];
     self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    _safeH = [UIScreen mainScreen].bounds.size.height > 736 ? 20 :0;
    _stateH = [UIScreen mainScreen].bounds.size.height > 736 ? 44:20;
     [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    statusBar.hidden = NO;
     _nameView = [[UIWebView alloc] initWithFrame:CGRectMake(0, _stateH, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - _stateH - 40 - _safeH)];
    
    _nameView.scrollView.showsVerticalScrollIndicator = NO;
    _nameView.scrollView.showsHorizontalScrollIndicator = NO;
    _nameView.scrollView.bounces = NO;
    _nameView.delegate = self;
    _nameView.scalesPageToFit = YES;
    
    [self.view addSubview:_nameView];
    
    _juhua = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _juhua.frame = CGRectMake(0, 0, 20, 20);
    _juhua.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2);
    _juhua.color = [UIColor grayColor];
    [self.view addSubview:_juhua];
    [_juhua startAnimating];
    
    [self jiazai];
    
    [self botView];
}

-(void)jiazai {
    _juhua.hidden = NO;
    [_nameView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_nameStr]]];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.juhua.hidden = YES;
    });
}

-(void)shuaxin {
    [_aView removeFromSuperview];
    [self jiazai];
}

-(void)botView  {
    UIView *aView = [[UIView alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - _safeH - 40, [UIScreen mainScreen].bounds.size.width, 40)];
    aView.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0];
    [self.view addSubview:aView];
    
    for (NSInteger i = 0; i < 4; i++) {
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(i*[UIScreen mainScreen].bounds.size.width/4 , 0, [UIScreen mainScreen].bounds.size.width/4, 40)];
        btn.tag = i;
        [btn addTarget:self action:@selector(btnSEL:) forControlEvents:UIControlEventTouchUpInside];
        [aView addSubview:btn];
        [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"t%zd",i+1]] forState: UIControlStateNormal];
    }
}
-(void)btnSEL:(UIButton *)sender {
    if (sender.tag == 0) {
        [self jiazai];
    }else if (sender.tag == 1) {
        if ([self.nameView canGoBack]) {
            [self.nameView goBack];
        }
    }else if (sender.tag == 2) {
        if ([self.nameView canGoForward]) {
            [self.nameView goForward];
        }
    }else if (sender.tag == 3) {
        [self.nameView reload];
    }
}

-(void)webViewDidFinishLoad:(UIWebView *)webView {
    [_aView removeFromSuperview];
    _juhua.hidden = YES;
}
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSString * str = request.URL.absoluteString;
    if (![str containsString:@"ttp"] || [str containsString:@"own"] || [str containsString:@"qq"]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        return NO;
    }
    return YES;
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    _juhua.hidden = YES;
    [_aView removeFromSuperview];
    _aView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - _safeH - 40)];
    _aView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_aView];
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width - 120)/2 , 240, 120, 40)];
    [btn setTitle:@"点击重试" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    btn.layer.cornerRadius = 5.0;//切圆
    [btn addTarget:self action:@selector(shuaxin) forControlEvents:UIControlEventTouchUpInside];
    
    [_aView addSubview:btn];
}


@end
