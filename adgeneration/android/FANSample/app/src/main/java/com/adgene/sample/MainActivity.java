package com.adgene.sample;


import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;
// AdGeneration
import com.socdm.d.adgeneration.ADG;
import com.socdm.d.adgeneration.ADG.AdFrameSize;
import com.socdm.d.adgeneration.ADGConsts.ADGErrorCode;
import com.socdm.d.adgeneration.ADGListener;
// Facebook
import com.facebook.ads.NativeAd;
import com.facebook.ads.MediaView;
import com.facebook.ads.AdChoicesView;
import com.socdm.d.adgeneration.utils.DisplayUtils;
// その他標準のクラスを必要に応じて追加してください。


public class MainActivity extends AppCompatActivity {

    private ADG adg;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_ad_demo);
        LinearLayout ad_container = (LinearLayout) findViewById(R.id.ad_container);

        // 基本的にAdGenerationの通常広告と同様です
        adg = new ADG(this);
        final String testingId = "28612";
        adg.setLocationId(testingId); // AdGeneration広告枠ID
        adg.setAdFrameSize(AdFrameSize.FREE.setSize(300, 250)); // サイズ指定（タップ領域等に影響しますので、正しく指定してください）
        adg.setAdListener(new AdListener()); // Listener定義
        adg.setReloadWithVisibilityChanged(false);
        adg.setFillerRetry(false);

        // 表示
        ad_container.addView(adg);
    }

    @Override
    protected void onResume() {
        super.onResume();
        // 広告表示/ローテーション再開
        if (adg != null) {
            adg.start();
        }
    }
    @Override
    protected void onPause() {
        super.onPause();
        // ローテーション停止
        if (adg != null) {
            adg.pause();
        }
    }

    // Listener定義
    // エラー時のリトライは特段の理由がない限り必ず記述するようにしてください。
    class AdListener extends ADGListener {
        private static final String _TAG = "ADGListener";

        @Override
        public void onReceiveAd() { }

        @Override
        public void onReceiveAd(Object mediationNativeAd) {
            if (adg != null && mediationNativeAd instanceof NativeAd) {
                LayoutInflater inflater = getLayoutInflater();
                LinearLayout container = new LinearLayout(getBaseContext());
                LinearLayout layout = (LinearLayout) inflater.inflate(R.layout.nativead, container);

                NativeAd nativeAd = (NativeAd) mediationNativeAd;

                // 動画/静止画兼用のときはMediaViewを使用する
                // MediaViewはFANのSDKが提供している動画/静止画の出し分けを行うクラスとなります。
                MediaView mediaView = (MediaView) layout.findViewById(R.id.native_ad_cover_image);

                // 静止画のみのときはMediaViewではなくImageViewを使用する（XMLも要変更）
                // ImageView adCoverView = (ImageView) layout.findViewById(R.id.native_ad_cover_image);

                ImageView nativeIcon = (ImageView)layout.findViewById(R.id.native_icon);
                TextView titleView = (TextView) layout.findViewById(R.id.native_title);
                TextView nativeAdBody = (TextView) layout.findViewById(R.id.native_ad_body);
                TextView socialContext = (TextView) layout.findViewById(R.id.native_social_context);
                Button actionBtn = (Button) layout.findViewById(R.id.native_action_btn);
                RelativeLayout adChoiceContainer = (RelativeLayout) layout.findViewById(R.id.native_ad_choice_container);

                NativeAd.Image icon = nativeAd.getAdIcon();
                NativeAd.downloadAndDisplayImage(icon, nativeIcon);

                // Setting the TitleText
                String title = nativeAd.getAdTitle();
                title = title.length() > 14 ? title.substring(0, 14) + "..." : title;
                titleView.setText(title);

                //広告の説明文本文セット
                String description = nativeAd.getAdBody();
                //文字の長さを最大文字数で切る
                int MAX_LENGTH = 30;
                description = description.length() < MAX_LENGTH ? description : description.substring(0, MAX_LENGTH) + "...";

                nativeAdBody.setText(description);
                //〇〇人が利用中ですorドメインが表示される
                String socialText = nativeAd.getAdSocialContext() != null ? nativeAd.getAdSocialContext() : "";
                socialContext.setText(socialText);

                //インストールする などの文字をセット
                actionBtn.setText(nativeAd.getAdCallToAction());
                actionBtn.setVisibility(View.VISIBLE);

                // Downloading and setting the ad cover image.
                // 動画/静止画兼用のとき
                mediaView.setLayoutParams(new LinearLayout.LayoutParams(
                        DisplayUtils.getPixels(getResources(), 300),
                        DisplayUtils.getPixels(getResources(), 157)));
                mediaView.setNativeAd(nativeAd);

                // 静止画のみのとき
                /* NativeAd.Image adCoverImage = nativeAd.getAdCoverImage();
                adCoverView.setLayoutParams(new LinearLayout.LayoutParams(
                    DisplayUtils.getPixels(getResources(), 300),
                    DisplayUtils.getPixels(getResources(), 157)));
                NativeAd.downloadAndDisplayImage(adCoverImage, adCoverView); */

                // Set AdChoices View（FANの広告オプトアウトへの導線です）
                AdChoicesView adChoicesView = new AdChoicesView(MainActivity.this, nativeAd, true);
                adChoiceContainer.addView(adChoicesView);

                // クリック領域の指定。詳細はリファレンスのregisterViewForInteractionを参照。
                // https://developers.facebook.com/docs/reference/android/current/class/NativeAd/
                nativeAd.registerViewForInteraction(layout.findViewById(R.id.native_ad_container));

                // ViewのADGクラスインスタンスへのセット（ローテーション時等の破棄制御並びに表示のため）
                adg.addMediationNativeAdView(container);
            }
        }

        // 通常の広告と同様です
        @Override
        public void onFailedToReceiveAd(ADGErrorCode code) {
            // 不通とエラー過多のとき以外はリトライ
            switch (code) {
                case EXCEED_LIMIT:
                case NEED_CONNECTION:
                    break;
                default:
                    if (adg != null) {
                        adg.start();
                    }
                    break;
            }
        }
    }
}
