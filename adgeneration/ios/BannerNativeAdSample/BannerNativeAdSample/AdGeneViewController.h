//
//  AdGeneViewController.h
//  BannerNativeAdSample
//
//  Created by Hiraiwa, Kenichiro on 7/2/16.
//  Copyright © 2016 Hiraiwa, Kenichiro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ADG/ADGManagerViewController.h> //手順１

@interface AdGeneViewController : UIViewController<ADGManagerViewControllerDelegate>
@property (nonatomic, retain) ADGManagerViewController *adg; //手順2
@end
