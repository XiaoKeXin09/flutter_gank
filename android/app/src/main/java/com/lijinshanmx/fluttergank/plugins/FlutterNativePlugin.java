package com.lijinshanmx.fluttergank.plugins;

import android.app.Activity;
import android.text.TextUtils;

import com.alibaba.sdk.android.feedback.impl.FeedbackAPI;
import com.lijinshanmx.fluttergank.activity.MainActivity;
import com.lijinshanmx.fluttergank.utils.GankUtils;
import com.vector.update_app.UpdateAppBean;
import com.vector.update_app.UpdateAppManager;
import com.vector.update_app.UpdateCallback;
import com.vector.update_app.utils.AppUpdateUtils;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;


/**
 * FlutterNativePlugin
 */
public class FlutterNativePlugin implements MethodChannel.MethodCallHandler {
    public static String CHANNEL = "com.lijnshanmx/FlutterNativePlugin";
    private MainActivity mainActivity;

    private FlutterNativePlugin(Activity activity) {
        mainActivity = (MainActivity) activity;
    }

    /**
     * Plugin registration.
     */
    public static void registerWith(PluginRegistry.Registrar registrar) {
        final MethodChannel channel = new MethodChannel(registrar.messenger(), CHANNEL);
        channel.setMethodCallHandler(new FlutterNativePlugin(registrar.activity()));
    }

    @Override
    public void onMethodCall(MethodCall call, final MethodChannel.Result result) {
        if (call.method.equals("checkupdate")) {
            mainActivity.checkUpdate(new UpdateCallback() {
                @Override
                protected void hasNewApp(UpdateAppBean updateApp, UpdateAppManager updateAppManager) {
                    super.hasNewApp(updateApp, updateAppManager);
                    result.success(true);
                }

                @Override
                protected void noNewApp(String error) {
                    result.success(false);
                }

            });
        } else if (call.method.equals("getversion")) {
            result.success(AppUpdateUtils.getVersionName(mainActivity));
        } else if (call.method.equals("openFeedbackActivity")) {
            FeedbackAPI.openFeedbackActivity();
            result.success("Success");
        } else if (call.method.equals("oAuthInBrowser")) {
            String url = call.argument("url");
            if (!TextUtils.isEmpty(url)) {
                GankUtils.openInBrowser(mainActivity, url);
            }
        } else {
            result.notImplemented();
        }
    }
}
