
using UnityEngine;
using System.Runtime.InteropServices;

public class Main : MonoBehaviour
{
  
    public static string labelValue = "初始labelValue的值";

    private PlatformUtil _instance;

    void Start()
    {
        _instance = PlatformUtil.GetInstance();
    }

    void Update()
    {

    }

    void OnGUI()
    {
  

        var fontStyle = new GUIStyle
        {
            alignment = TextAnchor.MiddleCenter,
            fontSize = 45
        };
        fontStyle.normal.textColor = Color.white;

      

        if (GUI.Button(new Rect(50, 140, 220, 160), "showAlert",fontStyle))
        {
            string resultValue = _instance.CallPlatformFunction("showAlert", "Unity发送给原生的Alert");
            labelValue = resultValue;
        }
        if (GUI.Button(new Rect(450, 140, 220,160), "addNumber",fontStyle))
        {
            string resultValue = _instance.CallPlatformFunction("addNumber", "{\"num1\":10,\"num2\":21}");
            labelValue = resultValue;
        }

        if (GUI.Button(new Rect(850, 140, 220, 160), "transmitData", fontStyle))
        {
            string resultValue = _instance.CallPlatformFunction("transmitData", "从Unity传递给原生的数据");
            labelValue = resultValue;
        }

        if (GUI.Button(new Rect(50, 340, 220, 160), "jumpToRegion", fontStyle))
        {
            string resultValue = _instance.CallPlatformFunction("jumpToRegion", "");
            labelValue = resultValue;
        }

        if (GUI.Button(new Rect(450, 340, 220, 160), "downJsBundle", fontStyle))
        {
           string resultValue = _instance.CallPlatformFunction("downJsBundle", "");
            labelValue = resultValue;
        }


        if (GUI.Button(new Rect(850, 340, 220, 160), "jumpToRN", fontStyle))
        {
            string resultValue = _instance.CallPlatformFunction("jumpToRN", "");
            labelValue = resultValue;
        }
   
        var TextStyle = new GUIStyle();
        TextStyle.normal.textColor = Color.red;
        TextStyle.fontSize = 80;
        GUI.Label(new Rect(50, 740, 800, 600), labelValue, TextStyle);
    }

    public void GetDate(string date)
    {
        labelValue = date;
    }
}
