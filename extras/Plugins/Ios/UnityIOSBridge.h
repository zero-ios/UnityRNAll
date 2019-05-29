//
//  UnityIOSBridge.h
//  Unity-iPhone
//
//  Created by ZEROwolf Hwang on 2019/5/20.
//

#define REACT_NATIVE_JSBUNDLE_URL  @"http://pqr6njf9n.bkt.clouddn.com/bundle/unityRN.jsbundle"
#define REACT_NATIVE_JSBUNDLE_NAME  [[REACT_NATIVE_JSBUNDLE_URL componentsSeparatedByString:@"/"] lastObject]
#define REACT_NATIVE_MODULE_NAME @"PureRN0586"

#import <Foundation/Foundation.h>

@interface UnityIOSBridge : NSObject

+ (UnityIOSBridge *)sharedManager;

- (NSString *)showAlert:(NSString *)content;
- (NSString *)addNumber:(NSString *)content;
- (void)jumpToRegion:(NSString *)content;
- (void)jumpToRN:(NSString *)content;
- (void)transmitData:(NSString *)content;
- (void)downJsBundle:(NSString *)content;

@property (nonatomic, strong) UIViewController *vc;
- (void)setupUnity;

@end

