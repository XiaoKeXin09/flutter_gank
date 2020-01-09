package com.lijinshanmx.fluttergank.activity;

import android.content.Intent;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.os.Environment;

import com.lijinshanmx.fluttergank.plugins.FlutterNativePlugin;
import com.lijinshanmx.fluttergank.utils.OkGoUpdateHttpUtil;
import com.vector.update_app.UpdateAppManager;
import com.vector.update_app.UpdateCallback;
import com.vector.update_app.utils.AppUpdateUtils;

import java.util.HashMap;
import java.util.Map;

import io.flutter.plugin.common.BasicMessageChannel;
import io.flutter.plugin.common.StringCodec;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterFragmentActivity {
    final String PUSH_CHANNEL = "com.lijnshanmx/OAuthPush";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            getWindow().setStatusBarColor(0);
        }
        GeneratedPluginRegistrant.registerWith(this);
        FlutterNativePlugin.registerWith(registrarFor(FlutterNativePlugin.CHANNEL));
    }

    @Override
    protected void onNewIntent(Intent intent) {
        super.onNewIntent(intent);
        Uri uri = intent.getData();
        if (uri != null) {
            String code = uri.getQueryParameter("code");
            String state = uri.getQueryParameter("state");
            BasicMessageChannel messageChannel = new BasicMessageChannel<>(getFlutterView(), PUSH_CHANNEL, StringCodec.INSTANCE);
            messageChannel.send("{\"code\":\"" + code + "\",\"state\":\"" + state + "\"}");
        }
    }

    public void checkUpdate(UpdateCallback updateCallback) {
        String path = Environment.getExternalStorageDirectory().getAbsolutePath();
        Map<String, String> params = new HashMap<>();

        params.put("appKey", "ab5dce55Ac4bcW408cPb8c2Aaeac179c5f6g");
        params.put("version", AppUpdateUtils.getVersionName(this));

        new UpdateAppManager
                .Builder()
                .setActivity(this)
                .setHttpManager(new OkGoUpdateHttpUtil())
                .setUpdateUrl("https://gank.io/api/checkversion")
                .setPost(true)
                .setParams(params)
                .setTargetPath(path)
                .dismissNotificationProgress()
                .build()
                .checkNewApp(updateCallback);
    }
}
