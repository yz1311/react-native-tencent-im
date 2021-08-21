
package com.reactlibrary.bugly;

import android.content.Context;
import android.graphics.drawable.Drawable;
import android.os.Environment;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.Callback;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.ReadableMapKeySetIterator;
import com.facebook.react.bridge.ReadableType;
import com.facebook.react.bridge.WritableArray;
import com.facebook.react.bridge.WritableMap;
import com.tencent.bugly.Bugly;
import com.tencent.bugly.beta.Beta;
import com.tencent.bugly.beta.UpgradeInfo;
import com.tencent.bugly.crashreport.BuglyLog;
import com.tencent.bugly.crashreport.CrashReport;

import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

public class RNBuglyModule extends ReactContextBaseJavaModule {

  private final ReactApplicationContext reactContext;

  public RNBuglyModule(ReactApplicationContext reactContext) {
    super(reactContext);
    this.reactContext = reactContext;
  }

  @Override
  public String getName() {
    return "RNBugly";
  }

  //初始化(自动检查更新)
  public static void init(Context context,String appId,boolean isDebug) {
    Bugly.init(context,appId,isDebug);
  }

  //初始化(不自动检查更新)
  public static void initWithoutAutoCheckUpgrade(Context context,String appId,boolean isDebug) {
    Beta.autoCheckUpgrade = false;
    Bugly.init(context,appId,isDebug);
  }

  private int getResourceId(String sourceName,String typeName) {
    Context ctx = getCurrentActivity().getApplicationContext();
    int resId = getCurrentActivity().getResources().getIdentifier(sourceName, typeName, ctx.getPackageName());
    //如果没找到,将会返回0
    return resId;
  }

  @ReactMethod
  public void init(ReadableMap map, Promise promise) {
    int upgradeCheckPeriod = 0;
    if(map.hasKey("upgradeCheckPeriod")) {
      upgradeCheckPeriod = map.getInt("upgradeCheckPeriod");
    }
    Beta.upgradeCheckPeriod = upgradeCheckPeriod;

    boolean showInterruptedStrategy = true;
    if(map.hasKey("showInterruptedStrategy")) {
      showInterruptedStrategy = map.getBoolean("showInterruptedStrategy");
    }
    Beta.showInterruptedStrategy = showInterruptedStrategy;

    boolean enableNotification = true;
    if(map.hasKey("enableNotification")) {
      enableNotification = map.getBoolean("enableNotification");
    }
    Beta.enableNotification = enableNotification;

    boolean autoDownloadOnWifi = false;
    if(map.hasKey("autoDownloadOnWifi")) {
      autoDownloadOnWifi = map.getBoolean("autoDownloadOnWifi");
    }
    Beta.autoDownloadOnWifi = autoDownloadOnWifi;

    boolean canShowApkInfo = true;
    if(map.hasKey("canShowApkInfo")) {
      canShowApkInfo = map.getBoolean("canShowApkInfo");
    }
    Beta.canShowApkInfo = canShowApkInfo;

    boolean autoCheckAppUpgrade = true;
    if(map.hasKey("autoCheckAppUpgrade")) {
      autoCheckAppUpgrade = map.getBoolean("autoCheckAppUpgrade");
    }
    Beta.autoCheckAppUpgrade = autoCheckAppUpgrade;

    int largeIconId = 0;
    if(map.hasKey("largeIconName")) {
      largeIconId = getResourceId(map.getString("largeIconName"),"drawable");
    }
    int smallIconId = 0;
    if(map.hasKey("smallIconName")) {
      smallIconId = getResourceId(map.getString("smallIconName"),"drawable");
    }
    int defaultBannerId = 0;
    if(map.hasKey("defaultBannerName")) {
      defaultBannerId = getResourceId(map.getString("defaultBannerName"),"drawable");
    }
    int upgradeDialogLayoutId = 0;
    if(map.hasKey("upgradeDialogLayoutName")) {
      upgradeDialogLayoutId = getResourceId(map.getString("upgradeDialogLayoutName"),"layout");
    }
    int tipsDialogLayoutId = 0;
    if(map.hasKey("tipsDialogLayoutName")) {
      tipsDialogLayoutId = getResourceId(map.getString("tipsDialogLayoutName"),"layout");
    }
    //由于是js端进行初始化，不必延时，将默认的3s改为0
    Beta.initDelay = 0;
    if(largeIconId>0) {
      Beta.largeIconId = largeIconId;
    }
    if(smallIconId>0) {
      Beta.smallIconId = smallIconId;
    }
    if(defaultBannerId>0) {
      Beta.defaultBannerId = defaultBannerId;
    }
    if(upgradeDialogLayoutId>0) {
      Beta.upgradeDialogLayoutId = upgradeDialogLayoutId;
    }
    if(tipsDialogLayoutId>0) {
      Beta.tipsDialogLayoutId = tipsDialogLayoutId;
    }
    String appId = "";
    if(map.hasKey("appId")) {
      appId = map.getString("appId");
    }
    if(appId==null || appId.equals("")) {
      promise.reject("0","appId不能为空");
      return;
    }
    try {
      Bugly.init(getReactApplicationContext(),appId,false);
      promise.resolve(true);
    } catch (Exception e) {
      promise.reject("-1",e.getMessage());
    }
  }

