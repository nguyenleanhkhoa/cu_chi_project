package com.triviet.cuchi;

import android.content.pm.ActivityInfo;
import android.content.pm.PackageManager;
import android.os.Bundle;
import android.os.PersistableBundle;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import java.util.Map;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;
import io.flutter.view.FlutterView;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "com.triviet.home/home";
    private static String GOOGLE_MAP_API_KEY = "";

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
    }

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        new MethodChannel(getFlutterEngine().getDartExecutor().getBinaryMessenger(), CHANNEL).setMethodCallHandler(new MethodChannel.MethodCallHandler() {
            @Override
            public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
                final Map<String, Object> env = call.arguments();
                if (call.method.equals("init")) {

                    GOOGLE_MAP_API_KEY = (String) env.get("GOOGLE_MAP_KEY");
                    try {
                        ActivityInfo ai = getPackageManager().getActivityInfo(getActivity().getComponentName(), PackageManager.GET_META_DATA);
                        ai.metaData.putString("com.google.android.geo.API_KEY", GOOGLE_MAP_API_KEY);
                    } catch (PackageManager.NameNotFoundException e) {
                        e.printStackTrace();
                    }
                }
//
//                    result.success("complete java code");
            }
        });
    }


}

