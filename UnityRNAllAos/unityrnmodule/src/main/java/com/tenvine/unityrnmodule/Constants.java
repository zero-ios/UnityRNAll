package com.tenvine.unityrnmodule;

import android.content.Context;
import android.os.Environment;

public class Constants {

    public static String appModuleName = "PureRN0586";

    public static String jsBundleUrl = "http://pqr6njf9n.bkt.clouddn.com/bundle/unityRN.jsbundle";

    public static String fileName = jsBundleUrl.substring(jsBundleUrl.lastIndexOf("/") + 1);

    public static String filePath_out = Environment.getExternalStorageDirectory().getAbsolutePath() + "/" + fileName;


    public static String filePath_inner(Context context) {
        return context.getFilesDir().getAbsolutePath() + "/" + fileName;
    }

    public static String jSBundleFile(Context context) {
        return filePath_inner(context);
    }



}
