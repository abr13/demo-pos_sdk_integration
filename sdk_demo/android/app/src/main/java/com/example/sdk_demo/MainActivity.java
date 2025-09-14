package com.example.sdk_demo;

import android.os.Bundle;
import android.util.Log;

import androidx.annotation.NonNull;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

public class MainActivity extends FlutterActivity implements MethodCallHandler, EventChannel.StreamHandler, SdkService.OnServiceConnectListener {
    private static final String CHANNEL = "com.example.sdk_demo/sdk";
    private static final String EVENT_CHANNEL = "com.example.sdk_demo/sdk_events";
    private static final String TAG = "MainActivity";

    private MethodChannel methodChannel;
    private EventChannel eventChannel;
    private EventChannel.EventSink eventSink;
    private SdkService sdkService;

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        
        // Initialize SDK Service
        sdkService = SdkService.instance;
        if (sdkService == null) {
            sdkService = new SdkService();
        }
        sdkService.registerServiceConnectListener(this);

        // Setup Method Channel
        methodChannel = new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL);
        methodChannel.setMethodCallHandler(this);

        // Setup Event Channel
        eventChannel = new EventChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), EVENT_CHANNEL);
        eventChannel.setStreamHandler(this);
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        Log.d(TAG, "Method called: " + call.method);
        
        switch (call.method) {
            case "initializeSdk":
                initializeSdk(result);
                break;
            case "getDeviceInfo":
                getDeviceInfo(result);
                break;
            case "testCardReader":
                testCardReader(result);
                break;
            case "testPrinter":
                testPrinter(result);
                break;
            case "testEMV":
                testEMV(result);
                break;
            case "disconnectSdk":
                disconnectSdk(result);
                break;
            default:
                result.notImplemented();
                break;
        }
    }

    private void initializeSdk(Result result) {
        try {
            if (sdkService != null) {
                sdkService.connectPayService(false);
                result.success("SDK initialization started - checking for Z500C hardware service...\n" +
                              "Note: Service not found is expected on non-Z500C devices");
            } else {
                result.error("SDK_ERROR", "SDK service not available", null);
            }
        } catch (Exception e) {
            result.error("SDK_ERROR", "Failed to initialize SDK: " + e.getMessage(), null);
        }
    }

    private void getDeviceInfo(Result result) {
        try {
            if (sdkService != null) {
                String info = sdkService.getDeviceInfo();
                result.success(info);
            } else {
                result.error("SDK_ERROR", "SDK service not available", null);
            }
        } catch (Exception e) {
            result.error("SDK_ERROR", "Failed to get device info: " + e.getMessage(), null);
        }
    }

    private void testCardReader(Result result) {
        try {
            if (sdkService != null) {
                String testResult = sdkService.testCardReader();
                result.success(testResult);
            } else {
                result.error("SDK_ERROR", "SDK service not available", null);
            }
        } catch (Exception e) {
            result.error("SDK_ERROR", "Failed to test card reader: " + e.getMessage(), null);
        }
    }

    private void testPrinter(Result result) {
        try {
            if (sdkService != null) {
                String testResult = sdkService.testPrinter();
                result.success(testResult);
            } else {
                result.error("SDK_ERROR", "SDK service not available", null);
            }
        } catch (Exception e) {
            result.error("SDK_ERROR", "Failed to test printer: " + e.getMessage(), null);
        }
    }

    private void testEMV(Result result) {
        try {
            if (sdkService != null) {
                String testResult = sdkService.testEMV();
                result.success(testResult);
            } else {
                result.error("SDK_ERROR", "SDK service not available", null);
            }
        } catch (Exception e) {
            result.error("SDK_ERROR", "Failed to test EMV: " + e.getMessage(), null);
        }
    }

    private void disconnectSdk(Result result) {
        try {
            if (sdkService != null) {
                sdkService.disconnectPayService();
                result.success("SDK disconnected");
            } else {
                result.error("SDK_ERROR", "SDK service not available", null);
            }
        } catch (Exception e) {
            result.error("SDK_ERROR", "Failed to disconnect SDK: " + e.getMessage(), null);
        }
    }

    @Override
    public void onServiceConnect() {
        Log.d(TAG, "SDK service connected");
        if (eventSink != null) {
            eventSink.success("SDK_CONNECTED");
        }
    }

    @Override
    public void onListen(Object arguments, EventChannel.EventSink events) {
        Log.d(TAG, "Event channel listener attached");
        eventSink = events;
    }

    @Override
    public void onCancel(Object arguments) {
        Log.d(TAG, "Event channel listener cancelled");
        eventSink = null;
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        if (sdkService != null) {
            sdkService.unregisterServiceConnectListener(this);
        }
    }
}
