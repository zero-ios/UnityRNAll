package com.tenvine.unityrnmodule;

import android.content.Intent;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.view.View;

public class RegionActivity extends AppCompatActivity {
    public static String jsBundleUrl = "http://pqr6njf9n.bkt.clouddn.com/bundle/unityRN.jsbundle";
    private static int  REQUEST_EXTERNAL_STORAGE = 101;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_region);


        findViewById(R.id.regionBtn).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                finish();
            }
        });
        findViewById(R.id.jumpRN).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                startActivity(new Intent(RegionActivity.this, RNActivity.class));
            }
        });

    }
}
