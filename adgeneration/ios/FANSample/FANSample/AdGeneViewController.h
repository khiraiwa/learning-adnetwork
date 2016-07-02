//
//  AdGeneViewController.h
//  BannerNativeAdSample
//
//  Created by Hiraiwa, Kenichiro on 7/2/16.
//  Copyright © 2016 Hiraiwa, Kenichiro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ADG/ADGManagerViewController.h> //手順１
#import <ADG/ADGManagerViewController.h> // ADGインポート
#import <FBAudienceNetwork/FBAdSettings.h> // FB import for test
#import <FBAudienceNetwork/FBNativeAd.h> // FB import
#import <FBAudienceNetwork/FBAdChoicesView.h> // FB import
#import <FBAudienceNetwork/FBMediaView.h> // FB import

@interface AdGeneViewController : UIViewController<ADGManagerViewControllerDelegate>
@property (nonatomic, retain) ADGManagerViewController *adg; //手順2
@property (retain, nonatomic) FBNativeAd *nativeAd; // FBNativeAd
@end
