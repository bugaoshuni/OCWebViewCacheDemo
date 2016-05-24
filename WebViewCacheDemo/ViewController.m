//
//  ViewController.m
//  WebViewCacheDemo
//
//  Created by jichanghe on 16/5/3.
//  Copyright © 2016年 hjc. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (strong, nonatomic) NSURLConnection *connection;
@property (strong, nonatomic) NSURLCache *urlCache;
@property (strong, nonatomic) NSURL *url;
@property (strong, nonatomic) NSMutableURLRequest *request;
@property (strong, nonatomic) IBOutlet UIWebView *myWebView;

- (IBAction)reloadWebView:(UIButton *)sender;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *paramURLAsString= @"https://www.baidu.com";
    self.urlCache = [NSURLCache sharedURLCache];
    
    [self.urlCache setMemoryCapacity:1*1024*1024];
    //创建一个nsurl
    self.url = [NSURL URLWithString:paramURLAsString];
    //创建一个请求
    self.request=[NSMutableURLRequest requestWithURL:self.url
                                         cachePolicy:NSURLRequestUseProtocolCachePolicy
                                     timeoutInterval:30.0f];
    [self.myWebView loadRequest:self.request];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



- (IBAction)reloadWebView:(UIButton *)sender {
    
    //从请求中获取缓存输出
    NSCachedURLResponse *response =[self.urlCache cachedResponseForRequest:self.request];
    //判断是否有缓存
    if (response != nil){
        NSLog(@"如果有缓存输出，从缓存中获取数据");
        [self.request setCachePolicy:NSURLRequestReturnCacheDataDontLoad];
    }
    [self.myWebView loadRequest:self.request];
    
    self.connection = nil;
    
    NSURLConnection *newConnection = [[NSURLConnection alloc] initWithRequest:self.request
                                                                     delegate:self
                                                             startImmediately:YES];
    self.connection = newConnection;
}

//使用下面代码，我将请求的过程打印出来
- (void)  connection:(NSURLConnection *)connection
  didReceiveResponse:(NSURLResponse *)response{
    NSLog(@"将接收输出");
}

- (NSURLRequest *)connection:(NSURLConnection *)connection
             willSendRequest:(NSURLRequest *)request
            redirectResponse:(NSURLResponse *)redirectResponse{
    NSLog(@"即将发送请求");
    return(request);
}
- (void)connection:(NSURLConnection *)connection
    didReceiveData:(NSData *)data{
    NSLog(@"接受数据");
    NSLog(@"数据长度为 = %lu", (unsigned long)[data length]);
}
- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse *)cachedResponse{
    NSLog(@"将缓存输出");
    return(cachedResponse);
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    NSLog(@"请求完成");
}
- (void)connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)error{
    NSLog(@"请求失败");
}


@end
