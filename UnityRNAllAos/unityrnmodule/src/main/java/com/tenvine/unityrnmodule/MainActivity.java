package com.tenvine.unityrnmodule;

import android.Manifest;
import android.app.AlertDialog;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.os.Bundle;
import android.support.v4.app.ActivityCompat;
import android.util.Log;
import android.widget.Toast;

import com.unity3d.player.UnityPlayer;
import com.unity3d.player.UnityPlayerActivity;

import org.json.JSONException;
import org.json.JSONObject;

import java.io.FileOutputStream;
import java.io.InputStream;
import java.net.URL;
import java.net.URLConnection;

public class MainActivity extends UnityPlayerActivity {
    private static int  REQUEST_EXTERNAL_STORAGE = 101;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
    }

    public String showAlert(String _content) {
        runOnUiThread(new Runnable() {
            @Override
            public void run() {
                AlertDialog.Builder builder = new AlertDialog.Builder(MainActivity.this);
                builder.setTitle("from unity content").setMessage("content").setPositiveButton("OK", null);
                builder.show();
            }
        });

        CallUnity("我是Android");
        return "原生显示Alert";
    }

    public String transmitData(String str) {
//        return number1 + number2;
        Toast.makeText(this, str, Toast.LENGTH_SHORT).show();
        return "";
    }

    // 返回两个数相加的和
    public String addNumber(String numstr) {
        Log.i("zero", "addNumber: "+numstr);
        JSONObject jsonObject = null;
        try {
            jsonObject = new JSONObject(numstr);

        } catch (JSONException e) {
            e.printStackTrace();
        }
        int num1 = jsonObject.optInt("num1");
        int num2 = jsonObject.optInt("num2");
        return num1 + num2 + "";
    }

    public static void CallUnity(String _content) {
        UnityPlayer.UnitySendMessage("Main Camera", "GetDate", _content);
    }

    public String jumpToRegion(String str) {
        Intent intent = new Intent(MainActivity.this, RegionActivity.class);
        startActivity(intent);
        return "跳转原生界面成功";
    }

    public String jumpToRN(String str) {
        Intent intent = new Intent(MainActivity.this, RNActivity.class);
        startActivity(intent);
        return "跳转RN界面成功";
    }

    public String downJsBundle(String str) {
        down_outside();
        return "";
    }



    public void down_outside() {


        String[] PERMISSIONS_STORAGE = {
                Manifest.permission.READ_EXTERNAL_STORAGE,
                Manifest.permission.WRITE_EXTERNAL_STORAGE
        };

        int permission = ActivityCompat.checkSelfPermission(MainActivity.this, Manifest.permission.WRITE_EXTERNAL_STORAGE);

        if (permission != PackageManager.PERMISSION_GRANTED) {
            // We don't have permission so prompt the user
            ActivityCompat.requestPermissions(
                    MainActivity.this,
                    PERMISSIONS_STORAGE,
                    REQUEST_EXTERNAL_STORAGE
            );
        } else {
            //获取文件名
            downJsBundle();
        }
    }

    public void downJsBundle(){
        new Thread(new Runnable() {
            @Override
            public void run() {

                try {
                    URL myURL = new URL(Constants.jsBundleUrl);
                    URLConnection conn = myURL.openConnection();
                    conn.connect();
                    InputStream is = conn.getInputStream();
                    int fileSize = conn.getContentLength();//根据响应获取文件大小
                    if (fileSize <= 0) throw new RuntimeException("无法获知文件大小 ");
                    if (is == null) throw new RuntimeException("stream is null");
                    FileOutputStream fos = new FileOutputStream(Constants.jSBundleFile(MainActivity.this));
                    byte buf[] = new byte[1024];
                    int downLoadFileSize = 0;
                    do {
                        //循环读取
                        int numread = is.read(buf);
                        if (numread == -1) {
                            break;
                        }
                        fos.write(buf, 0, numread);
                        downLoadFileSize += numread;
                        int progress = (int) (downLoadFileSize * 100L / fileSize);

                        CallUnity(progress + "");

                        Log.i("DOWNLOAD", progress + "");
                        //更新进度条
                    } while (true);

                    Log.i("DOWNLOAD", "download success");
                    is.close();
                } catch (Exception ex) {
                    Log.e("DOWNLOAD", "error: " + ex.getMessage(), ex);
                }
            }
        }).start();
    }

    @Override
    public void onRequestPermissionsResult(int requestCode, String[] permissions, int[] grantResults) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults);
        Log.i("zero", "onRequestPermissionsResult: 请求权限返回");

        if (requestCode == REQUEST_EXTERNAL_STORAGE && hasAllPermissionsGranted(grantResults)) {
//            down_outside(sActivity, "");
            Log.i("zero", "onRequestPermissionsResult: 请求权限成功");
            downJsBundle();
        } else {
            Log.i("zero", "onRequestPermissionsResult: 请求权限失败");
        }
    }
    // 含有全部的权限
    private boolean hasAllPermissionsGranted(int[] grantResults) {
        for (int grantResult : grantResults) {
            if (grantResult == PackageManager.PERMISSION_DENIED) {
                return false;
            }
        }
        return true;
    }
}