  @ReactMethod
  public void setUserId(String userID) {
    CrashReport.setUserId(userID);
  }

  @ReactMethod
  public void setAppChannel(String appChannel) {
    CrashReport.setAppChannel(getReactApplicationContext(), appChannel);
  }

  @ReactMethod
  public void setAppVersion(String version) {
    CrashReport.setAppVersion(getReactApplicationContext(), version);
  }

  @ReactMethod
  public void setAppPackage(String appPackage) {
    CrashReport.setAppPackage(getReactApplicationContext(), appPackage);
  }

  @ReactMethod
  public void setUserSceneTag(int tagId) {
    CrashReport.setUserSceneTag(getReactApplicationContext(), tagId);
  }

  @ReactMethod
  public void startCrashReport() {
    CrashReport.startCrashReport();
  }

  @ReactMethod
  public void closeCrashReport() {
    CrashReport.closeCrashReport();
  }

  @ReactMethod
  public void getCurrentTag(final Promise promise) {
    promise.resolve(CrashReport.getUserSceneTagId(getReactApplicationContext()));
  }

  @ReactMethod
  public void getUserData(final Promise promise) {
    Set<String> keys = CrashReport.getAllUserDataKeys(getReactApplicationContext());
    Iterator iterator =  keys.iterator();
    WritableMap map = Arguments.createMap();
    while (iterator.hasNext()) {
      String key = (String)iterator.next();
      map.putString(key, CrashReport.getUserData(getReactApplicationContext(), key));
    }
    promise.resolve(map);
  }

  @ReactMethod
  public void getBuglyVersion(final Promise promise) {
    promise.resolve(CrashReport.getBuglyVersion(getReactApplicationContext()));
  }

  @ReactMethod
  public void putUserData(String userKey, String userValue, Promise promise) {
    try
    {
      CrashReport.putUserData(this.reactContext,userKey,userValue);
      promise.resolve(true);
    }catch (Exception e)
    {
      promise.resolve(e.getMessage());
    }
  }

  @ReactMethod
  public void postException(ReadableMap map, Promise promise) {

    try
    {
      int category = map.getInt("category");
      String errorType = map.getString("errorType");
      String errorMsg = map.getString("errorMsg");
      String stack = "";
      if(map.hasKey("stack"))
      {
        stack = map.getString("stack");
      }
      Map<String,String> extra = new HashMap<String, String>();
      if(map.hasKey("extraInfo"))
      {
        ReadableMap extraInfo = map.getMap("extraInfo");
        ReadableMapKeySetIterator iterator = extraInfo.keySetIterator();
        while (iterator.hasNextKey()){
          String key = iterator.nextKey();
          extra.put(key, map.getString(key));
        }
      }
      CrashReport.postException(category,errorType,errorMsg,stack,extra);
      promise.resolve(true);
    }catch (Exception e)
    {
      promise.resolve(e.getMessage());
    }
  }

  @ReactMethod
  public void log(String level,String tag,String log) {
    switch (level)
    {
      case "v":
        BuglyLog.v(tag,log);
        break;
      case "d":
        BuglyLog.d(tag,log);
        break;
      case "i":
        BuglyLog.i(tag,log);
        break;
      case "w":
        BuglyLog.w(tag,log);
        break;
      case "e":
        BuglyLog.e(tag,log);
        break;
    }
  }

  @ReactMethod
  public void checkUpgrade(ReadableMap options) {
    //用户手动点击检查，非用户点击操作请传false
    boolean isManual = true;
    //是否显示弹窗等交互，[true:没有弹窗和toast] [false:有弹窗或toast]
    boolean isSilence = false;
    if(options.hasKey("isManual"))
    {
      isManual = options.getBoolean("isManual");
    }
    if(options.hasKey("isSilence"))
    {
      isSilence = options.getBoolean("isSilence");
    }
    Beta.checkUpgrade(isManual,isSilence);
  }

  @ReactMethod
  public void getUpgradeInfo(Promise promise) {

    UpgradeInfo info = Beta.getUpgradeInfo();
    if(info!=null)
    {
      WritableMap writableMap = Arguments.createMap();
      writableMap.putString("apkMd5",info.apkMd5);
      writableMap.putString("apkUrl",info.apkUrl);
      writableMap.putString("id",info.id);
      writableMap.putString("imageUrl",info.imageUrl);
      writableMap.putString("newFeature",info.newFeature);
      writableMap.putString("title",info.title);
      writableMap.putString("versionName",info.versionName);
      writableMap.putDouble("fileSize",info.fileSize);
      //弹窗间隔（ms）
      writableMap.putDouble("popInterval",info.popInterval);
      //弹窗次数:
      writableMap.putInt("popTimes",info.popTimes);
      //发布类型（0:测试 1:正式）:
      writableMap.putInt("publishType",info.publishType);
      writableMap.putInt("updateType",info.updateType);
      //弹窗类型（1:建议 2:强制 3:手工）:
      writableMap.putInt("upgradeType",info.upgradeType);
      writableMap.putInt("versionCode",info.versionCode);
      writableMap.putDouble("publishTime",info.publishTime);
      promise.resolve(writableMap);
    }
    promise.resolve(null);
  }
}
