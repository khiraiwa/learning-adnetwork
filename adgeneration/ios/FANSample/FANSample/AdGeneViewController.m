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
    // 基本的にAdGenerationの通常広告と同様ですが、addChildViewControllerのみNativeAd固有です。
    NSDictionary *adgparam = @{
                               @"locationid" : @"28613", // AdGeneration広告枠ID
                               @"adtype" : @(kADG_AdType_Free),
                               @"originx" : @(0),
                               @"originy" : @(20),
                               @"w":@(300),//横幅
                               @"h":@(250)//縦幅
                               };
    _adg = [[ADGManagerViewController alloc] initWithAdParams:adgparam adView:self.adView];
    [_adg setBackGround:[UIColor whiteColor] opaque:YES];
    _adg.delegate = self;
    _adg.rootViewController = self;
    
    // FANの広告はタップ時に親のViewControllerを基準として処理を行う。
    // その処理を正常に動作させるため、addChildViewControllerによって画面を親のViewControllerに指定する。
    [self addChildViewController:self.adg];
    
    [_adg setFillerRetry:NO];
}

- (void) dealloc {
    // 手順4
    _adg.rootViewController = nil;
    _adg.delegate = nil;
    _adg = nil;
    _nativeAd = nil;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    // ローテーション再開
    if(_adg)
    {
        [_adg resumeRefresh];
    }
}
- (void) viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    // ローテーション停止
    if(_adg)
    {
        [_adg pauseRefresh];
    }
}

// 手順5
- (void)ADGManagerViewControllerReceiveAd:(ADGManagerViewController *)adgManagerViewController mediationNativeAd:(id)mediationNativeAd {
    // FBNativeAdクラスか確認
    if ([mediationNativeAd isKindOfClass:[FBNativeAd class]]) {
        if (self.nativeAd) {
            [self.nativeAd unregisterView];
        }
        
        FBNativeAd *nativeAd = (FBNativeAd *) mediationNativeAd;
        self.nativeAd = nativeAd;
        
        //アイコン
        NSData *iconImageData = [NSData dataWithContentsOfURL:nativeAd.icon.url];
        UIImage *iconImage = [UIImage imageWithData:iconImageData];
        UIImageView *iconImageView = [[UIImageView alloc] init];
        iconImageView.frame = CGRectMake(4, 4, 30 ,30);
        iconImageView.image = iconImage;
        
        //タイトル
        UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(38, 4, 180, 15)];
        [titleLbl setNumberOfLines:1];
        [titleLbl setFont:[titleLbl.font fontWithSize:15]];
        [titleLbl setText: nativeAd.title];
        
        //広告マーク
        UILabel *adTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(38, 20, 28, 14)];
        adTextLabel.layer.cornerRadius =5;
        adTextLabel.clipsToBounds = true;
        adTextLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        adTextLabel.textAlignment = NSTextAlignmentCenter;
        adTextLabel.textColor = [UIColor whiteColor];
        [adTextLabel setFont:[adTextLabel.font fontWithSize:10]];
        [adTextLabel setText:@"広告"];
        [adTextLabel setBackgroundColor:[UIColor colorWithRed:0.827 green:0.827 blue:0.827 alpha:1.0]];
        
        
        
        //カバーイメージ
        //動画/静止画兼用のときはFBMediaViewを使用する
        //FBMediaViewはFANのSDKが提供している動画/静止画の出し分けを行うクラスとなります。
        FBMediaView *coverImageView = [[FBMediaView alloc] initWithFrame:CGRectMake(4, 40 , 292 , 156)];
        [coverImageView setNativeAd:nativeAd];
        
        //静止画のみのコードイメージ
        //静止画のみのときはnativeAd.coverImage.urlを元にUIImageを生成する
        /*NSData *coverImageData = [NSData dataWithContentsOfURL:nativeAd.coverImage.url];
         UIImage *coverImage = [UIImage imageWithData:coverImageData];
         UIImageView *coverImageView = [[UIImageView alloc] init];
         coverImageView.frame = CGRectMake(0, 0 , 300 , 156);
         coverImageView.image = coverImage;*/
        
        //adBody
        UILabel *description = [[UILabel alloc] initWithFrame:CGRectMake(4, 198, 172, 40)];
        [description setNumberOfLines:2];
        [description setFont: [description.font fontWithSize:14]];
        [description setText:nativeAd.body];
        description.textColor = [UIColor lightGrayColor];
        
        //social
        UILabel *socialLbl = [[UILabel alloc] initWithFrame:CGRectMake(4, 232, 150, 20)];
        [socialLbl setNumberOfLines:1];
        UIFont *socialFont = socialLbl.font;
        socialFont = [socialFont fontWithSize:12];
        [socialLbl setFont:socialFont];
        [socialLbl setTextColor:[UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1.0]];
        [socialLbl setText:nativeAd.socialContext];
        
        //ボタン
        UIButton *actionBtn = [[UIButton alloc] initWithFrame:CGRectMake(178 , 216 , 114 , 25)];
        [actionBtn setTitle:nativeAd.callToAction forState:UIControlStateNormal];
        [actionBtn setTitleColor:[UIColor colorWithRed:0.12 green:0.56 blue:1.00 alpha:1.0] forState:UIControlStateNormal];
        [actionBtn setBackgroundColor:[UIColor whiteColor]];
        [actionBtn.titleLabel setFont: [UIFont boldSystemFontOfSize:14]];
        actionBtn.layer.borderWidth = 1.0f;
        actionBtn.layer.borderColor = [[UIColor colorWithRed:0.12 green:0.56 blue:1.00 alpha:1.0] CGColor];
        actionBtn.layer.cornerRadius = 5.0f;
        actionBtn.titleEdgeInsets = UIEdgeInsetsMake(1.0f, 1.0f, 1.0f, 1.0f);
        
        //AdChoices（FANの広告オプトアウトへの導線です）
        FBAdChoicesView *adChoices = [[FBAdChoicesView alloc] initWithNativeAd:nativeAd];
        [adChoices setBackgroundShown:YES];
        
        UIView *nativeAdView = [[UIView alloc] initWithFrame:CGRectMake(0,0,300,250)];
        [nativeAdView addSubview:iconImageView];
        [nativeAdView addSubview:coverImageView];
        [nativeAdView addSubview:titleLbl];
        [nativeAdView addSubview:adTextLabel];
        [nativeAdView addSubview:actionBtn];
        [nativeAdView addSubview:socialLbl];
        [nativeAdView addSubview:description];
        [nativeAdView addSubview:adChoices];
        [adChoices updateFrameFromSuperview:UIRectCornerTopRight];// AdChoices位置指定
        
        // クリック領域の指定。詳細はリファレンスのregisterViewForInteractionを参照。
        // https://developers.facebook.com/docs/reference/ios/current/class/FBNativeAd/
        NSArray *clickableViews = @[coverImageView, titleLbl , actionBtn , socialLbl];
        [nativeAd registerViewForInteraction:nativeAdView withViewController:self withClickableViews:clickableViews];
        
        // ViewのADGManagerViewControllerクラスインスタンスへのセット（ローテーション時等の破棄制御並びに表示のため）
        [adgManagerViewController addMediationNativeAdView:nativeAdView];
    }
}

// 通常の広告と同様です
- (void)ADGManagerViewControllerFailedToReceiveAd:(ADGManagerViewController *)adgManagerViewController code:(kADGErrorCode)code {
    NSLog(@"%@", @"ADGManagerViewControllerFailedToReceiveAd secondView");
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

@end
