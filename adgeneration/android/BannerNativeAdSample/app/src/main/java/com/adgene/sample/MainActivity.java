package com.adgene.sample;


import android.graphics.Color;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.util.Log;
import android.widget.LinearLayout;
import com.socdm.d.adgeneration.ADG;
import com.socdm.d.adgeneration.ADGConsts;
import com.socdm.d.adgeneration.ADGListener;


public class MainActivity extends AppCompatActivity {

    private ADG adg;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_ad_demo);
        LinearLayout ad_container = (LinearLayout) findViewById(R.id.ad_container);
        adg = new ADG(this); // インスタンス生成
        adg.setLocationId("10724"); // LocationIDセット

        adg.setAdBackGroundColor(Color.BLACK);

        adg.setAdFrameSize(ADG.AdFrameSize.SP); // サイズ指定
        adg.setAdListener(new AdListener()); // Listener定義

        // 推奨の設定
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
        public void onReceiveAd() {
            Log.d(_TAG, "onReceiveAd");
        }
        @Override
        public void onFailedToReceiveAd(ADGConsts.ADGErrorCode code) {
            Log.d(_TAG, "onFailedToReceiveAd");
            // 不通とエラー過多のとき以外はリトライ
            // エラー時のリトライは特段の理由がない限り必ず記述するようにしてください。
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
        @Override
        public void onOpenUrl() {
            Log.d(_TAG, "onOpenUrl");
        }
    }
}
