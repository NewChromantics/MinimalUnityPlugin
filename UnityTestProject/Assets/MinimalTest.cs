using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.Runtime.InteropServices;

public class MinimalTest : MonoBehaviour
{
    string VersionString;
    GUIStyle style = new GUIStyle();
    
    [DllImport("__Internal")]
    private static extern int DlopenTest();

    void Start()
    {
        
        Debug.Log($"MinimalTest start()");
        
        try
        {
            var Version = DlopenTest();
            VersionString += $"DlopenTest={Version}";
        }
        catch(System.Exception e)
        {
            Debug.LogException(e);
            VersionString += e.Message;
        }
        
        try
        {
            Debug.Log($"Minimal version {Minimal.Minimal.VersionThousand}");
            var Version = Minimal.Minimal.VersionThousand;
            VersionString += $"Minimal Version {Version}";
            }
        catch(System.Exception e)
        {
            Debug.LogException(e);
            VersionString += e.Message;
        }
    }

    private void OnGUI()
    {
        style.fontSize = 80;
        style.normal.textColor = Color.green;
        style.wordWrap = true;
        GUI.Label(new Rect(10,10,800,9000), VersionString, style);
    }
}
