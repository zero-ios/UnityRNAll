//
//  RNModule.m
//  PureRN0586
//
//  Created by ZEROwolf Hwang on 2019/5/21.
//  Copyright © 2019 Facebook. All rights reserved.
//

#import "RNModule.h"
#import <React/RCTLog.h>
#import "UnityIOSBridge.h"
#import "UnityAppController.h"
@implementation RNModule

-(UIViewController *) topMostController {
    UIViewController*topController = [UIApplication sharedApplication].keyWindow.rootViewController;
    while(topController.presentedViewController){
        topController=topController.presentedViewController;
    }
    return topController;
}

RCT_EXPORT_MODULE();

RCT_EXPORT_METHOD(addEvent:(NSString *)name location:(NSString *)location)
{
  RCTLogInfo(@"Pretending to create an event %@ at %@", name, location);
//  UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"提示" message:@"ZEROwolfHwang" preferredStyle:UIAlertControllerStyleAlert];
//  UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
//  [alertView addAction:cancelAction];
//
//  UIWindow *window = [UIApplication sharedApplication].keyWindow;
//  [window.rootViewController presentViewController:alertView animated:YES completion:nil];
//
}

RCT_EXPORT_METHOD(closeRN)
{
//    [[UnityIOSBridge sharedManager] setupUnity];
  RCTLogInfo(@"closeRN closeRN closeRN closeRN closeRN closeRN");
    dispatch_async(dispatch_get_main_queue(), ^{
        UnityPause(false);
        GetAppController().window.rootViewController = UnityGetGLViewController();
        
//        UIViewController * top = [self topMostController];
//        [top dismissViewControllerAnimated:YES completion:nil];
    });
}

@end
