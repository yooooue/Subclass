//
//  ShareToWXViewController.m
//  Subclass
//
//  Created by 韩倩云 on 2020/8/21.
//  Copyright © 2020 yy. All rights reserved.
//

#import "ShareToWXViewController.h"
#import "WXApi.h"
#import "Subclass-Swift.h"

@interface ShareToWXViewController ()

@end

@implementation ShareToWXViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(10, 200, 100, 40)];
    [btn setTitle:@"分享到好友" forState:UIControlStateNormal];
    btn.tag = 100;
    [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    btn.backgroundColor = [UIColor redColor];
    [self.view addSubview:btn];
    
    UIButton * btn2 = [[UIButton alloc]initWithFrame:CGRectMake(self.view.width-10-100, 200, 100, 40)];
    [btn2 setTitle:@"分享到朋友圈" forState:UIControlStateNormal];
    btn2.tag = 101;
    [btn2 addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    btn2.backgroundColor = [UIColor redColor];
    [self.view addSubview:btn2];
    
    UIButton * btn3 = [[UIButton alloc]initWithFrame:CGRectMake(10, 300, 100, 40)];
    [btn3 setTitle:@"分享到QQ" forState:UIControlStateNormal];
    btn3.tag = 102;
    [btn3 addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    btn3.backgroundColor = [UIColor redColor];
    [self.view addSubview:btn3];
    
    UIButton * btn4 = [[UIButton alloc]initWithFrame:CGRectMake(self.view.width-10-100, 300, 100, 40)];
    [btn4 setTitle:@"分享到QQ空间" forState:UIControlStateNormal];
    btn4.tag = 103;
    [btn4 addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    btn4.backgroundColor = [UIColor redColor];
    [self.view addSubview:btn4];
}

- (void)clickBtn:(UIButton *)btn {
    UIImage * image = [UIImage imageNamed:@"2x.png"];
    NSData * imageData = UIImageJPEGRepresentation(image, 0.2);
    WXImageObject * imgObj = [WXImageObject object];
    imgObj.imageData = imageData;
    
    WXMediaMessage * message = [WXMediaMessage message];
    message.thumbData = imageData;
    message.mediaObject = imgObj;
    
    SendMessageToWXReq * req = [[SendMessageToWXReq alloc]init];
    req.bText = NO;
    req.message = message;
    
//    if (btn.tag==100) {
//        req.scene = WXSceneSession;
//    }else  {
//        req.scene = WXSceneTimeline;
//    }
//
    switch (btn.tag-100) {
        case 0:
            req.scene = WXSceneSession;

            break;
        case 1:
            req.scene = WXSceneTimeline;

            break;
        case 2:
        {
            QQApiTextObject *txtObj = [QQApiTextObject objectWithText:@"text"];
            SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:txtObj];
            //将内容分享到
            QQApiSendResultCode sent = [QQApiInterface sendReq:req];
        }
            break;
            
        default:
            
            break;
    }
    [WXApi sendReq:req completion:^(BOOL success) {
        
    }];
    
    [NSMutableDictionary dictionaryWithObjectsAndKeys:(__bridge_transfer id )kSecClassGenericPassword,kSecClass,(__bridge_transfer id )kSecAttrService,(__bridge_transfer id )kSecAttrAccount,(__bridge_transfer id )kSecAttrAccessibleAfterFirstUnlock,(__bridge_transfer id )kSecAttrAccessible,nil];
}

@end
