using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.Runtime.InteropServices;
using System;

public class PlatformUtil
{

    #if UNITY_IOS && !UNITY_EDITOR
    [DllImport("__Internal")]
    static extern string callIOSPlatformFunction(string functionName,string jsonContent);
    #endif

    static PlatformUtil instance;
    public static PlatformUtil GetInstance()
    {
        if (instance == null)
        {
            instance = new PlatformUtil();
        }
        return instance;
    }

    public string CallPlatformFunction(string functionName, string jsonContent)
    {
        string value = "";
#if UNITY_ANDROID && !UNITY_EDITOR
         AndroidJavaClass m_Jc = new AndroidJavaClass("com.unity3d.player.UnityPlayer");
         AndroidJavaObject   m_Jo = m_Jc.GetStatic<AndroidJavaObject>("currentActivity");
         value =  m_Jo.Call<string>(functionName,jsonContent);
#elif UNITY_IOS && !UNITY_EDITOR
        value = callIOSPlatformFunction(functionName,jsonContent);
#endif
        return value;
    }
}

