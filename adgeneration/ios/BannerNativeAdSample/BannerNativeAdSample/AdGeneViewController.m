//
//  AdGeneViewController.m
//  BannerNativeAdSample
//
//  Created by Hiraiwa, Kenichiro on 7/2/16.
//  Copyright © 2016 Hiraiwa, Kenichiro. All rights reserved.
//

#import "AdGeneViewController.h"

@interface AdGeneViewController ()

@property (weak, nonatomic) IBOutlet UIView *adView;

@end

@implementation AdGeneViewController

- (void)viewDidLoad
{
    //手順1
    NSDictionary *adgparam = @{
                               @"locationid" : @"10723", //管理画面から払い出された広告枠ID
                               @"adtype" : @(kADG_AdType_Sp), //枠サイズ(kADG_AdType_Sp：320x50, kADG_AdType_Large:320x100, kADG_AdType_Rect:300x250, kADG_AdType_Tablet:728x90, kADG_AdType_Free:自由設定)
                               @"originx" : @(0), //広告枠設置起点のx座標
                               @"originy" : @(0), //広告枠設置起点のy座標
                               @"w" : @(0), //広告枠横幅（kADG_AdType_Freeのとき有効）
                               @"h" : @(0)  //広告枠高さ（kADG_AdType_Freeのとき有効）
                               };
    ADGManagerViewController *adgvc = [[ADGManagerViewController alloc] initWithAdParams:adgparam adView:self.adView];// adViewには広告を表示する画面のUIViewインスタンスをセットする。
    self.adg = adgvc;

    _adg.delegate = self;
    [_adg setFillerRetry:NO];
    [_adg loadRequest]; // 手順2
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    // 手順3
    if(_adg){
        [_adg resumeRefresh];
    }
}

- (void) dealloc {
    // 手順4
    _adg.delegate = nil;
    _adg = nil;
}

// 手順5
- (void)ADGManagerViewControllerReceiveAd:(ADGManagerViewController *)adgManagerViewController
{
    NSLog(@"%@", @"ADGManagerViewControllerReceiveAd");
}

// エラー時のリトライは特段の理由がない限り必ず記述するようにしてください。
- (void)ADGManagerViewControllerFailedToReceiveAd:(ADGManagerViewController *)adgManagerViewController code:(kADGErrorCode)code {
    NSLog(@"%@", @"ADGManagerViewControllerFailedToReceiveAd");
    // 不通とエラー過多のとき以外はリトライ
    switch (code) {
        case kADGErrorCodeExceedLimit:
        case kADGErrorCodeNeedConnection:
            break;
        default:
            [adgManagerViewController loadRequest];
            break;
    }
}

- (void)ADGManagerViewControllerOpenUrl:(ADGManagerViewController *)adgManagerViewController{
    NSLog(@"%@", @"ADGManagerViewControllerOpenUrl");
}

@end
