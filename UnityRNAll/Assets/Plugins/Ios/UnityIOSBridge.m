//
//  UnityIOSBridge.m
//  Unity-iPhone
//
//  Created by ZEROwolf Hwang on 2019/5/20.
//

#import "UnityIOSBridge.h"
#import "RegionViewController.h"
#import <React/RCTRootView.h>
#import "UnityAppController.h"

@interface UnityIOSBridge () <NSURLSessionDownloadDelegate>

@property(nonatomic,strong) NSString *progress;

@end




NSString *progressResult;

@implementation UnityIOSBridge


static UnityIOSBridge *sharedManager;

+ (UnityIOSBridge *)sharedManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (id)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}


- (NSString *)showAlert:(NSString *)content {
    
    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"提示" message:content preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
    [alertView addAction:cancelAction];
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window.rootViewController presentViewController:alertView animated:YES completion:nil];
    NSString *dateStr = @"Hello Word , 这边是ios原生的字符串";
    return dateStr;
}

- (NSString *)addNumber:(NSString *)content{
    NSLog(@"content%@",content);
    NSData *jsonData = [content dataUsingEncoding:NSUTF8StringEncoding];
         NSLog(@"jsonData = %@",jsonData);
    NSDictionary *retDict = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:NULL];
    
     NSLog(@"num1 = %@",retDict);
    
    int num1 = [[retDict objectForKey:@"num1"] intValue];
    int num2 = [[retDict objectForKey:@"num2"] intValue];
    
    NSLog(@"num1 = %d",num1);
    NSLog(@"num2 = %d",num2);
  
    int all = num1 + num2 ;
    return [NSString stringWithFormat:@"%d",all];
}
- (void)jumpToRegion{
    NSLog(@"Jump到原生界面");
    RegionViewController *vc1 = [[RegionViewController alloc]init];
    self.vc = vc1;
    NSLog(@"设置界面为IOS界面");
    
    GetAppController().window.rootViewController = vc1;
    
    GetAppController().window.rootViewController =self.vc;
    
}

- (void)jumpToRN{
    NSURL *jsCodeLocation;
    jsCodeLocation = [NSURL URLWithString:@"http://192.168.2.3:8081/index.bundle?platform=ios"];
    
    
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* path = [paths objectAtIndex:0];
    NSLog(@"the save version file's path is :%@",path);
    NSString* filePath = [path stringByAppendingPathComponent:REACT_NATIVE_JSBUNDLE_NAME];
    NSLog(@"the save version file's path is :%@", filePath);
    jsCodeLocation = [NSURL URLWithString:filePath];
    
    RCTRootView *rootView =[[RCTRootView alloc] initWithBundleURL: jsCodeLocation
                                                       moduleName: REACT_NATIVE_MODULE_NAME
                                                initialProperties:nil
                                                    launchOptions: nil];
    UIViewController *rnviewController = [[UIViewController alloc] init];
    rnviewController.view = rootView;
    
    self.vc = rnviewController;
    NSLog(@"设置界面为IOS  RN界面");
    
    GetAppController().window.rootViewController = rnviewController;
}

- (void)transmitData:(NSString *)content{
    NSLog(@"%@ -----",content);
}

/**
 * 点击按钮 -- 使用NSURLSession的delegate方法下载文件
 */
- (void)downJsBundle {
    NSURL* url = [NSURL URLWithString:REACT_NATIVE_JSBUNDLE_URL];
    //    NSURL* url = [NSURL URLWithString:@"http://cdn2.ime.sogou.com/c73d864c6581eb55df83884bc282ab43/5ceb5668/dl/index/1556421671/sogou_mac_53d.zip"];
    
    NSLog(@"%@",REACT_NATIVE_JSBUNDLE_URL);
    NSLog(@"%@",REACT_NATIVE_JSBUNDLE_NAME);
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDownloadTask *downloadTask = [session downloadTaskWithURL:url];
    [downloadTask resume];
}

#pragma mark <NSURLSessionDownloadDelegate> 实现方法
/**
 *  文件下载完毕时调用
 */
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)location
{
    // 文件将要移动到的指定目录
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    
    // 新文件路径
    NSString *newFilePath = [documentsPath stringByAppendingPathComponent:REACT_NATIVE_JSBUNDLE_NAME];
    
    NSLog(@"File downloaded to: %@",newFilePath);
    
    // 移动文件到新路径
    [[NSFileManager defaultManager] moveItemAtPath:location.path toPath:newFilePath error:nil];
    
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
      didWriteData:(int64_t)bytesWritten
 totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    NSString *progress = [NSString stringWithFormat:@"当前下载进度:%.2f%%",100.0 * totalBytesWritten / totalBytesExpectedToWrite];
    self.progress = progress;
    UnitySendMessage("Main Camera", "GetDate", [self.progress UTF8String]);
    NSLog(@"%@", self.progress);
}

/**
 *  恢复下载后调用
 */
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
 didResumeAtOffset:(int64_t)fileOffset
expectedTotalBytes:(int64_t)expectedTotalBytes
{
    
}

// 设置Unity界面
- (void)setupUnity
{
    UnityPause(false);
    GetAppController().window.rootViewController = UnityGetGLViewController();
    NSLog(@"设置rootView为Unity界面");
}

@end


#if defined(__cplusplus)
extern "C" {
#endif
    
    NSString *CStringToNSString(const char *string)
    {
        if (string)
        return [NSString stringWithUTF8String:string];
        else
        return [NSString stringWithUTF8String:""];
    }
    
    char *MakeStringCopy(const char *string)
    {
        if (string == NULL)
        return NULL;
        
        char *res = (char *)malloc(strlen(string) + 1);
        strcpy(res, string);
        return res;
    }
    
    const char* callIOSPlatformFunction(const char* functionName,const char* jsonContent){
        if (0 == strcmp(functionName,"showAlert")){
            NSLog(@"showAlert showAlert showAlert--------------");
            [[UnityIOSBridge sharedManager] showAlert:CStringToNSString(jsonContent)];
            
        }else if (0 == strcmp(functionName,"addNumber")){
            NSString *resultValue = [[UnityIOSBridge sharedManager] addNumber:CStringToNSString(jsonContent)];
            return  MakeStringCopy([resultValue UTF8String]);
            
        }else if(0 == strcmp(functionName,"transmitData")){
            [[UnityIOSBridge sharedManager] transmitData:CStringToNSString(jsonContent)];
            NSString *dateStr = @"Hello Word , 这边是ios原生的字符串";
            UnitySendMessage("Main Camera", "GetDate", [dateStr UTF8String]);
            
        }else if(0 == strcmp(functionName,"jumpToRegion")){
            UnityPause(true);
            [[UnityIOSBridge sharedManager] jumpToRegion];
            
        }else if (0 == strcmp(functionName,"downJsBundle")){
            [[UnityIOSBridge sharedManager] downJsBundle];
            
        }else if (0 == strcmp(functionName,"jumpToRN")){
             UnityPause(true);
            [[UnityIOSBridge sharedManager] jumpToRN];
        
        }
        return  MakeStringCopy([CStringToNSString(functionName) UTF8String]);
    }

#if defined(__cplusplus)
}

#endif


