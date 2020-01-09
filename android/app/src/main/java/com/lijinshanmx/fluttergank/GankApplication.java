package com.lijinshanmx.fluttergank;

import com.alibaba.sdk.android.feedback.impl.FeedbackAPI;
import com.lzy.okgo.OkGo;
import com.umeng.commonsdk.UMConfigure;

import io.flutter.app.FlutterApplication;

public class GankApplication extends FlutterApplication {
    @Override
    public void onCreate() {
        super.onCreate();
        OkGo.getInstance().init(this);
        FeedbackAPI.init(this, "25526201", "3e21df07840fb5c6f2fdf8c841dd2958");
        UMConfigure.init(this, "5c1dc3dcb465f537ea000d4d", "gank", UMConfigure.DEVICE_TYPE_PHONE, null);
    }
}
