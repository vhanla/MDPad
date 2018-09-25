Unit SHDocVw_1_1_TLB;

//  Imported SHDocVw on 26/04/2017 0:02:00 from C:\Windows\SysWOW64\ieframe.dll

{$mode delphi}{$H+}

interface

//  Warning: renamed property 'Type' in IWebBrowser to 'Type_'
// Dependency: stdole v2 (stdole2.pas)
//  Warning: 'GUID' not automatable in IWebBrowserdisp.QueryInterface
//  Warning: 'Ppointer' not automatable in IWebBrowserdisp.QueryInterface
//  Warning: 'Ppointer' not automatable in IWebBrowserdisp.GetTypeInfo
//  Warning: 'GUID' not automatable in IWebBrowserdisp.GetIDsOfNames
//  Warning: 'PShortInt' not automatable in IWebBrowserdisp.GetIDsOfNames
//  Warning: 'GUID' not automatable in IWebBrowserdisp.Invoke
//  Warning: 'DISPPARAMS' not automatable in IWebBrowserdisp.Invoke
//  Warning: 'EXCEPINFO' not automatable in IWebBrowserdisp.Invoke
//  Warning: renamed parameter 'Text' in DWebBrowserEvents.StatusTextChange to 'Text_'
//  Warning: renamed parameter 'Text' in DWebBrowserEvents.TitleChange to 'Text_'
//  Warning: renamed parameter 'Property' in DWebBrowserEvents.PropertyChange to 'Property_'
//  Warning: renamed parameter 'Property' in IWebBrowserApp.PutProperty to 'Property_'
//  Warning: renamed parameter 'Property' in IWebBrowserApp.GetProperty to 'Property_'
//  Warning: 'GUID' not automatable in IWebBrowserAppdisp.QueryInterface
//  Warning: 'Ppointer' not automatable in IWebBrowserAppdisp.QueryInterface
//  Warning: 'Ppointer' not automatable in IWebBrowserAppdisp.GetTypeInfo
//  Warning: 'GUID' not automatable in IWebBrowserAppdisp.GetIDsOfNames
//  Warning: 'PShortInt' not automatable in IWebBrowserAppdisp.GetIDsOfNames
//  Warning: 'GUID' not automatable in IWebBrowserAppdisp.Invoke
//  Warning: 'DISPPARAMS' not automatable in IWebBrowserAppdisp.Invoke
//  Warning: 'EXCEPINFO' not automatable in IWebBrowserAppdisp.Invoke
//  Warning: renamed property 'Type' in IWebBrowserApp to 'Type_'
//  Warning: renamed parameter 'Property' in IWebBrowserApp.PutProperty to 'Property_'
//  Warning: renamed parameter 'Property' in IWebBrowserApp.GetProperty to 'Property_'
//  Warning: 'GUID' not automatable in IWebBrowser2disp.QueryInterface
//  Warning: 'Ppointer' not automatable in IWebBrowser2disp.QueryInterface
//  Warning: 'Ppointer' not automatable in IWebBrowser2disp.GetTypeInfo
//  Warning: 'GUID' not automatable in IWebBrowser2disp.GetIDsOfNames
//  Warning: 'PShortInt' not automatable in IWebBrowser2disp.GetIDsOfNames
//  Warning: 'GUID' not automatable in IWebBrowser2disp.Invoke
//  Warning: 'DISPPARAMS' not automatable in IWebBrowser2disp.Invoke
//  Warning: 'EXCEPINFO' not automatable in IWebBrowser2disp.Invoke
//  Warning: renamed property 'Type' in IWebBrowser2 to 'Type_'
//  Warning: renamed parameter 'Property' in IWebBrowser2.PutProperty to 'Property_'
//  Warning: renamed parameter 'Property' in IWebBrowser2.GetProperty to 'Property_'
//  Warning: renamed parameter 'Text' in DWebBrowserEvents2.StatusTextChange to 'Text_'
//  Warning: renamed parameter 'Text' in DWebBrowserEvents2.TitleChange to 'Text_'
//  Warning: 'GUID' not automatable in IShellWindowsdisp.QueryInterface
//  Warning: 'Ppointer' not automatable in IShellWindowsdisp.QueryInterface
//  Warning: 'Ppointer' not automatable in IShellWindowsdisp.GetTypeInfo
//  Warning: 'GUID' not automatable in IShellWindowsdisp.GetIDsOfNames
//  Warning: 'PShortInt' not automatable in IShellWindowsdisp.GetIDsOfNames
//  Warning: 'GUID' not automatable in IShellWindowsdisp.Invoke
//  Warning: 'DISPPARAMS' not automatable in IShellWindowsdisp.Invoke
//  Warning: 'EXCEPINFO' not automatable in IShellWindowsdisp.Invoke
//  Warning: renamed parameter 'Type' in IShellUIHelper.AddDesktopComponent to 'Type_'
//  Warning: 'GUID' not automatable in IShellUIHelperdisp.QueryInterface
//  Warning: 'Ppointer' not automatable in IShellUIHelperdisp.QueryInterface
//  Warning: 'Ppointer' not automatable in IShellUIHelperdisp.GetTypeInfo
//  Warning: 'GUID' not automatable in IShellUIHelperdisp.GetIDsOfNames
//  Warning: 'PShortInt' not automatable in IShellUIHelperdisp.GetIDsOfNames
//  Warning: 'GUID' not automatable in IShellUIHelperdisp.Invoke
//  Warning: 'DISPPARAMS' not automatable in IShellUIHelperdisp.Invoke
//  Warning: 'EXCEPINFO' not automatable in IShellUIHelperdisp.Invoke
//  Warning: renamed parameter 'Type' in IShellUIHelper.AddDesktopComponent to 'Type_'
//  Warning: 'GUID' not automatable in IShellUIHelper2disp.QueryInterface
//  Warning: 'Ppointer' not automatable in IShellUIHelper2disp.QueryInterface
//  Warning: 'Ppointer' not automatable in IShellUIHelper2disp.GetTypeInfo
//  Warning: 'GUID' not automatable in IShellUIHelper2disp.GetIDsOfNames
//  Warning: 'PShortInt' not automatable in IShellUIHelper2disp.GetIDsOfNames
//  Warning: 'GUID' not automatable in IShellUIHelper2disp.Invoke
//  Warning: 'DISPPARAMS' not automatable in IShellUIHelper2disp.Invoke
//  Warning: 'EXCEPINFO' not automatable in IShellUIHelper2disp.Invoke
//  Warning: renamed parameter 'Type' in IShellUIHelper2.AddDesktopComponent to 'Type_'
//  Warning: renamed parameter 'Type' in IShellUIHelper3.AddToFavoritesBar to 'Type_'
//  Warning: 'GUID' not automatable in IShellUIHelper3disp.QueryInterface
//  Warning: 'Ppointer' not automatable in IShellUIHelper3disp.QueryInterface
//  Warning: 'Ppointer' not automatable in IShellUIHelper3disp.GetTypeInfo
//  Warning: 'GUID' not automatable in IShellUIHelper3disp.GetIDsOfNames
//  Warning: 'PShortInt' not automatable in IShellUIHelper3disp.GetIDsOfNames
//  Warning: 'GUID' not automatable in IShellUIHelper3disp.Invoke
//  Warning: 'DISPPARAMS' not automatable in IShellUIHelper3disp.Invoke
//  Warning: 'EXCEPINFO' not automatable in IShellUIHelper3disp.Invoke
//  Warning: renamed parameter 'Type' in IShellUIHelper3.AddDesktopComponent to 'Type_'
//  Warning: renamed parameter 'Type' in IShellUIHelper3.AddToFavoritesBar to 'Type_'
//  Warning: 'GUID' not automatable in IShellUIHelper4disp.QueryInterface
//  Warning: 'Ppointer' not automatable in IShellUIHelper4disp.QueryInterface
//  Warning: 'Ppointer' not automatable in IShellUIHelper4disp.GetTypeInfo
//  Warning: 'GUID' not automatable in IShellUIHelper4disp.GetIDsOfNames
//  Warning: 'PShortInt' not automatable in IShellUIHelper4disp.GetIDsOfNames
//  Warning: 'GUID' not automatable in IShellUIHelper4disp.Invoke
//  Warning: 'DISPPARAMS' not automatable in IShellUIHelper4disp.Invoke
//  Warning: 'EXCEPINFO' not automatable in IShellUIHelper4disp.Invoke
//  Warning: renamed parameter 'Type' in IShellUIHelper4.AddDesktopComponent to 'Type_'
//  Warning: renamed parameter 'Type' in IShellUIHelper4.AddToFavoritesBar to 'Type_'
//  Warning: 'GUID' not automatable in IShellUIHelper5disp.QueryInterface
//  Warning: 'Ppointer' not automatable in IShellUIHelper5disp.QueryInterface
//  Warning: 'Ppointer' not automatable in IShellUIHelper5disp.GetTypeInfo
//  Warning: 'GUID' not automatable in IShellUIHelper5disp.GetIDsOfNames
//  Warning: 'PShortInt' not automatable in IShellUIHelper5disp.GetIDsOfNames
//  Warning: 'GUID' not automatable in IShellUIHelper5disp.Invoke
//  Warning: 'DISPPARAMS' not automatable in IShellUIHelper5disp.Invoke
//  Warning: 'EXCEPINFO' not automatable in IShellUIHelper5disp.Invoke
//  Warning: renamed parameter 'Type' in IShellUIHelper5.AddDesktopComponent to 'Type_'
//  Warning: renamed parameter 'Type' in IShellUIHelper5.AddToFavoritesBar to 'Type_'
//  Warning: 'GUID' not automatable in IShellUIHelper6disp.QueryInterface
//  Warning: 'Ppointer' not automatable in IShellUIHelper6disp.QueryInterface
//  Warning: 'Ppointer' not automatable in IShellUIHelper6disp.GetTypeInfo
//  Warning: 'GUID' not automatable in IShellUIHelper6disp.GetIDsOfNames
//  Warning: 'PShortInt' not automatable in IShellUIHelper6disp.GetIDsOfNames
//  Warning: 'GUID' not automatable in IShellUIHelper6disp.Invoke
//  Warning: 'DISPPARAMS' not automatable in IShellUIHelper6disp.Invoke
//  Warning: 'EXCEPINFO' not automatable in IShellUIHelper6disp.Invoke
//  Warning: renamed parameter 'Type' in IShellUIHelper6.AddDesktopComponent to 'Type_'
//  Warning: renamed parameter 'Type' in IShellUIHelper6.AddToFavoritesBar to 'Type_'
//  Warning: 'GUID' not automatable in IShellUIHelper7disp.QueryInterface
//  Warning: 'Ppointer' not automatable in IShellUIHelper7disp.QueryInterface
//  Warning: 'Ppointer' not automatable in IShellUIHelper7disp.GetTypeInfo
//  Warning: 'GUID' not automatable in IShellUIHelper7disp.GetIDsOfNames
//  Warning: 'PShortInt' not automatable in IShellUIHelper7disp.GetIDsOfNames
//  Warning: 'GUID' not automatable in IShellUIHelper7disp.Invoke
//  Warning: 'DISPPARAMS' not automatable in IShellUIHelper7disp.Invoke
//  Warning: 'EXCEPINFO' not automatable in IShellUIHelper7disp.Invoke
//  Warning: renamed parameter 'Type' in IShellUIHelper7.AddDesktopComponent to 'Type_'
//  Warning: renamed parameter 'Type' in IShellUIHelper7.AddToFavoritesBar to 'Type_'
//  Warning: 'GUID' not automatable in IShellUIHelper8disp.QueryInterface
//  Warning: 'Ppointer' not automatable in IShellUIHelper8disp.QueryInterface
//  Warning: 'Ppointer' not automatable in IShellUIHelper8disp.GetTypeInfo
//  Warning: 'GUID' not automatable in IShellUIHelper8disp.GetIDsOfNames
//  Warning: 'PShortInt' not automatable in IShellUIHelper8disp.GetIDsOfNames
//  Warning: 'GUID' not automatable in IShellUIHelper8disp.Invoke
//  Warning: 'DISPPARAMS' not automatable in IShellUIHelper8disp.Invoke
//  Warning: 'EXCEPINFO' not automatable in IShellUIHelper8disp.Invoke
//  Warning: renamed parameter 'Type' in IShellUIHelper8.AddDesktopComponent to 'Type_'
//  Warning: renamed parameter 'Type' in IShellUIHelper8.AddToFavoritesBar to 'Type_'
//  Warning: 'GUID' not automatable in IShellFavoritesNameSpacedisp.QueryInterface
//  Warning: 'Ppointer' not automatable in IShellFavoritesNameSpacedisp.QueryInterface
//  Warning: 'Ppointer' not automatable in IShellFavoritesNameSpacedisp.GetTypeInfo
//  Warning: 'GUID' not automatable in IShellFavoritesNameSpacedisp.GetIDsOfNames
//  Warning: 'PShortInt' not automatable in IShellFavoritesNameSpacedisp.GetIDsOfNames
//  Warning: 'GUID' not automatable in IShellFavoritesNameSpacedisp.Invoke
//  Warning: 'DISPPARAMS' not automatable in IShellFavoritesNameSpacedisp.Invoke
//  Warning: 'EXCEPINFO' not automatable in IShellFavoritesNameSpacedisp.Invoke
//  Warning: renamed parameter 'var' in IShellNameSpace.Expand to 'var_'
//  Warning: 'GUID' not automatable in IShellNameSpacedisp.QueryInterface
//  Warning: 'Ppointer' not automatable in IShellNameSpacedisp.QueryInterface
//  Warning: 'Ppointer' not automatable in IShellNameSpacedisp.GetTypeInfo
//  Warning: 'GUID' not automatable in IShellNameSpacedisp.GetIDsOfNames
//  Warning: 'PShortInt' not automatable in IShellNameSpacedisp.GetIDsOfNames
//  Warning: 'GUID' not automatable in IShellNameSpacedisp.Invoke
//  Warning: 'DISPPARAMS' not automatable in IShellNameSpacedisp.Invoke
//  Warning: 'EXCEPINFO' not automatable in IShellNameSpacedisp.Invoke
//  Warning: renamed parameter 'var' in IShellNameSpace.Expand to 'var_'
//  Warning: 'GUID' not automatable in IScriptErrorListdisp.QueryInterface
//  Warning: 'Ppointer' not automatable in IScriptErrorListdisp.QueryInterface
//  Warning: 'Ppointer' not automatable in IScriptErrorListdisp.GetTypeInfo
//  Warning: 'GUID' not automatable in IScriptErrorListdisp.GetIDsOfNames
//  Warning: 'PShortInt' not automatable in IScriptErrorListdisp.GetIDsOfNames
//  Warning: 'GUID' not automatable in IScriptErrorListdisp.Invoke
//  Warning: 'DISPPARAMS' not automatable in IScriptErrorListdisp.Invoke
//  Warning: 'EXCEPINFO' not automatable in IScriptErrorListdisp.Invoke
Uses
  Windows,ActiveX,Classes,Variants,stdole2,EventSink;
Const
  SHDocVwMajorVersion = 1;
  SHDocVwMinorVersion = 1;
  SHDocVwLCID = 0;
  LIBID_SHDocVw : TGUID = '{EAB22AC0-30C1-11CF-A7EB-0000C05BAE0B}';

  IID_IWebBrowser : TGUID = '{EAB22AC1-30C1-11CF-A7EB-0000C05BAE0B}';
  IID_DWebBrowserEvents : TGUID = '{EAB22AC2-30C1-11CF-A7EB-0000C05BAE0B}';
  IID_IWebBrowserApp : TGUID = '{0002DF05-0000-0000-C000-000000000046}';
  IID_IWebBrowser2 : TGUID = '{D30C1661-CDAF-11D0-8A3E-00C04FC9E26E}';
  IID_DWebBrowserEvents2 : TGUID = '{34A715A0-6587-11D0-924A-0020AFC7AC4D}';
  CLASS_WebBrowser_V1 : TGUID = '{EAB22AC3-30C1-11CF-A7EB-0000C05BAE0B}';
  CLASS_WebBrowser : TGUID = '{8856F961-340A-11D0-A96B-00C04FD705A2}';
  CLASS_InternetExplorer : TGUID = '{0002DF01-0000-0000-C000-000000000046}';
  CLASS_InternetExplorerMedium : TGUID = '{D5E8041D-920F-45E9-B8FB-B1DEB82C6E5E}';
  CLASS_ShellBrowserWindow : TGUID = '{C08AFD90-F2A1-11D1-8455-00A0C91F3880}';
  IID_DShellWindowsEvents : TGUID = '{FE4106E0-399A-11D0-A48C-00A0C90A8F39}';
  IID_IShellWindows : TGUID = '{85CB6900-4D95-11CF-960C-0080C7F4EE85}';
  CLASS_ShellWindows : TGUID = '{9BA05972-F6A8-11CF-A442-00A0C90A8F39}';
  IID_IShellUIHelper : TGUID = '{729FE2F8-1EA8-11D1-8F85-00C04FC2FBE1}';
  IID_IShellUIHelper2 : TGUID = '{A7FE6EDA-1932-4281-B881-87B31B8BC52C}';
  IID_IShellUIHelper3 : TGUID = '{528DF2EC-D419-40BC-9B6D-DCDBF9C1B25D}';
  IID_IShellUIHelper4 : TGUID = '{B36E6A53-8073-499E-824C-D776330A333E}';
  IID_IShellUIHelper5 : TGUID = '{A2A08B09-103D-4D3F-B91C-EA455CA82EFA}';
  IID_IShellUIHelper6 : TGUID = '{987A573E-46EE-4E89-96AB-DDF7F8FDC98C}';
  IID_IShellUIHelper7 : TGUID = '{60E567C8-9573-4AB2-A264-637C6C161CB1}';
  IID_IShellUIHelper8 : TGUID = '{66DEBCF2-05B0-4F07-B49B-B96241A65DB2}';
  CLASS_ShellUIHelper : TGUID = '{64AB4BB7-111E-11D1-8F79-00C04FC2FBE1}';
  IID_DShellNameSpaceEvents : TGUID = '{55136806-B2DE-11D1-B9F2-00A0C98BC547}';
  IID_IShellFavoritesNameSpace : TGUID = '{55136804-B2DE-11D1-B9F2-00A0C98BC547}';
  IID_IShellNameSpace : TGUID = '{E572D3C9-37BE-4AE2-825D-D521763E3108}';
  CLASS_ShellNameSpace : TGUID = '{55136805-B2DE-11D1-B9F2-00A0C98BC547}';
  IID_IScriptErrorList : TGUID = '{F3470F24-15FD-11D2-BB2E-00805FF7EFCA}';
  CLASS_CScriptErrorList : TGUID = '{EFD01300-160F-11D2-BB2E-00805FF7EFCA}';

//Enums

Type
  CommandStateChangeConstants =LongWord;
Const
  CSC_UPDATECOMMANDS = $00000000FFFFFFFF;
  CSC_NAVIGATEFORWARD = $0000000000000001;
  CSC_NAVIGATEBACK = $0000000000000002;
Type
  OLECMDID =LongWord;
Const
  OLECMDID_OPEN = $0000000000000001;
  OLECMDID_NEW = $0000000000000002;
  OLECMDID_SAVE = $0000000000000003;
  OLECMDID_SAVEAS = $0000000000000004;
  OLECMDID_SAVECOPYAS = $0000000000000005;
  OLECMDID_PRINT = $0000000000000006;
  OLECMDID_PRINTPREVIEW = $0000000000000007;
  OLECMDID_PAGESETUP = $0000000000000008;
  OLECMDID_SPELL = $0000000000000009;
  OLECMDID_PROPERTIES = $000000000000000A;
  OLECMDID_CUT = $000000000000000B;
  OLECMDID_COPY = $000000000000000C;
  OLECMDID_PASTE = $000000000000000D;
  OLECMDID_PASTESPECIAL = $000000000000000E;
  OLECMDID_UNDO = $000000000000000F;
  OLECMDID_REDO = $0000000000000010;
  OLECMDID_SELECTALL = $0000000000000011;
  OLECMDID_CLEARSELECTION = $0000000000000012;
  OLECMDID_ZOOM = $0000000000000013;
  OLECMDID_GETZOOMRANGE = $0000000000000014;
  OLECMDID_UPDATECOMMANDS = $0000000000000015;
  OLECMDID_REFRESH = $0000000000000016;
  OLECMDID_STOP = $0000000000000017;
  OLECMDID_HIDETOOLBARS = $0000000000000018;
  OLECMDID_SETPROGRESSMAX = $0000000000000019;
  OLECMDID_SETPROGRESSPOS = $000000000000001A;
  OLECMDID_SETPROGRESSTEXT = $000000000000001B;
  OLECMDID_SETTITLE = $000000000000001C;
  OLECMDID_SETDOWNLOADSTATE = $000000000000001D;
  OLECMDID_STOPDOWNLOAD = $000000000000001E;
  OLECMDID_ONTOOLBARACTIVATED = $000000000000001F;
  OLECMDID_FIND = $0000000000000020;
  OLECMDID_DELETE = $0000000000000021;
  OLECMDID_HTTPEQUIV = $0000000000000022;
  OLECMDID_HTTPEQUIV_DONE = $0000000000000023;
  OLECMDID_ENABLE_INTERACTION = $0000000000000024;
  OLECMDID_ONUNLOAD = $0000000000000025;
  OLECMDID_PROPERTYBAG2 = $0000000000000026;
  OLECMDID_PREREFRESH = $0000000000000027;
  OLECMDID_SHOWSCRIPTERROR = $0000000000000028;
  OLECMDID_SHOWMESSAGE = $0000000000000029;
  OLECMDID_SHOWFIND = $000000000000002A;
  OLECMDID_SHOWPAGESETUP = $000000000000002B;
  OLECMDID_SHOWPRINT = $000000000000002C;
  OLECMDID_CLOSE = $000000000000002D;
  OLECMDID_ALLOWUILESSSAVEAS = $000000000000002E;
  OLECMDID_DONTDOWNLOADCSS = $000000000000002F;
  OLECMDID_UPDATEPAGESTATUS = $0000000000000030;
  OLECMDID_PRINT2 = $0000000000000031;
  OLECMDID_PRINTPREVIEW2 = $0000000000000032;
  OLECMDID_SETPRINTTEMPLATE = $0000000000000033;
  OLECMDID_GETPRINTTEMPLATE = $0000000000000034;
  OLECMDID_PAGEACTIONBLOCKED = $0000000000000037;
  OLECMDID_PAGEACTIONUIQUERY = $0000000000000038;
  OLECMDID_FOCUSVIEWCONTROLS = $0000000000000039;
  OLECMDID_FOCUSVIEWCONTROLSQUERY = $000000000000003A;
  OLECMDID_SHOWPAGEACTIONMENU = $000000000000003B;
  OLECMDID_ADDTRAVELENTRY = $000000000000003C;
  OLECMDID_UPDATETRAVELENTRY = $000000000000003D;
  OLECMDID_UPDATEBACKFORWARDSTATE = $000000000000003E;
  OLECMDID_OPTICAL_ZOOM = $000000000000003F;
  OLECMDID_OPTICAL_GETZOOMRANGE = $0000000000000040;
  OLECMDID_WINDOWSTATECHANGED = $0000000000000041;
  OLECMDID_ACTIVEXINSTALLSCOPE = $0000000000000042;
  OLECMDID_UPDATETRAVELENTRY_DATARECOVERY = $0000000000000043;
  OLECMDID_SHOWTASKDLG = $0000000000000044;
  OLECMDID_POPSTATEEVENT = $0000000000000045;
  OLECMDID_VIEWPORT_MODE = $0000000000000046;
  OLECMDID_LAYOUT_VIEWPORT_WIDTH = $0000000000000047;
  OLECMDID_VISUAL_VIEWPORT_EXCLUDE_BOTTOM = $0000000000000048;
  OLECMDID_USER_OPTICAL_ZOOM = $0000000000000049;
  OLECMDID_PAGEAVAILABLE = $000000000000004A;
  OLECMDID_GETUSERSCALABLE = $000000000000004B;
  OLECMDID_UPDATE_CARET = $000000000000004C;
  OLECMDID_ENABLE_VISIBILITY = $000000000000004D;
  OLECMDID_MEDIA_PLAYBACK = $000000000000004E;
  OLECMDID_SETFAVICON = $000000000000004F;
  OLECMDID_SET_HOST_FULLSCREENMODE = $0000000000000050;
  OLECMDID_EXITFULLSCREEN = $0000000000000051;
  OLECMDID_SCROLLCOMPLETE = $0000000000000052;
  OLECMDID_ONBEFOREUNLOAD = $0000000000000053;
  OLECMDID_SHOWMESSAGE_BLOCKABLE = $0000000000000054;
  OLECMDID_SHOWTASKDLG_BLOCKABLE = $0000000000000055;
Type
  OLECMDF =LongWord;
Const
  OLECMDF_SUPPORTED = $0000000000000001;
  OLECMDF_ENABLED = $0000000000000002;
  OLECMDF_LATCHED = $0000000000000004;
  OLECMDF_NINCHED = $0000000000000008;
  OLECMDF_INVISIBLE = $0000000000000010;
  OLECMDF_DEFHIDEONCTXTMENU = $0000000000000020;
Type
  OLECMDEXECOPT =LongWord;
Const
  OLECMDEXECOPT_DODEFAULT = $0000000000000000;
  OLECMDEXECOPT_PROMPTUSER = $0000000000000001;
  OLECMDEXECOPT_DONTPROMPTUSER = $0000000000000002;
  OLECMDEXECOPT_SHOWHELP = $0000000000000003;
Type
  tagREADYSTATE =LongWord;
Const
  READYSTATE_UNINITIALIZED = $0000000000000000;
  READYSTATE_LOADING = $0000000000000001;
  READYSTATE_LOADED = $0000000000000002;
  READYSTATE_INTERACTIVE = $0000000000000003;
  READYSTATE_COMPLETE = $0000000000000004;
Type
  SecureLockIconConstants =LongWord;
Const
  secureLockIconUnsecure = $0000000000000000;
  secureLockIconMixed = $0000000000000001;
  secureLockIconSecureUnknownBits = $0000000000000002;
  secureLockIconSecure40Bit = $0000000000000003;
  secureLockIconSecure56Bit = $0000000000000004;
  secureLockIconSecureFortezza = $0000000000000005;
  secureLockIconSecure128Bit = $0000000000000006;
Type
  NewProcessCauseConstants =LongWord;
Const
  ProtectedModeRedirect = $0000000000000001;
Type
  ShellWindowTypeConstants =LongWord;
Const
  SWC_EXPLORER = $0000000000000000;
  SWC_BROWSER = $0000000000000001;
  SWC_3RDPARTY = $0000000000000002;
  SWC_CALLBACK = $0000000000000004;
  SWC_DESKTOP = $0000000000000008;
Type
  ShellWindowFindWindowOptions =LongWord;
Const
  SWFO_NEEDDISPATCH = $0000000000000001;
  SWFO_INCLUDEPENDING = $0000000000000002;
  SWFO_COOKIEPASSED = $0000000000000004;
//Forward declarations

Type
 IWebBrowser = interface;
 IWebBrowserDisp = dispinterface;
 DWebBrowserEvents = dispinterface;
 IWebBrowserApp = interface;
 IWebBrowserAppDisp = dispinterface;
 IWebBrowser2 = interface;
 IWebBrowser2Disp = dispinterface;
 DWebBrowserEvents2 = dispinterface;
 DShellWindowsEvents = dispinterface;
 IShellWindows = interface;
 IShellWindowsDisp = dispinterface;
 IShellUIHelper = interface;
 IShellUIHelperDisp = dispinterface;
 IShellUIHelper2 = interface;
 IShellUIHelper2Disp = dispinterface;
 IShellUIHelper3 = interface;
 IShellUIHelper3Disp = dispinterface;
 IShellUIHelper4 = interface;
 IShellUIHelper4Disp = dispinterface;
 IShellUIHelper5 = interface;
 IShellUIHelper5Disp = dispinterface;
 IShellUIHelper6 = interface;
 IShellUIHelper6Disp = dispinterface;
 IShellUIHelper7 = interface;
 IShellUIHelper7Disp = dispinterface;
 IShellUIHelper8 = interface;
 IShellUIHelper8Disp = dispinterface;
 DShellNameSpaceEvents = dispinterface;
 IShellFavoritesNameSpace = interface;
 IShellFavoritesNameSpaceDisp = dispinterface;
 IShellNameSpace = interface;
 IShellNameSpaceDisp = dispinterface;
 IScriptErrorList = interface;
 IScriptErrorListDisp = dispinterface;

//Map CoClass to its default interface

 WebBrowser_V1 = IWebBrowser;
 WebBrowser = IWebBrowser2;
 InternetExplorer = IWebBrowser2;
 InternetExplorerMedium = IWebBrowser2;
 ShellBrowserWindow = IWebBrowser2;
 ShellWindows = IShellWindows;
 ShellUIHelper = IShellUIHelper8;
 ShellNameSpace = IShellNameSpace;
 CScriptErrorList = IScriptErrorList;

//records, unions, aliases


//interface declarations

// IWebBrowser : Web Browser interface

 IWebBrowser = interface(IDispatch)
   ['{EAB22AC1-30C1-11CF-A7EB-0000C05BAE0B}']
    // GoBack : Navigates to the previous item in the history list. 
   procedure GoBack;safecall;
    // GoForward : Navigates to the next item in the history list. 
   procedure GoForward;safecall;
    // GoHome : Go home/start page. 
   procedure GoHome;safecall;
    // GoSearch : Go Search Page. 
   procedure GoSearch;safecall;
    // Navigate : Navigates to a URL or file. 
   procedure Navigate(URL:WideString;var Flags:OleVariant;var TargetFrameName:OleVariant;var PostData:OleVariant;var Headers:OleVariant);safecall;
    // Refresh : Refresh the currently viewed page. 
   procedure Refresh;safecall;
    // Refresh2 : Refresh the currently viewed page. 
   procedure Refresh2(var Level:OleVariant);safecall;
    // Stop : Stops opening a file. 
   procedure Stop;safecall;
   function Get_Application : IDispatch; safecall;
   function Get_Parent : IDispatch; safecall;
   function Get_Container : IDispatch; safecall;
   function Get_Document : IDispatch; safecall;
   function Get_TopLevelContainer : WordBool; safecall;
   function Get_Type_ : WideString; safecall;
   function Get_Left : Integer; safecall;
   procedure Set_Left(const pl:Integer); safecall;
   function Get_Top : Integer; safecall;
   procedure Set_Top(const pl:Integer); safecall;
   function Get_Width : Integer; safecall;
   procedure Set_Width(const pl:Integer); safecall;
   function Get_Height : Integer; safecall;
   procedure Set_Height(const pl:Integer); safecall;
   function Get_LocationName : WideString; safecall;
   function Get_LocationURL : WideString; safecall;
   function Get_Busy : WordBool; safecall;
    // Application : Returns the application automation object if accessible, this automation object otherwise.. 
   property Application:IDispatch read Get_Application;
    // Parent : Returns the automation object of the container/parent if one exists or this automation object. 
   property Parent:IDispatch read Get_Parent;
    // Container : Returns the container/parent automation object, if any. 
   property Container:IDispatch read Get_Container;
    // Document : Returns the active Document automation object, if any. 
   property Document:IDispatch read Get_Document;
    // TopLevelContainer : Returns True if this is the top level object. 
   property TopLevelContainer:WordBool read Get_TopLevelContainer;
    // Type : Returns the type of the contained document object. 
   property Type_:WideString read Get_Type_;
    // Left : The horizontal position (pixels) of the frame window relative to the screen/container. 
   property Left:Integer read Get_Left write Set_Left;
    // Top : The vertical position (pixels) of the frame window relative to the screen/container. 
   property Top:Integer read Get_Top write Set_Top;
    // Width : The horizontal dimension (pixels) of the frame window/object. 
   property Width:Integer read Get_Width write Set_Width;
    // Height : The vertical dimension (pixels) of the frame window/object. 
   property Height:Integer read Get_Height write Set_Height;
    // LocationName : Gets the short (UI-friendly) name of the URL/file currently viewed. 
   property LocationName:WideString read Get_LocationName;
    // LocationURL : Gets the full URL/path currently viewed. 
   property LocationURL:WideString read Get_LocationURL;
    // Busy : Query to see if something is still in progress. 
   property Busy:WordBool read Get_Busy;
  end;


// IWebBrowser : Web Browser interface

 IWebBrowserDisp = dispinterface
   ['{EAB22AC1-30C1-11CF-A7EB-0000C05BAE0B}']
    // QueryInterface :  
   procedure QueryInterface(var riid:{!! GUID !!} OleVariant;out ppvObj:{!! Ppointer !!} OleVariant);dispid 1610612736;
    // AddRef :  
   function AddRef:LongWord;dispid 1610612737;
    // Release :  
   function Release:LongWord;dispid 1610612738;
    // GetTypeInfoCount :  
   procedure GetTypeInfoCount(out pctinfo:UInt);dispid 1610678272;
    // GetTypeInfo :  
   procedure GetTypeInfo(itinfo:UInt;lcid:LongWord;out pptinfo:{!! Ppointer !!} OleVariant);dispid 1610678273;
    // GetIDsOfNames :  
   procedure GetIDsOfNames(var riid:{!! GUID !!} OleVariant;var rgszNames:{!! PShortInt !!} OleVariant;cNames:UInt;lcid:LongWord;out rgdispid:Integer);dispid 1610678274;
    // Invoke :  
   procedure Invoke(dispidMember:Integer;var riid:{!! GUID !!} OleVariant;lcid:LongWord;wFlags:Word;var pdispparams:{!! DISPPARAMS !!} OleVariant;out pvarResult:OleVariant;out pexcepinfo:{!! EXCEPINFO !!} OleVariant;out puArgErr:UInt);dispid 1610678275;
    // GoBack : Navigates to the previous item in the history list. 
   procedure GoBack;dispid 100;
    // GoForward : Navigates to the next item in the history list. 
   procedure GoForward;dispid 101;
    // GoHome : Go home/start page. 
   procedure GoHome;dispid 102;
    // GoSearch : Go Search Page. 
   procedure GoSearch;dispid 103;
    // Navigate : Navigates to a URL or file. 
   procedure Navigate(URL:WideString;var Flags:OleVariant;var TargetFrameName:OleVariant;var PostData:OleVariant;var Headers:OleVariant);dispid 104;
    // Refresh : Refresh the currently viewed page. 
   procedure Refresh;dispid -550;
    // Refresh2 : Refresh the currently viewed page. 
   procedure Refresh2(var Level:OleVariant);dispid 105;
    // Stop : Stops opening a file. 
   procedure Stop;dispid 106;
    // Application : Returns the application automation object if accessible, this automation object otherwise.. 
   property Application:IDispatch  readonly dispid 200;
    // Parent : Returns the automation object of the container/parent if one exists or this automation object. 
   property Parent:IDispatch  readonly dispid 201;
    // Container : Returns the container/parent automation object, if any. 
   property Container:IDispatch  readonly dispid 202;
    // Document : Returns the active Document automation object, if any. 
   property Document:IDispatch  readonly dispid 203;
    // TopLevelContainer : Returns True if this is the top level object. 
   property TopLevelContainer:WordBool  readonly dispid 204;
    // Type : Returns the type of the contained document object. 
   property Type_:WideString  readonly dispid 205;
    // Left : The horizontal position (pixels) of the frame window relative to the screen/container. 
   property Left:Integer dispid 206;
    // Top : The vertical position (pixels) of the frame window relative to the screen/container. 
   property Top:Integer dispid 207;
    // Width : The horizontal dimension (pixels) of the frame window/object. 
   property Width:Integer dispid 208;
    // Height : The vertical dimension (pixels) of the frame window/object. 
   property Height:Integer dispid 209;
    // LocationName : Gets the short (UI-friendly) name of the URL/file currently viewed. 
   property LocationName:WideString  readonly dispid 210;
    // LocationURL : Gets the full URL/path currently viewed. 
   property LocationURL:WideString  readonly dispid 211;
    // Busy : Query to see if something is still in progress. 
   property Busy:WordBool  readonly dispid 212;
  end;


// DWebBrowserEvents : Web Browser Control Events (old)

 DWebBrowserEvents = dispinterface
   ['{EAB22AC2-30C1-11CF-A7EB-0000C05BAE0B}']
    // BeforeNavigate : Fired when a new hyperlink is being navigated to. 
   procedure BeforeNavigate(URL:WideString;Flags:Integer;TargetFrameName:WideString;PostData:OleVariant;Headers:WideString;var Cancel:WordBool);dispid 100;
    // NavigateComplete : Fired when the document being navigated to becomes visible and enters the navigation stack. 
   procedure NavigateComplete(URL:WideString);dispid 101;
    // StatusTextChange : Statusbar text changed. 
   procedure StatusTextChange(Text_:WideString);dispid 102;
    // ProgressChange : Fired when download progress is updated. 
   procedure ProgressChange(Progress:Integer;ProgressMax:Integer);dispid 108;
    // DownloadComplete : Download of page complete. 
   procedure DownloadComplete;dispid 104;
    // CommandStateChange : The enabled state of a command changed 
   procedure CommandStateChange(Command:Integer;Enable:WordBool);dispid 105;
    // DownloadBegin : Download of a page started. 
   procedure DownloadBegin;dispid 106;
    // NewWindow : Fired when a new window should be created. 
   procedure NewWindow(URL:WideString;Flags:Integer;TargetFrameName:WideString;var PostData:OleVariant;Headers:WideString;var Processed:WordBool);dispid 107;
    // TitleChange : Document title changed. 
   procedure TitleChange(Text_:WideString);dispid 113;
    // FrameBeforeNavigate : Fired when a new hyperlink is being navigated to in a frame. 
   procedure FrameBeforeNavigate(URL:WideString;Flags:Integer;TargetFrameName:WideString;PostData:OleVariant;Headers:WideString;var Cancel:WordBool);dispid 200;
    // FrameNavigateComplete : Fired when a new hyperlink is being navigated to in a frame. 
   procedure FrameNavigateComplete(URL:WideString);dispid 201;
    // FrameNewWindow : Fired when a new window should be created. 
   procedure FrameNewWindow(URL:WideString;Flags:Integer;TargetFrameName:WideString;var PostData:OleVariant;Headers:WideString;var Processed:WordBool);dispid 204;
    // Quit : Fired when application is quiting. 
   procedure Quit(var Cancel:WordBool);dispid 103;
    // WindowMove : Fired when window has been moved. 
   procedure WindowMove;dispid 109;
    // WindowResize : Fired when window has been sized. 
   procedure WindowResize;dispid 110;
    // WindowActivate : Fired when window has been activated. 
   procedure WindowActivate;dispid 111;
    // PropertyChange : Fired when the PutProperty method has been called. 
   procedure PropertyChange(Property_:WideString);dispid 112;
  end;


// IWebBrowserApp : Web Browser Application Interface.

 IWebBrowserApp = interface(IWebBrowser)
   ['{0002DF05-0000-0000-C000-000000000046}']
    // Quit : Exits application and closes the open document. 
   procedure Quit;safecall;
    // ClientToWindow : Converts client sizes into window sizes. 
   procedure ClientToWindow(var pcx:SYSINT;var pcy:SYSINT);safecall;
    // PutProperty : Associates vtValue with the name szProperty in the context of the object. 
   procedure PutProperty(Property_:WideString;vtValue:OleVariant);safecall;
    // GetProperty : Retrieve the Associated value for the property vtValue in the context of the object. 
   function GetProperty(Property_:WideString):OleVariant;safecall;
   function Get_Name : WideString; safecall;
   function Get_HWND : Integer; safecall;
   function Get_FullName : WideString; safecall;
   function Get_Path : WideString; safecall;
   function Get_Visible : WordBool; safecall;
   procedure Set_Visible(const pBool:WordBool); safecall;
   function Get_StatusBar : WordBool; safecall;
   procedure Set_StatusBar(const pBool:WordBool); safecall;
   function Get_StatusText : WideString; safecall;
   procedure Set_StatusText(const StatusText:WideString); safecall;
   function Get_ToolBar : SYSINT; safecall;
   procedure Set_ToolBar(const Value:SYSINT); safecall;
   function Get_MenuBar : WordBool; safecall;
   procedure Set_MenuBar(const Value:WordBool); safecall;
   function Get_FullScreen : WordBool; safecall;
   procedure Set_FullScreen(const pbFullScreen:WordBool); safecall;
    // Name : Returns name of the application. 
   property Name:WideString read Get_Name;
    // HWND : Returns the HWND of the current IE window. 
   property HWND:Integer read Get_HWND;
    // FullName : Returns file specification of the application, including path. 
   property FullName:WideString read Get_FullName;
    // Path : Returns the path to the application. 
   property Path:WideString read Get_Path;
    // Visible : Determines whether the application is visible or hidden. 
   property Visible:WordBool read Get_Visible write Set_Visible;
    // StatusBar : Turn on or off the statusbar. 
   property StatusBar:WordBool read Get_StatusBar write Set_StatusBar;
    // StatusText : Text of Status window. 
   property StatusText:WideString read Get_StatusText write Set_StatusText;
    // ToolBar : Controls which toolbar is shown. 
   property ToolBar:SYSINT read Get_ToolBar write Set_ToolBar;
    // MenuBar : Controls whether menubar is shown. 
   property MenuBar:WordBool read Get_MenuBar write Set_MenuBar;
    // FullScreen : Maximizes window and turns off statusbar, toolbar, menubar, and titlebar. 
   property FullScreen:WordBool read Get_FullScreen write Set_FullScreen;
  end;


// IWebBrowserApp : Web Browser Application Interface.

 IWebBrowserAppDisp = dispinterface
   ['{0002DF05-0000-0000-C000-000000000046}']
    // QueryInterface :  
   procedure QueryInterface(var riid:{!! GUID !!} OleVariant;out ppvObj:{!! Ppointer !!} OleVariant);dispid 1610612736;
    // AddRef :  
   function AddRef:LongWord;dispid 1610612737;
    // Release :  
   function Release:LongWord;dispid 1610612738;
    // GetTypeInfoCount :  
   procedure GetTypeInfoCount(out pctinfo:UInt);dispid 1610678272;
    // GetTypeInfo :  
   procedure GetTypeInfo(itinfo:UInt;lcid:LongWord;out pptinfo:{!! Ppointer !!} OleVariant);dispid 1610678273;
    // GetIDsOfNames :  
   procedure GetIDsOfNames(var riid:{!! GUID !!} OleVariant;var rgszNames:{!! PShortInt !!} OleVariant;cNames:UInt;lcid:LongWord;out rgdispid:Integer);dispid 1610678274;
    // Invoke :  
   procedure Invoke(dispidMember:Integer;var riid:{!! GUID !!} OleVariant;lcid:LongWord;wFlags:Word;var pdispparams:{!! DISPPARAMS !!} OleVariant;out pvarResult:OleVariant;out pexcepinfo:{!! EXCEPINFO !!} OleVariant;out puArgErr:UInt);dispid 1610678275;
    // GoBack : Navigates to the previous item in the history list. 
   procedure GoBack;dispid 100;
    // GoForward : Navigates to the next item in the history list. 
   procedure GoForward;dispid 101;
    // GoHome : Go home/start page. 
   procedure GoHome;dispid 102;
    // GoSearch : Go Search Page. 
   procedure GoSearch;dispid 103;
    // Navigate : Navigates to a URL or file. 
   procedure Navigate(URL:WideString;var Flags:OleVariant;var TargetFrameName:OleVariant;var PostData:OleVariant;var Headers:OleVariant);dispid 104;
    // Refresh : Refresh the currently viewed page. 
   procedure Refresh;dispid -550;
    // Refresh2 : Refresh the currently viewed page. 
   procedure Refresh2(var Level:OleVariant);dispid 105;
    // Stop : Stops opening a file. 
   procedure Stop;dispid 106;
    // Quit : Exits application and closes the open document. 
   procedure Quit;dispid 300;
    // ClientToWindow : Converts client sizes into window sizes. 
   procedure ClientToWindow(var pcx:SYSINT;var pcy:SYSINT);dispid 301;
    // PutProperty : Associates vtValue with the name szProperty in the context of the object. 
   procedure PutProperty(Property_:WideString;vtValue:OleVariant);dispid 302;
    // GetProperty : Retrieve the Associated value for the property vtValue in the context of the object. 
   function GetProperty(Property_:WideString):OleVariant;dispid 303;
    // Application : Returns the application automation object if accessible, this automation object otherwise.. 
   property Application:IDispatch  readonly dispid 200;
    // Parent : Returns the automation object of the container/parent if one exists or this automation object. 
   property Parent:IDispatch  readonly dispid 201;
    // Container : Returns the container/parent automation object, if any. 
   property Container:IDispatch  readonly dispid 202;
    // Document : Returns the active Document automation object, if any. 
   property Document:IDispatch  readonly dispid 203;
    // TopLevelContainer : Returns True if this is the top level object. 
   property TopLevelContainer:WordBool  readonly dispid 204;
    // Type : Returns the type of the contained document object. 
   property Type_:WideString  readonly dispid 205;
    // Left : The horizontal position (pixels) of the frame window relative to the screen/container. 
   property Left:Integer dispid 206;
    // Top : The vertical position (pixels) of the frame window relative to the screen/container. 
   property Top:Integer dispid 207;
    // Width : The horizontal dimension (pixels) of the frame window/object. 
   property Width:Integer dispid 208;
    // Height : The vertical dimension (pixels) of the frame window/object. 
   property Height:Integer dispid 209;
    // LocationName : Gets the short (UI-friendly) name of the URL/file currently viewed. 
   property LocationName:WideString  readonly dispid 210;
    // LocationURL : Gets the full URL/path currently viewed. 
   property LocationURL:WideString  readonly dispid 211;
    // Busy : Query to see if something is still in progress. 
   property Busy:WordBool  readonly dispid 212;
    // Name : Returns name of the application. 
   property Name:WideString  readonly dispid 0;
    // HWND : Returns the HWND of the current IE window. 
   property HWND:Integer  readonly dispid -515;
    // FullName : Returns file specification of the application, including path. 
   property FullName:WideString  readonly dispid 400;
    // Path : Returns the path to the application. 
   property Path:WideString  readonly dispid 401;
    // Visible : Determines whether the application is visible or hidden. 
   property Visible:WordBool dispid 402;
    // StatusBar : Turn on or off the statusbar. 
   property StatusBar:WordBool dispid 403;
    // StatusText : Text of Status window. 
   property StatusText:WideString dispid 404;
    // ToolBar : Controls which toolbar is shown. 
   property ToolBar:SYSINT dispid 405;
    // MenuBar : Controls whether menubar is shown. 
   property MenuBar:WordBool dispid 406;
    // FullScreen : Maximizes window and turns off statusbar, toolbar, menubar, and titlebar. 
   property FullScreen:WordBool dispid 407;
  end;


// IWebBrowser2 : Web Browser Interface for IE4.

 IWebBrowser2 = interface(IWebBrowserApp)
   ['{D30C1661-CDAF-11D0-8A3E-00C04FC9E26E}']
    // Navigate2 : Navigates to a URL or file or pidl. 
   procedure Navigate2(var URL:OleVariant;var Flags:OleVariant;var TargetFrameName:OleVariant;var PostData:OleVariant;var Headers:OleVariant);safecall;
    // QueryStatusWB : IOleCommandTarget::QueryStatus 
   function QueryStatusWB(cmdID:OLECMDID):OLECMDF;safecall;
    // ExecWB : IOleCommandTarget::Exec 
   procedure ExecWB(cmdID:OLECMDID;cmdexecopt:OLECMDEXECOPT;var pvaIn:OleVariant;var pvaOut:OleVariant);safecall;
    // ShowBrowserBar : Set BrowserBar to Clsid 
   procedure ShowBrowserBar(var pvaClsid:OleVariant;var pvarShow:OleVariant;var pvarSize:OleVariant);safecall;
   function Get_ReadyState : tagREADYSTATE; safecall;
   function Get_Offline : WordBool; safecall;
   procedure Set_Offline(const pbOffline:WordBool); safecall;
   function Get_Silent : WordBool; safecall;
   procedure Set_Silent(const pbSilent:WordBool); safecall;
   function Get_RegisterAsBrowser : WordBool; safecall;
   procedure Set_RegisterAsBrowser(const pbRegister:WordBool); safecall;
   function Get_RegisterAsDropTarget : WordBool; safecall;
   procedure Set_RegisterAsDropTarget(const pbRegister:WordBool); safecall;
   function Get_TheaterMode : WordBool; safecall;
   procedure Set_TheaterMode(const pbRegister:WordBool); safecall;
   function Get_AddressBar : WordBool; safecall;
   procedure Set_AddressBar(const Value:WordBool); safecall;
   function Get_Resizable : WordBool; safecall;
   procedure Set_Resizable(const Value:WordBool); safecall;
    // ReadyState :  
   property ReadyState:tagREADYSTATE read Get_ReadyState;
    // Offline : Controls if the frame is offline (read from cache) 
   property Offline:WordBool read Get_Offline write Set_Offline;
    // Silent : Controls if any dialog boxes can be shown 
   property Silent:WordBool read Get_Silent write Set_Silent;
    // RegisterAsBrowser : Registers OC as a top-level browser (for target name resolution) 
   property RegisterAsBrowser:WordBool read Get_RegisterAsBrowser write Set_RegisterAsBrowser;
    // RegisterAsDropTarget : Registers OC as a drop target for navigation 
   property RegisterAsDropTarget:WordBool read Get_RegisterAsDropTarget write Set_RegisterAsDropTarget;
    // TheaterMode : Controls if the browser is in theater mode 
   property TheaterMode:WordBool read Get_TheaterMode write Set_TheaterMode;
    // AddressBar : Controls whether address bar is shown 
   property AddressBar:WordBool read Get_AddressBar write Set_AddressBar;
    // Resizable : Controls whether the window is resizable 
   property Resizable:WordBool read Get_Resizable write Set_Resizable;
  end;


// IWebBrowser2 : Web Browser Interface for IE4.

 IWebBrowser2Disp = dispinterface
   ['{D30C1661-CDAF-11D0-8A3E-00C04FC9E26E}']
    // QueryInterface :  
   procedure QueryInterface(var riid:{!! GUID !!} OleVariant;out ppvObj:{!! Ppointer !!} OleVariant);dispid 1610612736;
    // AddRef :  
   function AddRef:LongWord;dispid 1610612737;
    // Release :  
   function Release:LongWord;dispid 1610612738;
    // GetTypeInfoCount :  
   procedure GetTypeInfoCount(out pctinfo:UInt);dispid 1610678272;
    // GetTypeInfo :  
   procedure GetTypeInfo(itinfo:UInt;lcid:LongWord;out pptinfo:{!! Ppointer !!} OleVariant);dispid 1610678273;
    // GetIDsOfNames :  
   procedure GetIDsOfNames(var riid:{!! GUID !!} OleVariant;var rgszNames:{!! PShortInt !!} OleVariant;cNames:UInt;lcid:LongWord;out rgdispid:Integer);dispid 1610678274;
    // Invoke :  
   procedure Invoke(dispidMember:Integer;var riid:{!! GUID !!} OleVariant;lcid:LongWord;wFlags:Word;var pdispparams:{!! DISPPARAMS !!} OleVariant;out pvarResult:OleVariant;out pexcepinfo:{!! EXCEPINFO !!} OleVariant;out puArgErr:UInt);dispid 1610678275;
    // GoBack : Navigates to the previous item in the history list. 
   procedure GoBack;dispid 100;
    // GoForward : Navigates to the next item in the history list. 
   procedure GoForward;dispid 101;
    // GoHome : Go home/start page. 
   procedure GoHome;dispid 102;
    // GoSearch : Go Search Page. 
   procedure GoSearch;dispid 103;
    // Navigate : Navigates to a URL or file. 
   procedure Navigate(URL:WideString;var Flags:OleVariant;var TargetFrameName:OleVariant;var PostData:OleVariant;var Headers:OleVariant);dispid 104;
    // Refresh : Refresh the currently viewed page. 
   procedure Refresh;dispid -550;
    // Refresh2 : Refresh the currently viewed page. 
   procedure Refresh2(var Level:OleVariant);dispid 105;
    // Stop : Stops opening a file. 
   procedure Stop;dispid 106;
    // Quit : Exits application and closes the open document. 
   procedure Quit;dispid 300;
    // ClientToWindow : Converts client sizes into window sizes. 
   procedure ClientToWindow(var pcx:SYSINT;var pcy:SYSINT);dispid 301;
    // PutProperty : Associates vtValue with the name szProperty in the context of the object. 
   procedure PutProperty(Property_:WideString;vtValue:OleVariant);dispid 302;
    // GetProperty : Retrieve the Associated value for the property vtValue in the context of the object. 
   function GetProperty(Property_:WideString):OleVariant;dispid 303;
    // Navigate2 : Navigates to a URL or file or pidl. 
   procedure Navigate2(var URL:OleVariant;var Flags:OleVariant;var TargetFrameName:OleVariant;var PostData:OleVariant;var Headers:OleVariant);dispid 500;
    // QueryStatusWB : IOleCommandTarget::QueryStatus 
   function QueryStatusWB(cmdID:OLECMDID):OLECMDF;dispid 501;
    // ExecWB : IOleCommandTarget::Exec 
   procedure ExecWB(cmdID:OLECMDID;cmdexecopt:OLECMDEXECOPT;var pvaIn:OleVariant;var pvaOut:OleVariant);dispid 502;
    // ShowBrowserBar : Set BrowserBar to Clsid 
   procedure ShowBrowserBar(var pvaClsid:OleVariant;var pvarShow:OleVariant;var pvarSize:OleVariant);dispid 503;
    // Application : Returns the application automation object if accessible, this automation object otherwise.. 
   property Application:IDispatch  readonly dispid 200;
    // Parent : Returns the automation object of the container/parent if one exists or this automation object. 
   property Parent:IDispatch  readonly dispid 201;
    // Container : Returns the container/parent automation object, if any. 
   property Container:IDispatch  readonly dispid 202;
    // Document : Returns the active Document automation object, if any. 
   property Document:IDispatch  readonly dispid 203;
    // TopLevelContainer : Returns True if this is the top level object. 
   property TopLevelContainer:WordBool  readonly dispid 204;
    // Type : Returns the type of the contained document object. 
   property Type_:WideString  readonly dispid 205;
    // Left : The horizontal position (pixels) of the frame window relative to the screen/container. 
   property Left:Integer dispid 206;
    // Top : The vertical position (pixels) of the frame window relative to the screen/container. 
   property Top:Integer dispid 207;
    // Width : The horizontal dimension (pixels) of the frame window/object. 
   property Width:Integer dispid 208;
    // Height : The vertical dimension (pixels) of the frame window/object. 
   property Height:Integer dispid 209;
    // LocationName : Gets the short (UI-friendly) name of the URL/file currently viewed. 
   property LocationName:WideString  readonly dispid 210;
    // LocationURL : Gets the full URL/path currently viewed. 
   property LocationURL:WideString  readonly dispid 211;
    // Busy : Query to see if something is still in progress. 
   property Busy:WordBool  readonly dispid 212;
    // Name : Returns name of the application. 
   property Name:WideString  readonly dispid 0;
    // HWND : Returns the HWND of the current IE window. 
   property HWND:Integer  readonly dispid -515;
    // FullName : Returns file specification of the application, including path. 
   property FullName:WideString  readonly dispid 400;
    // Path : Returns the path to the application. 
   property Path:WideString  readonly dispid 401;
    // Visible : Determines whether the application is visible or hidden. 
   property Visible:WordBool dispid 402;
    // StatusBar : Turn on or off the statusbar. 
   property StatusBar:WordBool dispid 403;
    // StatusText : Text of Status window. 
   property StatusText:WideString dispid 404;
    // ToolBar : Controls which toolbar is shown. 
   property ToolBar:SYSINT dispid 405;
    // MenuBar : Controls whether menubar is shown. 
   property MenuBar:WordBool dispid 406;
    // FullScreen : Maximizes window and turns off statusbar, toolbar, menubar, and titlebar. 
   property FullScreen:WordBool dispid 407;
    // ReadyState :  
   property ReadyState:tagREADYSTATE  readonly dispid -525;
    // Offline : Controls if the frame is offline (read from cache) 
   property Offline:WordBool dispid 550;
    // Silent : Controls if any dialog boxes can be shown 
   property Silent:WordBool dispid 551;
    // RegisterAsBrowser : Registers OC as a top-level browser (for target name resolution) 
   property RegisterAsBrowser:WordBool dispid 552;
    // RegisterAsDropTarget : Registers OC as a drop target for navigation 
   property RegisterAsDropTarget:WordBool dispid 553;
    // TheaterMode : Controls if the browser is in theater mode 
   property TheaterMode:WordBool dispid 554;
    // AddressBar : Controls whether address bar is shown 
   property AddressBar:WordBool dispid 555;
    // Resizable : Controls whether the window is resizable 
   property Resizable:WordBool dispid 556;
  end;


// DWebBrowserEvents2 : Web Browser Control events interface

 DWebBrowserEvents2 = dispinterface
   ['{34A715A0-6587-11D0-924A-0020AFC7AC4D}']
    // StatusTextChange : Statusbar text changed. 
   procedure StatusTextChange(Text_:WideString);dispid 102;
    // ProgressChange : Fired when download progress is updated. 
   procedure ProgressChange(Progress:Integer;ProgressMax:Integer);dispid 108;
    // CommandStateChange : The enabled state of a command changed. 
   procedure CommandStateChange(Command:Integer;Enable:WordBool);dispid 105;
    // DownloadBegin : Download of a page started. 
   procedure DownloadBegin;dispid 106;
    // DownloadComplete : Download of page complete. 
   procedure DownloadComplete;dispid 104;
    // TitleChange : Document title changed. 
   procedure TitleChange(Text_:WideString);dispid 113;
    // PropertyChange : Fired when the PutProperty method has been called. 
   procedure PropertyChange(szProperty:WideString);dispid 112;
    // BeforeNavigate2 : Fired before navigate occurs in the given WebBrowser (window or frameset element). The processing of this navigation may be modified. 
   procedure BeforeNavigate2(pDisp:IDispatch;var URL:OleVariant;var Flags:OleVariant;var TargetFrameName:OleVariant;var PostData:OleVariant;var Headers:OleVariant;var Cancel:WordBool);dispid 250;
    // NewWindow2 : A new, hidden, non-navigated WebBrowser window is needed. 
   procedure NewWindow2(var ppDisp:IDispatch;var Cancel:WordBool);dispid 251;
    // NavigateComplete2 : Fired when the document being navigated to becomes visible and enters the navigation stack. 
   procedure NavigateComplete2(pDisp:IDispatch;var URL:OleVariant);dispid 252;
    // DocumentComplete : Fired when the document being navigated to reaches ReadyState_Complete. 
   procedure DocumentComplete(pDisp:IDispatch;var URL:OleVariant);dispid 259;
    // OnQuit : Fired when application is quiting. 
   procedure OnQuit;dispid 253;
    // OnVisible : Fired when the window should be shown/hidden 
   procedure OnVisible(Visible:WordBool);dispid 254;
    // OnToolBar : Fired when the toolbar  should be shown/hidden 
   procedure OnToolBar(ToolBar:WordBool);dispid 255;
    // OnMenuBar : Fired when the menubar should be shown/hidden 
   procedure OnMenuBar(MenuBar:WordBool);dispid 256;
    // OnStatusBar : Fired when the statusbar should be shown/hidden 
   procedure OnStatusBar(StatusBar:WordBool);dispid 257;
    // OnFullScreen : Fired when fullscreen mode should be on/off 
   procedure OnFullScreen(FullScreen:WordBool);dispid 258;
    // OnTheaterMode : Fired when theater mode should be on/off 
   procedure OnTheaterMode(TheaterMode:WordBool);dispid 260;
    // WindowSetResizable : Fired when the host window should allow/disallow resizing 
   procedure WindowSetResizable(Resizable:WordBool);dispid 262;
    // WindowSetLeft : Fired when the host window should change its Left coordinate 
   procedure WindowSetLeft(Left:Integer);dispid 264;
    // WindowSetTop : Fired when the host window should change its Top coordinate 
   procedure WindowSetTop(Top:Integer);dispid 265;
    // WindowSetWidth : Fired when the host window should change its width 
   procedure WindowSetWidth(Width:Integer);dispid 266;
    // WindowSetHeight : Fired when the host window should change its height 
   procedure WindowSetHeight(Height:Integer);dispid 267;
    // WindowClosing : Fired when the WebBrowser is about to be closed by script 
   procedure WindowClosing(IsChildWindow:WordBool;var Cancel:WordBool);dispid 263;
    // ClientToHostWindow : Fired to request client sizes be converted to host window sizes 
   procedure ClientToHostWindow(var CX:Integer;var CY:Integer);dispid 268;
    // SetSecureLockIcon : Fired to indicate the security level of the current web page contents 
   procedure SetSecureLockIcon(SecureLockIcon:Integer);dispid 269;
    // FileDownload : Fired to indicate the File Download dialog is opening 
   procedure FileDownload(ActiveDocument:WordBool;var Cancel:WordBool);dispid 270;
    // NavigateError : Fired when a binding error occurs (window or frameset element). 
   procedure NavigateError(pDisp:IDispatch;var URL:OleVariant;var Frame:OleVariant;var StatusCode:OleVariant;var Cancel:WordBool);dispid 271;
    // PrintTemplateInstantiation : Fired when a print template is instantiated. 
   procedure PrintTemplateInstantiation(pDisp:IDispatch);dispid 225;
    // PrintTemplateTeardown : Fired when a print template destroyed. 
   procedure PrintTemplateTeardown(pDisp:IDispatch);dispid 226;
    // UpdatePageStatus : Fired when a page is spooled. When it is fired can be changed by a custom template. 
   procedure UpdatePageStatus(pDisp:IDispatch;var nPage:OleVariant;var fDone:OleVariant);dispid 227;
    // PrivacyImpactedStateChange : Fired when the global privacy impacted state changes 
   procedure PrivacyImpactedStateChange(bImpacted:WordBool);dispid 272;
    // NewWindow3 : A new, hidden, non-navigated WebBrowser window is needed. 
   procedure NewWindow3(var ppDisp:IDispatch;var Cancel:WordBool;dwFlags:LongWord;bstrUrlContext:WideString;bstrUrl:WideString);dispid 273;
    // SetPhishingFilterStatus : Fired to indicate the progress and status of the Phishing Filter analysis of the current web page 
   procedure SetPhishingFilterStatus(PhishingFilterStatus:Integer);dispid 282;
    // WindowStateChanged : Fired to indicate that the browser window's visibility or enabled state has changed. 
   procedure WindowStateChanged(dwWindowStateFlags:LongWord;dwValidFlagsMask:LongWord);dispid 283;
    // NewProcess : A new, hidden, non-navigated process is created to handle the navigation. 
   procedure NewProcess(lCauseFlag:Integer;pWB2:IDispatch;var Cancel:WordBool);dispid 284;
    // ThirdPartyUrlBlocked : Fired when a third-party URL is blocked. 
   procedure ThirdPartyUrlBlocked(var URL:OleVariant;dwCount:LongWord);dispid 285;
    // RedirectXDomainBlocked : Fired when a x-domain redirect is blocked. 
   procedure RedirectXDomainBlocked(pDisp:IDispatch;var StartURL:OleVariant;var RedirectURL:OleVariant;var Frame:OleVariant;var StatusCode:OleVariant);dispid 286;
    // BeforeScriptExecute : Fired prior to the first script execution. 
   procedure BeforeScriptExecute(pDispWindow:IDispatch);dispid 290;
    // WebWorkerStarted : Fired after a Web Worker has been started. 
   procedure WebWorkerStarted(dwUniqueID:LongWord;bstrWorkerLabel:WideString);dispid 288;
    // WebWorkerFinsihed : Fired after a Web Worker has closed 
   procedure WebWorkerFinsihed(dwUniqueID:LongWord);dispid 289;
  end;


// DShellWindowsEvents : Event interface for IShellWindows

 DShellWindowsEvents = dispinterface
   ['{FE4106E0-399A-11D0-A48C-00A0C90A8F39}']
    // WindowRegistered : A new window was registered. 
   procedure WindowRegistered(lCookie:Integer);dispid 200;
    // WindowRevoked : A new window was revoked. 
   procedure WindowRevoked(lCookie:Integer);dispid 201;
  end;


// IShellWindows : Definition of interface IShellWindows

 IShellWindows = interface(IDispatch)
   ['{85CB6900-4D95-11CF-960C-0080C7F4EE85}']
   function Get_Count : Integer; safecall;
    // Item : Return the shell window for the given index 
   function Item(index:OleVariant):IDispatch;safecall;
    // _NewEnum : Enumerates the figures 
   function _NewEnum:IUnknown;safecall;
    // Register : Register a window with the list 
   procedure Register(pid:IDispatch;HWND:Integer;swClass:SYSINT;out plCookie:Integer);safecall;
    // RegisterPending : Register a pending open with the list 
   procedure RegisterPending(lThreadId:Integer;var pvarloc:OleVariant;var pvarlocRoot:OleVariant;swClass:SYSINT;out plCookie:Integer);safecall;
    // Revoke : Remove a window from the list 
   procedure Revoke(lCookie:Integer);safecall;
    // OnNavigate : Notifies the new location 
   procedure OnNavigate(lCookie:Integer;var pvarloc:OleVariant);safecall;
    // OnActivated : Notifies the activation 
   procedure OnActivated(lCookie:Integer;fActive:WordBool);safecall;
    // FindWindowSW : Find the window based on the location 
   function FindWindowSW(var pvarloc:OleVariant;var pvarlocRoot:OleVariant;swClass:SYSINT;out pHWND:Integer;swfwOptions:SYSINT):IDispatch;safecall;
    // OnCreated : Notifies on creation and frame name set 
   procedure OnCreated(lCookie:Integer;punk:IUnknown);safecall;
    // ProcessAttachDetach : Used by IExplore to register different processes 
   procedure ProcessAttachDetach(fAttach:WordBool);safecall;
    // Count : Get count of open Shell windows 
   property Count:Integer read Get_Count;
  end;


// IShellWindows : Definition of interface IShellWindows

 IShellWindowsDisp = dispinterface
   ['{85CB6900-4D95-11CF-960C-0080C7F4EE85}']
    // QueryInterface :  
   procedure QueryInterface(var riid:{!! GUID !!} OleVariant;out ppvObj:{!! Ppointer !!} OleVariant);dispid 1610612736;
    // AddRef :  
   function AddRef:LongWord;dispid 1610612737;
    // Release :  
   function Release:LongWord;dispid 1610612738;
    // GetTypeInfoCount :  
   procedure GetTypeInfoCount(out pctinfo:UInt);dispid 1610678272;
    // GetTypeInfo :  
   procedure GetTypeInfo(itinfo:UInt;lcid:LongWord;out pptinfo:{!! Ppointer !!} OleVariant);dispid 1610678273;
    // GetIDsOfNames :  
   procedure GetIDsOfNames(var riid:{!! GUID !!} OleVariant;var rgszNames:{!! PShortInt !!} OleVariant;cNames:UInt;lcid:LongWord;out rgdispid:Integer);dispid 1610678274;
    // Invoke :  
   procedure Invoke(dispidMember:Integer;var riid:{!! GUID !!} OleVariant;lcid:LongWord;wFlags:Word;var pdispparams:{!! DISPPARAMS !!} OleVariant;out pvarResult:OleVariant;out pexcepinfo:{!! EXCEPINFO !!} OleVariant;out puArgErr:UInt);dispid 1610678275;
    // Item : Return the shell window for the given index 
   function Item(index:OleVariant):IDispatch;dispid 0;
    // _NewEnum : Enumerates the figures 
   function _NewEnum:IUnknown;dispid -4;
    // Register : Register a window with the list 
   procedure Register(pid:IDispatch;HWND:Integer;swClass:SYSINT;out plCookie:Integer);dispid 1610743811;
    // RegisterPending : Register a pending open with the list 
   procedure RegisterPending(lThreadId:Integer;var pvarloc:OleVariant;var pvarlocRoot:OleVariant;swClass:SYSINT;out plCookie:Integer);dispid 1610743812;
    // Revoke : Remove a window from the list 
   procedure Revoke(lCookie:Integer);dispid 1610743813;
    // OnNavigate : Notifies the new location 
   procedure OnNavigate(lCookie:Integer;var pvarloc:OleVariant);dispid 1610743814;
    // OnActivated : Notifies the activation 
   procedure OnActivated(lCookie:Integer;fActive:WordBool);dispid 1610743815;
    // FindWindowSW : Find the window based on the location 
   function FindWindowSW(var pvarloc:OleVariant;var pvarlocRoot:OleVariant;swClass:SYSINT;out pHWND:Integer;swfwOptions:SYSINT):IDispatch;dispid 1610743816;
    // OnCreated : Notifies on creation and frame name set 
   procedure OnCreated(lCookie:Integer;punk:IUnknown);dispid 1610743817;
    // ProcessAttachDetach : Used by IExplore to register different processes 
   procedure ProcessAttachDetach(fAttach:WordBool);dispid 1610743818;
    // Count : Get count of open Shell windows 
   property Count:Integer  readonly dispid 1610743808;
  end;


// IShellUIHelper : Shell UI Helper Control Interface

 IShellUIHelper = interface(IDispatch)
   ['{729FE2F8-1EA8-11D1-8F85-00C04FC2FBE1}']
    // ResetFirstBootMode :  
   procedure ResetFirstBootMode;safecall;
    // ResetSafeMode :  
   procedure ResetSafeMode;safecall;
    // RefreshOfflineDesktop :  
   procedure RefreshOfflineDesktop;safecall;
    // AddFavorite :  
   procedure AddFavorite(URL:WideString;var Title:OleVariant);safecall;
    // AddChannel :  
   procedure AddChannel(URL:WideString);safecall;
    // AddDesktopComponent :  
   procedure AddDesktopComponent(URL:WideString;Type_:WideString;var Left:OleVariant;var Top:OleVariant;var Width:OleVariant;var Height:OleVariant);safecall;
    // IsSubscribed :  
   function IsSubscribed(URL:WideString):WordBool;safecall;
    // NavigateAndFind :  
   procedure NavigateAndFind(URL:WideString;strQuery:WideString;var varTargetFrame:OleVariant);safecall;
    // ImportExportFavorites :  
   procedure ImportExportFavorites(fImport:WordBool;strImpExpPath:WideString);safecall;
    // AutoCompleteSaveForm :  
   procedure AutoCompleteSaveForm(var Form:OleVariant);safecall;
    // AutoScan :  
   procedure AutoScan(strSearch:WideString;strFailureUrl:WideString;var pvarTargetFrame:OleVariant);safecall;
    // AutoCompleteAttach :  
   procedure AutoCompleteAttach(var Reserved:OleVariant);safecall;
    // ShowBrowserUI :  
   function ShowBrowserUI(bstrName:WideString;var pvarIn:OleVariant):OleVariant;safecall;
  end;


// IShellUIHelper : Shell UI Helper Control Interface

 IShellUIHelperDisp = dispinterface
   ['{729FE2F8-1EA8-11D1-8F85-00C04FC2FBE1}']
    // QueryInterface :  
   procedure QueryInterface(var riid:{!! GUID !!} OleVariant;out ppvObj:{!! Ppointer !!} OleVariant);dispid 1610612736;
    // AddRef :  
   function AddRef:LongWord;dispid 1610612737;
    // Release :  
   function Release:LongWord;dispid 1610612738;
    // GetTypeInfoCount :  
   procedure GetTypeInfoCount(out pctinfo:UInt);dispid 1610678272;
    // GetTypeInfo :  
   procedure GetTypeInfo(itinfo:UInt;lcid:LongWord;out pptinfo:{!! Ppointer !!} OleVariant);dispid 1610678273;
    // GetIDsOfNames :  
   procedure GetIDsOfNames(var riid:{!! GUID !!} OleVariant;var rgszNames:{!! PShortInt !!} OleVariant;cNames:UInt;lcid:LongWord;out rgdispid:Integer);dispid 1610678274;
    // Invoke :  
   procedure Invoke(dispidMember:Integer;var riid:{!! GUID !!} OleVariant;lcid:LongWord;wFlags:Word;var pdispparams:{!! DISPPARAMS !!} OleVariant;out pvarResult:OleVariant;out pexcepinfo:{!! EXCEPINFO !!} OleVariant;out puArgErr:UInt);dispid 1610678275;
    // ResetFirstBootMode :  
   procedure ResetFirstBootMode;dispid 1;
    // ResetSafeMode :  
   procedure ResetSafeMode;dispid 2;
    // RefreshOfflineDesktop :  
   procedure RefreshOfflineDesktop;dispid 3;
    // AddFavorite :  
   procedure AddFavorite(URL:WideString;var Title:OleVariant);dispid 4;
    // AddChannel :  
   procedure AddChannel(URL:WideString);dispid 5;
    // AddDesktopComponent :  
   procedure AddDesktopComponent(URL:WideString;Type_:WideString;var Left:OleVariant;var Top:OleVariant;var Width:OleVariant;var Height:OleVariant);dispid 6;
    // IsSubscribed :  
   function IsSubscribed(URL:WideString):WordBool;dispid 7;
    // NavigateAndFind :  
   procedure NavigateAndFind(URL:WideString;strQuery:WideString;var varTargetFrame:OleVariant);dispid 8;
    // ImportExportFavorites :  
   procedure ImportExportFavorites(fImport:WordBool;strImpExpPath:WideString);dispid 9;
    // AutoCompleteSaveForm :  
   procedure AutoCompleteSaveForm(var Form:OleVariant);dispid 10;
    // AutoScan :  
   procedure AutoScan(strSearch:WideString;strFailureUrl:WideString;var pvarTargetFrame:OleVariant);dispid 11;
    // AutoCompleteAttach :  
   procedure AutoCompleteAttach(var Reserved:OleVariant);dispid 12;
    // ShowBrowserUI :  
   function ShowBrowserUI(bstrName:WideString;var pvarIn:OleVariant):OleVariant;dispid 13;
  end;


// IShellUIHelper2 : Shell UI Helper Control Interface 2

 IShellUIHelper2 = interface(IShellUIHelper)
   ['{A7FE6EDA-1932-4281-B881-87B31B8BC52C}']
    // AddSearchProvider :  
   procedure AddSearchProvider(URL:WideString);safecall;
    // RunOnceShown :  
   procedure RunOnceShown;safecall;
    // SkipRunOnce :  
   procedure SkipRunOnce;safecall;
    // CustomizeSettings :  
   procedure CustomizeSettings(fSQM:WordBool;fPhishing:WordBool;bstrLocale:WideString);safecall;
    // SqmEnabled :  
   function SqmEnabled:WordBool;safecall;
    // PhishingEnabled :  
   function PhishingEnabled:WordBool;safecall;
    // BrandImageUri :  
   function BrandImageUri:WideString;safecall;
    // SkipTabsWelcome :  
   procedure SkipTabsWelcome;safecall;
    // DiagnoseConnection :  
   procedure DiagnoseConnection;safecall;
    // CustomizeClearType :  
   procedure CustomizeClearType(fSet:WordBool);safecall;
    // IsSearchProviderInstalled :  
   function IsSearchProviderInstalled(URL:WideString):LongWord;safecall;
    // IsSearchMigrated :  
   function IsSearchMigrated:WordBool;safecall;
    // DefaultSearchProvider :  
   function DefaultSearchProvider:WideString;safecall;
    // RunOnceRequiredSettingsComplete :  
   procedure RunOnceRequiredSettingsComplete(fComplete:WordBool);safecall;
    // RunOnceHasShown :  
   function RunOnceHasShown:WordBool;safecall;
    // SearchGuideUrl :  
   function SearchGuideUrl:WideString;safecall;
  end;


// IShellUIHelper2 : Shell UI Helper Control Interface 2

 IShellUIHelper2Disp = dispinterface
   ['{A7FE6EDA-1932-4281-B881-87B31B8BC52C}']
    // QueryInterface :  
   procedure QueryInterface(var riid:{!! GUID !!} OleVariant;out ppvObj:{!! Ppointer !!} OleVariant);dispid 1610612736;
    // AddRef :  
   function AddRef:LongWord;dispid 1610612737;
    // Release :  
   function Release:LongWord;dispid 1610612738;
    // GetTypeInfoCount :  
   procedure GetTypeInfoCount(out pctinfo:UInt);dispid 1610678272;
    // GetTypeInfo :  
   procedure GetTypeInfo(itinfo:UInt;lcid:LongWord;out pptinfo:{!! Ppointer !!} OleVariant);dispid 1610678273;
    // GetIDsOfNames :  
   procedure GetIDsOfNames(var riid:{!! GUID !!} OleVariant;var rgszNames:{!! PShortInt !!} OleVariant;cNames:UInt;lcid:LongWord;out rgdispid:Integer);dispid 1610678274;
    // Invoke :  
   procedure Invoke(dispidMember:Integer;var riid:{!! GUID !!} OleVariant;lcid:LongWord;wFlags:Word;var pdispparams:{!! DISPPARAMS !!} OleVariant;out pvarResult:OleVariant;out pexcepinfo:{!! EXCEPINFO !!} OleVariant;out puArgErr:UInt);dispid 1610678275;
    // ResetFirstBootMode :  
   procedure ResetFirstBootMode;dispid 1;
    // ResetSafeMode :  
   procedure ResetSafeMode;dispid 2;
    // RefreshOfflineDesktop :  
   procedure RefreshOfflineDesktop;dispid 3;
    // AddFavorite :  
   procedure AddFavorite(URL:WideString;var Title:OleVariant);dispid 4;
    // AddChannel :  
   procedure AddChannel(URL:WideString);dispid 5;
    // AddDesktopComponent :  
   procedure AddDesktopComponent(URL:WideString;Type_:WideString;var Left:OleVariant;var Top:OleVariant;var Width:OleVariant;var Height:OleVariant);dispid 6;
    // IsSubscribed :  
   function IsSubscribed(URL:WideString):WordBool;dispid 7;
    // NavigateAndFind :  
   procedure NavigateAndFind(URL:WideString;strQuery:WideString;var varTargetFrame:OleVariant);dispid 8;
    // ImportExportFavorites :  
   procedure ImportExportFavorites(fImport:WordBool;strImpExpPath:WideString);dispid 9;
    // AutoCompleteSaveForm :  
   procedure AutoCompleteSaveForm(var Form:OleVariant);dispid 10;
    // AutoScan :  
   procedure AutoScan(strSearch:WideString;strFailureUrl:WideString;var pvarTargetFrame:OleVariant);dispid 11;
    // AutoCompleteAttach :  
   procedure AutoCompleteAttach(var Reserved:OleVariant);dispid 12;
    // ShowBrowserUI :  
   function ShowBrowserUI(bstrName:WideString;var pvarIn:OleVariant):OleVariant;dispid 13;
    // AddSearchProvider :  
   procedure AddSearchProvider(URL:WideString);dispid 14;
    // RunOnceShown :  
   procedure RunOnceShown;dispid 15;
    // SkipRunOnce :  
   procedure SkipRunOnce;dispid 16;
    // CustomizeSettings :  
   procedure CustomizeSettings(fSQM:WordBool;fPhishing:WordBool;bstrLocale:WideString);dispid 17;
    // SqmEnabled :  
   function SqmEnabled:WordBool;dispid 18;
    // PhishingEnabled :  
   function PhishingEnabled:WordBool;dispid 19;
    // BrandImageUri :  
   function BrandImageUri:WideString;dispid 20;
    // SkipTabsWelcome :  
   procedure SkipTabsWelcome;dispid 21;
    // DiagnoseConnection :  
   procedure DiagnoseConnection;dispid 22;
    // CustomizeClearType :  
   procedure CustomizeClearType(fSet:WordBool);dispid 23;
    // IsSearchProviderInstalled :  
   function IsSearchProviderInstalled(URL:WideString):LongWord;dispid 24;
    // IsSearchMigrated :  
   function IsSearchMigrated:WordBool;dispid 25;
    // DefaultSearchProvider :  
   function DefaultSearchProvider:WideString;dispid 26;
    // RunOnceRequiredSettingsComplete :  
   procedure RunOnceRequiredSettingsComplete(fComplete:WordBool);dispid 27;
    // RunOnceHasShown :  
   function RunOnceHasShown:WordBool;dispid 28;
    // SearchGuideUrl :  
   function SearchGuideUrl:WideString;dispid 29;
  end;


// IShellUIHelper3 : Shell UI Helper Control Interface 3

 IShellUIHelper3 = interface(IShellUIHelper2)
   ['{528DF2EC-D419-40BC-9B6D-DCDBF9C1B25D}']
    // AddService :  
   procedure AddService(URL:WideString);safecall;
    // IsServiceInstalled :  
   function IsServiceInstalled(URL:WideString;Verb:WideString):LongWord;safecall;
    // InPrivateFilteringEnabled :  
   function InPrivateFilteringEnabled:WordBool;safecall;
    // AddToFavoritesBar :  
   procedure AddToFavoritesBar(URL:WideString;Title:WideString;var Type_:OleVariant);safecall;
    // BuildNewTabPage :  
   procedure BuildNewTabPage;safecall;
    // SetRecentlyClosedVisible :  
   procedure SetRecentlyClosedVisible(fVisible:WordBool);safecall;
    // SetActivitiesVisible :  
   procedure SetActivitiesVisible(fVisible:WordBool);safecall;
    // ContentDiscoveryReset :  
   procedure ContentDiscoveryReset;safecall;
    // IsSuggestedSitesEnabled :  
   function IsSuggestedSitesEnabled:WordBool;safecall;
    // EnableSuggestedSites :  
   procedure EnableSuggestedSites(fEnable:WordBool);safecall;
    // NavigateToSuggestedSites :  
   procedure NavigateToSuggestedSites(bstrRelativeUrl:WideString);safecall;
    // ShowTabsHelp :  
   procedure ShowTabsHelp;safecall;
    // ShowInPrivateHelp :  
   procedure ShowInPrivateHelp;safecall;
  end;


// IShellUIHelper3 : Shell UI Helper Control Interface 3

 IShellUIHelper3Disp = dispinterface
   ['{528DF2EC-D419-40BC-9B6D-DCDBF9C1B25D}']
    // QueryInterface :  
   procedure QueryInterface(var riid:{!! GUID !!} OleVariant;out ppvObj:{!! Ppointer !!} OleVariant);dispid 1610612736;
    // AddRef :  
   function AddRef:LongWord;dispid 1610612737;
    // Release :  
   function Release:LongWord;dispid 1610612738;
    // GetTypeInfoCount :  
   procedure GetTypeInfoCount(out pctinfo:UInt);dispid 1610678272;
    // GetTypeInfo :  
   procedure GetTypeInfo(itinfo:UInt;lcid:LongWord;out pptinfo:{!! Ppointer !!} OleVariant);dispid 1610678273;
    // GetIDsOfNames :  
   procedure GetIDsOfNames(var riid:{!! GUID !!} OleVariant;var rgszNames:{!! PShortInt !!} OleVariant;cNames:UInt;lcid:LongWord;out rgdispid:Integer);dispid 1610678274;
    // Invoke :  
   procedure Invoke(dispidMember:Integer;var riid:{!! GUID !!} OleVariant;lcid:LongWord;wFlags:Word;var pdispparams:{!! DISPPARAMS !!} OleVariant;out pvarResult:OleVariant;out pexcepinfo:{!! EXCEPINFO !!} OleVariant;out puArgErr:UInt);dispid 1610678275;
    // ResetFirstBootMode :  
   procedure ResetFirstBootMode;dispid 1;
    // ResetSafeMode :  
   procedure ResetSafeMode;dispid 2;
    // RefreshOfflineDesktop :  
   procedure RefreshOfflineDesktop;dispid 3;
    // AddFavorite :  
   procedure AddFavorite(URL:WideString;var Title:OleVariant);dispid 4;
    // AddChannel :  
   procedure AddChannel(URL:WideString);dispid 5;
    // AddDesktopComponent :  
   procedure AddDesktopComponent(URL:WideString;Type_:WideString;var Left:OleVariant;var Top:OleVariant;var Width:OleVariant;var Height:OleVariant);dispid 6;
    // IsSubscribed :  
   function IsSubscribed(URL:WideString):WordBool;dispid 7;
    // NavigateAndFind :  
   procedure NavigateAndFind(URL:WideString;strQuery:WideString;var varTargetFrame:OleVariant);dispid 8;
    // ImportExportFavorites :  
   procedure ImportExportFavorites(fImport:WordBool;strImpExpPath:WideString);dispid 9;
    // AutoCompleteSaveForm :  
   procedure AutoCompleteSaveForm(var Form:OleVariant);dispid 10;
    // AutoScan :  
   procedure AutoScan(strSearch:WideString;strFailureUrl:WideString;var pvarTargetFrame:OleVariant);dispid 11;
    // AutoCompleteAttach :  
   procedure AutoCompleteAttach(var Reserved:OleVariant);dispid 12;
    // ShowBrowserUI :  
   function ShowBrowserUI(bstrName:WideString;var pvarIn:OleVariant):OleVariant;dispid 13;
    // AddSearchProvider :  
   procedure AddSearchProvider(URL:WideString);dispid 14;
    // RunOnceShown :  
   procedure RunOnceShown;dispid 15;
    // SkipRunOnce :  
   procedure SkipRunOnce;dispid 16;
    // CustomizeSettings :  
   procedure CustomizeSettings(fSQM:WordBool;fPhishing:WordBool;bstrLocale:WideString);dispid 17;
    // SqmEnabled :  
   function SqmEnabled:WordBool;dispid 18;
    // PhishingEnabled :  
   function PhishingEnabled:WordBool;dispid 19;
    // BrandImageUri :  
   function BrandImageUri:WideString;dispid 20;
    // SkipTabsWelcome :  
   procedure SkipTabsWelcome;dispid 21;
    // DiagnoseConnection :  
   procedure DiagnoseConnection;dispid 22;
    // CustomizeClearType :  
   procedure CustomizeClearType(fSet:WordBool);dispid 23;
    // IsSearchProviderInstalled :  
   function IsSearchProviderInstalled(URL:WideString):LongWord;dispid 24;
    // IsSearchMigrated :  
   function IsSearchMigrated:WordBool;dispid 25;
    // DefaultSearchProvider :  
   function DefaultSearchProvider:WideString;dispid 26;
    // RunOnceRequiredSettingsComplete :  
   procedure RunOnceRequiredSettingsComplete(fComplete:WordBool);dispid 27;
    // RunOnceHasShown :  
   function RunOnceHasShown:WordBool;dispid 28;
    // SearchGuideUrl :  
   function SearchGuideUrl:WideString;dispid 29;
    // AddService :  
   procedure AddService(URL:WideString);dispid 30;
    // IsServiceInstalled :  
   function IsServiceInstalled(URL:WideString;Verb:WideString):LongWord;dispid 31;
    // InPrivateFilteringEnabled :  
   function InPrivateFilteringEnabled:WordBool;dispid 37;
    // AddToFavoritesBar :  
   procedure AddToFavoritesBar(URL:WideString;Title:WideString;var Type_:OleVariant);dispid 32;
    // BuildNewTabPage :  
   procedure BuildNewTabPage;dispid 33;
    // SetRecentlyClosedVisible :  
   procedure SetRecentlyClosedVisible(fVisible:WordBool);dispid 34;
    // SetActivitiesVisible :  
   procedure SetActivitiesVisible(fVisible:WordBool);dispid 35;
    // ContentDiscoveryReset :  
   procedure ContentDiscoveryReset;dispid 36;
    // IsSuggestedSitesEnabled :  
   function IsSuggestedSitesEnabled:WordBool;dispid 38;
    // EnableSuggestedSites :  
   procedure EnableSuggestedSites(fEnable:WordBool);dispid 39;
    // NavigateToSuggestedSites :  
   procedure NavigateToSuggestedSites(bstrRelativeUrl:WideString);dispid 40;
    // ShowTabsHelp :  
   procedure ShowTabsHelp;dispid 41;
    // ShowInPrivateHelp :  
   procedure ShowInPrivateHelp;dispid 42;
  end;


// IShellUIHelper4 : Shell UI Helper Control Interface 4

 IShellUIHelper4 = interface(IShellUIHelper3)
   ['{B36E6A53-8073-499E-824C-D776330A333E}']
    // msIsSiteMode :  
   function msIsSiteMode:WordBool;safecall;
    // msSiteModeShowThumbBar :  
   procedure msSiteModeShowThumbBar;safecall;
    // msSiteModeAddThumbBarButton :  
   function msSiteModeAddThumbBarButton(bstrIconURL:WideString;bstrTooltip:WideString):OleVariant;safecall;
    // msSiteModeUpdateThumbBarButton :  
   procedure msSiteModeUpdateThumbBarButton(ButtonID:OleVariant;fEnabled:WordBool;fVisible:WordBool);safecall;
    // msSiteModeSetIconOverlay :  
   procedure msSiteModeSetIconOverlay(IconUrl:WideString;var pvarDescription:OleVariant);safecall;
    // msSiteModeClearIconOverlay :  
   procedure msSiteModeClearIconOverlay;safecall;
    // msAddSiteMode :  
   procedure msAddSiteMode;safecall;
    // msSiteModeCreateJumpList :  
   procedure msSiteModeCreateJumpList(bstrHeader:WideString);safecall;
    // msSiteModeAddJumpListItem :  
   procedure msSiteModeAddJumpListItem(bstrName:WideString;bstrActionUri:WideString;bstrIconUri:WideString;var pvarWindowType:OleVariant);safecall;
    // msSiteModeClearJumpList :  
   procedure msSiteModeClearJumpList;safecall;
    // msSiteModeShowJumpList :  
   procedure msSiteModeShowJumpList;safecall;
    // msSiteModeAddButtonStyle :  
   function msSiteModeAddButtonStyle(uiButtonID:OleVariant;bstrIconURL:WideString;bstrTooltip:WideString):OleVariant;safecall;
    // msSiteModeShowButtonStyle :  
   procedure msSiteModeShowButtonStyle(uiButtonID:OleVariant;uiStyleID:OleVariant);safecall;
    // msSiteModeActivate :  
   procedure msSiteModeActivate;safecall;
    // msIsSiteModeFirstRun :  
   function msIsSiteModeFirstRun(fPreserveState:WordBool):OleVariant;safecall;
    // msAddTrackingProtectionList :  
   procedure msAddTrackingProtectionList(URL:WideString;bstrFilterName:WideString);safecall;
    // msTrackingProtectionEnabled :  
   function msTrackingProtectionEnabled:WordBool;safecall;
    // msActiveXFilteringEnabled :  
   function msActiveXFilteringEnabled:WordBool;safecall;
  end;


// IShellUIHelper4 : Shell UI Helper Control Interface 4

 IShellUIHelper4Disp = dispinterface
   ['{B36E6A53-8073-499E-824C-D776330A333E}']
    // QueryInterface :  
   procedure QueryInterface(var riid:{!! GUID !!} OleVariant;out ppvObj:{!! Ppointer !!} OleVariant);dispid 1610612736;
    // AddRef :  
   function AddRef:LongWord;dispid 1610612737;
    // Release :  
   function Release:LongWord;dispid 1610612738;
    // GetTypeInfoCount :  
   procedure GetTypeInfoCount(out pctinfo:UInt);dispid 1610678272;
    // GetTypeInfo :  
   procedure GetTypeInfo(itinfo:UInt;lcid:LongWord;out pptinfo:{!! Ppointer !!} OleVariant);dispid 1610678273;
    // GetIDsOfNames :  
   procedure GetIDsOfNames(var riid:{!! GUID !!} OleVariant;var rgszNames:{!! PShortInt !!} OleVariant;cNames:UInt;lcid:LongWord;out rgdispid:Integer);dispid 1610678274;
    // Invoke :  
   procedure Invoke(dispidMember:Integer;var riid:{!! GUID !!} OleVariant;lcid:LongWord;wFlags:Word;var pdispparams:{!! DISPPARAMS !!} OleVariant;out pvarResult:OleVariant;out pexcepinfo:{!! EXCEPINFO !!} OleVariant;out puArgErr:UInt);dispid 1610678275;
    // ResetFirstBootMode :  
   procedure ResetFirstBootMode;dispid 1;
    // ResetSafeMode :  
   procedure ResetSafeMode;dispid 2;
    // RefreshOfflineDesktop :  
   procedure RefreshOfflineDesktop;dispid 3;
    // AddFavorite :  
   procedure AddFavorite(URL:WideString;var Title:OleVariant);dispid 4;
    // AddChannel :  
   procedure AddChannel(URL:WideString);dispid 5;
    // AddDesktopComponent :  
   procedure AddDesktopComponent(URL:WideString;Type_:WideString;var Left:OleVariant;var Top:OleVariant;var Width:OleVariant;var Height:OleVariant);dispid 6;
    // IsSubscribed :  
   function IsSubscribed(URL:WideString):WordBool;dispid 7;
    // NavigateAndFind :  
   procedure NavigateAndFind(URL:WideString;strQuery:WideString;var varTargetFrame:OleVariant);dispid 8;
    // ImportExportFavorites :  
   procedure ImportExportFavorites(fImport:WordBool;strImpExpPath:WideString);dispid 9;
    // AutoCompleteSaveForm :  
   procedure AutoCompleteSaveForm(var Form:OleVariant);dispid 10;
    // AutoScan :  
   procedure AutoScan(strSearch:WideString;strFailureUrl:WideString;var pvarTargetFrame:OleVariant);dispid 11;
    // AutoCompleteAttach :  
   procedure AutoCompleteAttach(var Reserved:OleVariant);dispid 12;
    // ShowBrowserUI :  
   function ShowBrowserUI(bstrName:WideString;var pvarIn:OleVariant):OleVariant;dispid 13;
    // AddSearchProvider :  
   procedure AddSearchProvider(URL:WideString);dispid 14;
    // RunOnceShown :  
   procedure RunOnceShown;dispid 15;
    // SkipRunOnce :  
   procedure SkipRunOnce;dispid 16;
    // CustomizeSettings :  
   procedure CustomizeSettings(fSQM:WordBool;fPhishing:WordBool;bstrLocale:WideString);dispid 17;
    // SqmEnabled :  
   function SqmEnabled:WordBool;dispid 18;
    // PhishingEnabled :  
   function PhishingEnabled:WordBool;dispid 19;
    // BrandImageUri :  
   function BrandImageUri:WideString;dispid 20;
    // SkipTabsWelcome :  
   procedure SkipTabsWelcome;dispid 21;
    // DiagnoseConnection :  
   procedure DiagnoseConnection;dispid 22;
    // CustomizeClearType :  
   procedure CustomizeClearType(fSet:WordBool);dispid 23;
    // IsSearchProviderInstalled :  
   function IsSearchProviderInstalled(URL:WideString):LongWord;dispid 24;
    // IsSearchMigrated :  
   function IsSearchMigrated:WordBool;dispid 25;
    // DefaultSearchProvider :  
   function DefaultSearchProvider:WideString;dispid 26;
    // RunOnceRequiredSettingsComplete :  
   procedure RunOnceRequiredSettingsComplete(fComplete:WordBool);dispid 27;
    // RunOnceHasShown :  
   function RunOnceHasShown:WordBool;dispid 28;
    // SearchGuideUrl :  
   function SearchGuideUrl:WideString;dispid 29;
    // AddService :  
   procedure AddService(URL:WideString);dispid 30;
    // IsServiceInstalled :  
   function IsServiceInstalled(URL:WideString;Verb:WideString):LongWord;dispid 31;
    // InPrivateFilteringEnabled :  
   function InPrivateFilteringEnabled:WordBool;dispid 37;
    // AddToFavoritesBar :  
   procedure AddToFavoritesBar(URL:WideString;Title:WideString;var Type_:OleVariant);dispid 32;
    // BuildNewTabPage :  
   procedure BuildNewTabPage;dispid 33;
    // SetRecentlyClosedVisible :  
   procedure SetRecentlyClosedVisible(fVisible:WordBool);dispid 34;
    // SetActivitiesVisible :  
   procedure SetActivitiesVisible(fVisible:WordBool);dispid 35;
    // ContentDiscoveryReset :  
   procedure ContentDiscoveryReset;dispid 36;
    // IsSuggestedSitesEnabled :  
   function IsSuggestedSitesEnabled:WordBool;dispid 38;
    // EnableSuggestedSites :  
   procedure EnableSuggestedSites(fEnable:WordBool);dispid 39;
    // NavigateToSuggestedSites :  
   procedure NavigateToSuggestedSites(bstrRelativeUrl:WideString);dispid 40;
    // ShowTabsHelp :  
   procedure ShowTabsHelp;dispid 41;
    // ShowInPrivateHelp :  
   procedure ShowInPrivateHelp;dispid 42;
    // msIsSiteMode :  
   function msIsSiteMode:WordBool;dispid 43;
    // msSiteModeShowThumbBar :  
   procedure msSiteModeShowThumbBar;dispid 47;
    // msSiteModeAddThumbBarButton :  
   function msSiteModeAddThumbBarButton(bstrIconURL:WideString;bstrTooltip:WideString):OleVariant;dispid 48;
    // msSiteModeUpdateThumbBarButton :  
   procedure msSiteModeUpdateThumbBarButton(ButtonID:OleVariant;fEnabled:WordBool;fVisible:WordBool);dispid 46;
    // msSiteModeSetIconOverlay :  
   procedure msSiteModeSetIconOverlay(IconUrl:WideString;var pvarDescription:OleVariant);dispid 44;
    // msSiteModeClearIconOverlay :  
   procedure msSiteModeClearIconOverlay;dispid 45;
    // msAddSiteMode :  
   procedure msAddSiteMode;dispid 49;
    // msSiteModeCreateJumpList :  
   procedure msSiteModeCreateJumpList(bstrHeader:WideString);dispid 51;
    // msSiteModeAddJumpListItem :  
   procedure msSiteModeAddJumpListItem(bstrName:WideString;bstrActionUri:WideString;bstrIconUri:WideString;var pvarWindowType:OleVariant);dispid 52;
    // msSiteModeClearJumpList :  
   procedure msSiteModeClearJumpList;dispid 53;
    // msSiteModeShowJumpList :  
   procedure msSiteModeShowJumpList;dispid 56;
    // msSiteModeAddButtonStyle :  
   function msSiteModeAddButtonStyle(uiButtonID:OleVariant;bstrIconURL:WideString;bstrTooltip:WideString):OleVariant;dispid 54;
    // msSiteModeShowButtonStyle :  
   procedure msSiteModeShowButtonStyle(uiButtonID:OleVariant;uiStyleID:OleVariant);dispid 55;
    // msSiteModeActivate :  
   procedure msSiteModeActivate;dispid 58;
    // msIsSiteModeFirstRun :  
   function msIsSiteModeFirstRun(fPreserveState:WordBool):OleVariant;dispid 59;
    // msAddTrackingProtectionList :  
   procedure msAddTrackingProtectionList(URL:WideString;bstrFilterName:WideString);dispid 57;
    // msTrackingProtectionEnabled :  
   function msTrackingProtectionEnabled:WordBool;dispid 60;
    // msActiveXFilteringEnabled :  
   function msActiveXFilteringEnabled:WordBool;dispid 61;
  end;


// IShellUIHelper5 : Shell UI Helper Control Interface 5

 IShellUIHelper5 = interface(IShellUIHelper4)
   ['{A2A08B09-103D-4D3F-B91C-EA455CA82EFA}']
    // msProvisionNetworks :  
   function msProvisionNetworks(bstrProvisioningXml:WideString):OleVariant;safecall;
    // msReportSafeUrl :  
   procedure msReportSafeUrl;safecall;
    // msSiteModeRefreshBadge :  
   procedure msSiteModeRefreshBadge;safecall;
    // msSiteModeClearBadge :  
   procedure msSiteModeClearBadge;safecall;
    // msDiagnoseConnectionUILess :  
   procedure msDiagnoseConnectionUILess;safecall;
    // msLaunchNetworkClientHelp :  
   procedure msLaunchNetworkClientHelp;safecall;
    // msChangeDefaultBrowser :  
   procedure msChangeDefaultBrowser(fChange:WordBool);safecall;
  end;


// IShellUIHelper5 : Shell UI Helper Control Interface 5

 IShellUIHelper5Disp = dispinterface
   ['{A2A08B09-103D-4D3F-B91C-EA455CA82EFA}']
    // QueryInterface :  
   procedure QueryInterface(var riid:{!! GUID !!} OleVariant;out ppvObj:{!! Ppointer !!} OleVariant);dispid 1610612736;
    // AddRef :  
   function AddRef:LongWord;dispid 1610612737;
    // Release :  
   function Release:LongWord;dispid 1610612738;
    // GetTypeInfoCount :  
   procedure GetTypeInfoCount(out pctinfo:UInt);dispid 1610678272;
    // GetTypeInfo :  
   procedure GetTypeInfo(itinfo:UInt;lcid:LongWord;out pptinfo:{!! Ppointer !!} OleVariant);dispid 1610678273;
    // GetIDsOfNames :  
   procedure GetIDsOfNames(var riid:{!! GUID !!} OleVariant;var rgszNames:{!! PShortInt !!} OleVariant;cNames:UInt;lcid:LongWord;out rgdispid:Integer);dispid 1610678274;
    // Invoke :  
   procedure Invoke(dispidMember:Integer;var riid:{!! GUID !!} OleVariant;lcid:LongWord;wFlags:Word;var pdispparams:{!! DISPPARAMS !!} OleVariant;out pvarResult:OleVariant;out pexcepinfo:{!! EXCEPINFO !!} OleVariant;out puArgErr:UInt);dispid 1610678275;
    // ResetFirstBootMode :  
   procedure ResetFirstBootMode;dispid 1;
    // ResetSafeMode :  
   procedure ResetSafeMode;dispid 2;
    // RefreshOfflineDesktop :  
   procedure RefreshOfflineDesktop;dispid 3;
    // AddFavorite :  
   procedure AddFavorite(URL:WideString;var Title:OleVariant);dispid 4;
    // AddChannel :  
   procedure AddChannel(URL:WideString);dispid 5;
    // AddDesktopComponent :  
   procedure AddDesktopComponent(URL:WideString;Type_:WideString;var Left:OleVariant;var Top:OleVariant;var Width:OleVariant;var Height:OleVariant);dispid 6;
    // IsSubscribed :  
   function IsSubscribed(URL:WideString):WordBool;dispid 7;
    // NavigateAndFind :  
   procedure NavigateAndFind(URL:WideString;strQuery:WideString;var varTargetFrame:OleVariant);dispid 8;
    // ImportExportFavorites :  
   procedure ImportExportFavorites(fImport:WordBool;strImpExpPath:WideString);dispid 9;
    // AutoCompleteSaveForm :  
   procedure AutoCompleteSaveForm(var Form:OleVariant);dispid 10;
    // AutoScan :  
   procedure AutoScan(strSearch:WideString;strFailureUrl:WideString;var pvarTargetFrame:OleVariant);dispid 11;
    // AutoCompleteAttach :  
   procedure AutoCompleteAttach(var Reserved:OleVariant);dispid 12;
    // ShowBrowserUI :  
   function ShowBrowserUI(bstrName:WideString;var pvarIn:OleVariant):OleVariant;dispid 13;
    // AddSearchProvider :  
   procedure AddSearchProvider(URL:WideString);dispid 14;
    // RunOnceShown :  
   procedure RunOnceShown;dispid 15;
    // SkipRunOnce :  
   procedure SkipRunOnce;dispid 16;
    // CustomizeSettings :  
   procedure CustomizeSettings(fSQM:WordBool;fPhishing:WordBool;bstrLocale:WideString);dispid 17;
    // SqmEnabled :  
   function SqmEnabled:WordBool;dispid 18;
    // PhishingEnabled :  
   function PhishingEnabled:WordBool;dispid 19;
    // BrandImageUri :  
   function BrandImageUri:WideString;dispid 20;
    // SkipTabsWelcome :  
   procedure SkipTabsWelcome;dispid 21;
    // DiagnoseConnection :  
   procedure DiagnoseConnection;dispid 22;
    // CustomizeClearType :  
   procedure CustomizeClearType(fSet:WordBool);dispid 23;
    // IsSearchProviderInstalled :  
   function IsSearchProviderInstalled(URL:WideString):LongWord;dispid 24;
    // IsSearchMigrated :  
   function IsSearchMigrated:WordBool;dispid 25;
    // DefaultSearchProvider :  
   function DefaultSearchProvider:WideString;dispid 26;
    // RunOnceRequiredSettingsComplete :  
   procedure RunOnceRequiredSettingsComplete(fComplete:WordBool);dispid 27;
    // RunOnceHasShown :  
   function RunOnceHasShown:WordBool;dispid 28;
    // SearchGuideUrl :  
   function SearchGuideUrl:WideString;dispid 29;
    // AddService :  
   procedure AddService(URL:WideString);dispid 30;
    // IsServiceInstalled :  
   function IsServiceInstalled(URL:WideString;Verb:WideString):LongWord;dispid 31;
    // InPrivateFilteringEnabled :  
   function InPrivateFilteringEnabled:WordBool;dispid 37;
    // AddToFavoritesBar :  
   procedure AddToFavoritesBar(URL:WideString;Title:WideString;var Type_:OleVariant);dispid 32;
    // BuildNewTabPage :  
   procedure BuildNewTabPage;dispid 33;
    // SetRecentlyClosedVisible :  
   procedure SetRecentlyClosedVisible(fVisible:WordBool);dispid 34;
    // SetActivitiesVisible :  
   procedure SetActivitiesVisible(fVisible:WordBool);dispid 35;
    // ContentDiscoveryReset :  
   procedure ContentDiscoveryReset;dispid 36;
    // IsSuggestedSitesEnabled :  
   function IsSuggestedSitesEnabled:WordBool;dispid 38;
    // EnableSuggestedSites :  
   procedure EnableSuggestedSites(fEnable:WordBool);dispid 39;
    // NavigateToSuggestedSites :  
   procedure NavigateToSuggestedSites(bstrRelativeUrl:WideString);dispid 40;
    // ShowTabsHelp :  
   procedure ShowTabsHelp;dispid 41;
    // ShowInPrivateHelp :  
   procedure ShowInPrivateHelp;dispid 42;
    // msIsSiteMode :  
   function msIsSiteMode:WordBool;dispid 43;
    // msSiteModeShowThumbBar :  
   procedure msSiteModeShowThumbBar;dispid 47;
    // msSiteModeAddThumbBarButton :  
   function msSiteModeAddThumbBarButton(bstrIconURL:WideString;bstrTooltip:WideString):OleVariant;dispid 48;
    // msSiteModeUpdateThumbBarButton :  
   procedure msSiteModeUpdateThumbBarButton(ButtonID:OleVariant;fEnabled:WordBool;fVisible:WordBool);dispid 46;
    // msSiteModeSetIconOverlay :  
   procedure msSiteModeSetIconOverlay(IconUrl:WideString;var pvarDescription:OleVariant);dispid 44;
    // msSiteModeClearIconOverlay :  
   procedure msSiteModeClearIconOverlay;dispid 45;
    // msAddSiteMode :  
   procedure msAddSiteMode;dispid 49;
    // msSiteModeCreateJumpList :  
   procedure msSiteModeCreateJumpList(bstrHeader:WideString);dispid 51;
    // msSiteModeAddJumpListItem :  
   procedure msSiteModeAddJumpListItem(bstrName:WideString;bstrActionUri:WideString;bstrIconUri:WideString;var pvarWindowType:OleVariant);dispid 52;
    // msSiteModeClearJumpList :  
   procedure msSiteModeClearJumpList;dispid 53;
    // msSiteModeShowJumpList :  
   procedure msSiteModeShowJumpList;dispid 56;
    // msSiteModeAddButtonStyle :  
   function msSiteModeAddButtonStyle(uiButtonID:OleVariant;bstrIconURL:WideString;bstrTooltip:WideString):OleVariant;dispid 54;
    // msSiteModeShowButtonStyle :  
   procedure msSiteModeShowButtonStyle(uiButtonID:OleVariant;uiStyleID:OleVariant);dispid 55;
    // msSiteModeActivate :  
   procedure msSiteModeActivate;dispid 58;
    // msIsSiteModeFirstRun :  
   function msIsSiteModeFirstRun(fPreserveState:WordBool):OleVariant;dispid 59;
    // msAddTrackingProtectionList :  
   procedure msAddTrackingProtectionList(URL:WideString;bstrFilterName:WideString);dispid 57;
    // msTrackingProtectionEnabled :  
   function msTrackingProtectionEnabled:WordBool;dispid 60;
    // msActiveXFilteringEnabled :  
   function msActiveXFilteringEnabled:WordBool;dispid 61;
    // msProvisionNetworks :  
   function msProvisionNetworks(bstrProvisioningXml:WideString):OleVariant;dispid 62;
    // msReportSafeUrl :  
   procedure msReportSafeUrl;dispid 63;
    // msSiteModeRefreshBadge :  
   procedure msSiteModeRefreshBadge;dispid 64;
    // msSiteModeClearBadge :  
   procedure msSiteModeClearBadge;dispid 65;
    // msDiagnoseConnectionUILess :  
   procedure msDiagnoseConnectionUILess;dispid 66;
    // msLaunchNetworkClientHelp :  
   procedure msLaunchNetworkClientHelp;dispid 67;
    // msChangeDefaultBrowser :  
   procedure msChangeDefaultBrowser(fChange:WordBool);dispid 68;
  end;


// IShellUIHelper6 : Shell UI Helper Control Interface 6

 IShellUIHelper6 = interface(IShellUIHelper5)
   ['{987A573E-46EE-4E89-96AB-DDF7F8FDC98C}']
    // msStopPeriodicTileUpdate :  
   procedure msStopPeriodicTileUpdate;safecall;
    // msStartPeriodicTileUpdate :  
   procedure msStartPeriodicTileUpdate(pollingUris:OleVariant;startTime:OleVariant;uiUpdateRecurrence:OleVariant);safecall;
    // msStartPeriodicTileUpdateBatch :  
   procedure msStartPeriodicTileUpdateBatch(pollingUris:OleVariant;startTime:OleVariant;uiUpdateRecurrence:OleVariant);safecall;
    // msClearTile :  
   procedure msClearTile;safecall;
    // msEnableTileNotificationQueue :  
   procedure msEnableTileNotificationQueue(fChange:WordBool);safecall;
    // msPinnedSiteState :  
   function msPinnedSiteState:OleVariant;safecall;
    // msEnableTileNotificationQueueForSquare150x150 :  
   procedure msEnableTileNotificationQueueForSquare150x150(fChange:WordBool);safecall;
    // msEnableTileNotificationQueueForWide310x150 :  
   procedure msEnableTileNotificationQueueForWide310x150(fChange:WordBool);safecall;
    // msEnableTileNotificationQueueForSquare310x310 :  
   procedure msEnableTileNotificationQueueForSquare310x310(fChange:WordBool);safecall;
    // msScheduledTileNotification :  
   procedure msScheduledTileNotification(bstrNotificationXml:WideString;bstrNotificationId:WideString;bstrNotificationTag:WideString;startTime:OleVariant;expirationTime:OleVariant);safecall;
    // msRemoveScheduledTileNotification :  
   procedure msRemoveScheduledTileNotification(bstrNotificationId:WideString);safecall;
    // msStartPeriodicBadgeUpdate :  
   procedure msStartPeriodicBadgeUpdate(pollingUri:WideString;startTime:OleVariant;uiUpdateRecurrence:OleVariant);safecall;
    // msStopPeriodicBadgeUpdate :  
   procedure msStopPeriodicBadgeUpdate;safecall;
    // msLaunchInternetOptions :  
   procedure msLaunchInternetOptions;safecall;
  end;


// IShellUIHelper6 : Shell UI Helper Control Interface 6

 IShellUIHelper6Disp = dispinterface
   ['{987A573E-46EE-4E89-96AB-DDF7F8FDC98C}']
    // QueryInterface :  
   procedure QueryInterface(var riid:{!! GUID !!} OleVariant;out ppvObj:{!! Ppointer !!} OleVariant);dispid 1610612736;
    // AddRef :  
   function AddRef:LongWord;dispid 1610612737;
    // Release :  
   function Release:LongWord;dispid 1610612738;
    // GetTypeInfoCount :  
   procedure GetTypeInfoCount(out pctinfo:UInt);dispid 1610678272;
    // GetTypeInfo :  
   procedure GetTypeInfo(itinfo:UInt;lcid:LongWord;out pptinfo:{!! Ppointer !!} OleVariant);dispid 1610678273;
    // GetIDsOfNames :  
   procedure GetIDsOfNames(var riid:{!! GUID !!} OleVariant;var rgszNames:{!! PShortInt !!} OleVariant;cNames:UInt;lcid:LongWord;out rgdispid:Integer);dispid 1610678274;
    // Invoke :  
   procedure Invoke(dispidMember:Integer;var riid:{!! GUID !!} OleVariant;lcid:LongWord;wFlags:Word;var pdispparams:{!! DISPPARAMS !!} OleVariant;out pvarResult:OleVariant;out pexcepinfo:{!! EXCEPINFO !!} OleVariant;out puArgErr:UInt);dispid 1610678275;
    // ResetFirstBootMode :  
   procedure ResetFirstBootMode;dispid 1;
    // ResetSafeMode :  
   procedure ResetSafeMode;dispid 2;
    // RefreshOfflineDesktop :  
   procedure RefreshOfflineDesktop;dispid 3;
    // AddFavorite :  
   procedure AddFavorite(URL:WideString;var Title:OleVariant);dispid 4;
    // AddChannel :  
   procedure AddChannel(URL:WideString);dispid 5;
    // AddDesktopComponent :  
   procedure AddDesktopComponent(URL:WideString;Type_:WideString;var Left:OleVariant;var Top:OleVariant;var Width:OleVariant;var Height:OleVariant);dispid 6;
    // IsSubscribed :  
   function IsSubscribed(URL:WideString):WordBool;dispid 7;
    // NavigateAndFind :  
   procedure NavigateAndFind(URL:WideString;strQuery:WideString;var varTargetFrame:OleVariant);dispid 8;
    // ImportExportFavorites :  
   procedure ImportExportFavorites(fImport:WordBool;strImpExpPath:WideString);dispid 9;
    // AutoCompleteSaveForm :  
   procedure AutoCompleteSaveForm(var Form:OleVariant);dispid 10;
    // AutoScan :  
   procedure AutoScan(strSearch:WideString;strFailureUrl:WideString;var pvarTargetFrame:OleVariant);dispid 11;
    // AutoCompleteAttach :  
   procedure AutoCompleteAttach(var Reserved:OleVariant);dispid 12;
    // ShowBrowserUI :  
   function ShowBrowserUI(bstrName:WideString;var pvarIn:OleVariant):OleVariant;dispid 13;
    // AddSearchProvider :  
   procedure AddSearchProvider(URL:WideString);dispid 14;
    // RunOnceShown :  
   procedure RunOnceShown;dispid 15;
    // SkipRunOnce :  
   procedure SkipRunOnce;dispid 16;
    // CustomizeSettings :  
   procedure CustomizeSettings(fSQM:WordBool;fPhishing:WordBool;bstrLocale:WideString);dispid 17;
    // SqmEnabled :  
   function SqmEnabled:WordBool;dispid 18;
    // PhishingEnabled :  
   function PhishingEnabled:WordBool;dispid 19;
    // BrandImageUri :  
   function BrandImageUri:WideString;dispid 20;
    // SkipTabsWelcome :  
   procedure SkipTabsWelcome;dispid 21;
    // DiagnoseConnection :  
   procedure DiagnoseConnection;dispid 22;
    // CustomizeClearType :  
   procedure CustomizeClearType(fSet:WordBool);dispid 23;
    // IsSearchProviderInstalled :  
   function IsSearchProviderInstalled(URL:WideString):LongWord;dispid 24;
    // IsSearchMigrated :  
   function IsSearchMigrated:WordBool;dispid 25;
    // DefaultSearchProvider :  
   function DefaultSearchProvider:WideString;dispid 26;
    // RunOnceRequiredSettingsComplete :  
   procedure RunOnceRequiredSettingsComplete(fComplete:WordBool);dispid 27;
    // RunOnceHasShown :  
   function RunOnceHasShown:WordBool;dispid 28;
    // SearchGuideUrl :  
   function SearchGuideUrl:WideString;dispid 29;
    // AddService :  
   procedure AddService(URL:WideString);dispid 30;
    // IsServiceInstalled :  
   function IsServiceInstalled(URL:WideString;Verb:WideString):LongWord;dispid 31;
    // InPrivateFilteringEnabled :  
   function InPrivateFilteringEnabled:WordBool;dispid 37;
    // AddToFavoritesBar :  
   procedure AddToFavoritesBar(URL:WideString;Title:WideString;var Type_:OleVariant);dispid 32;
    // BuildNewTabPage :  
   procedure BuildNewTabPage;dispid 33;
    // SetRecentlyClosedVisible :  
   procedure SetRecentlyClosedVisible(fVisible:WordBool);dispid 34;
    // SetActivitiesVisible :  
   procedure SetActivitiesVisible(fVisible:WordBool);dispid 35;
    // ContentDiscoveryReset :  
   procedure ContentDiscoveryReset;dispid 36;
    // IsSuggestedSitesEnabled :  
   function IsSuggestedSitesEnabled:WordBool;dispid 38;
    // EnableSuggestedSites :  
   procedure EnableSuggestedSites(fEnable:WordBool);dispid 39;
    // NavigateToSuggestedSites :  
   procedure NavigateToSuggestedSites(bstrRelativeUrl:WideString);dispid 40;
    // ShowTabsHelp :  
   procedure ShowTabsHelp;dispid 41;
    // ShowInPrivateHelp :  
   procedure ShowInPrivateHelp;dispid 42;
    // msIsSiteMode :  
   function msIsSiteMode:WordBool;dispid 43;
    // msSiteModeShowThumbBar :  
   procedure msSiteModeShowThumbBar;dispid 47;
    // msSiteModeAddThumbBarButton :  
   function msSiteModeAddThumbBarButton(bstrIconURL:WideString;bstrTooltip:WideString):OleVariant;dispid 48;
    // msSiteModeUpdateThumbBarButton :  
   procedure msSiteModeUpdateThumbBarButton(ButtonID:OleVariant;fEnabled:WordBool;fVisible:WordBool);dispid 46;
    // msSiteModeSetIconOverlay :  
   procedure msSiteModeSetIconOverlay(IconUrl:WideString;var pvarDescription:OleVariant);dispid 44;
    // msSiteModeClearIconOverlay :  
   procedure msSiteModeClearIconOverlay;dispid 45;
    // msAddSiteMode :  
   procedure msAddSiteMode;dispid 49;
    // msSiteModeCreateJumpList :  
   procedure msSiteModeCreateJumpList(bstrHeader:WideString);dispid 51;
    // msSiteModeAddJumpListItem :  
   procedure msSiteModeAddJumpListItem(bstrName:WideString;bstrActionUri:WideString;bstrIconUri:WideString;var pvarWindowType:OleVariant);dispid 52;
    // msSiteModeClearJumpList :  
   procedure msSiteModeClearJumpList;dispid 53;
    // msSiteModeShowJumpList :  
   procedure msSiteModeShowJumpList;dispid 56;
    // msSiteModeAddButtonStyle :  
   function msSiteModeAddButtonStyle(uiButtonID:OleVariant;bstrIconURL:WideString;bstrTooltip:WideString):OleVariant;dispid 54;
    // msSiteModeShowButtonStyle :  
   procedure msSiteModeShowButtonStyle(uiButtonID:OleVariant;uiStyleID:OleVariant);dispid 55;
    // msSiteModeActivate :  
   procedure msSiteModeActivate;dispid 58;
    // msIsSiteModeFirstRun :  
   function msIsSiteModeFirstRun(fPreserveState:WordBool):OleVariant;dispid 59;
    // msAddTrackingProtectionList :  
   procedure msAddTrackingProtectionList(URL:WideString;bstrFilterName:WideString);dispid 57;
    // msTrackingProtectionEnabled :  
   function msTrackingProtectionEnabled:WordBool;dispid 60;
    // msActiveXFilteringEnabled :  
   function msActiveXFilteringEnabled:WordBool;dispid 61;
    // msProvisionNetworks :  
   function msProvisionNetworks(bstrProvisioningXml:WideString):OleVariant;dispid 62;
    // msReportSafeUrl :  
   procedure msReportSafeUrl;dispid 63;
    // msSiteModeRefreshBadge :  
   procedure msSiteModeRefreshBadge;dispid 64;
    // msSiteModeClearBadge :  
   procedure msSiteModeClearBadge;dispid 65;
    // msDiagnoseConnectionUILess :  
   procedure msDiagnoseConnectionUILess;dispid 66;
    // msLaunchNetworkClientHelp :  
   procedure msLaunchNetworkClientHelp;dispid 67;
    // msChangeDefaultBrowser :  
   procedure msChangeDefaultBrowser(fChange:WordBool);dispid 68;
    // msStopPeriodicTileUpdate :  
   procedure msStopPeriodicTileUpdate;dispid 69;
    // msStartPeriodicTileUpdate :  
   procedure msStartPeriodicTileUpdate(pollingUris:OleVariant;startTime:OleVariant;uiUpdateRecurrence:OleVariant);dispid 70;
    // msStartPeriodicTileUpdateBatch :  
   procedure msStartPeriodicTileUpdateBatch(pollingUris:OleVariant;startTime:OleVariant;uiUpdateRecurrence:OleVariant);dispid 75;
    // msClearTile :  
   procedure msClearTile;dispid 71;
    // msEnableTileNotificationQueue :  
   procedure msEnableTileNotificationQueue(fChange:WordBool);dispid 72;
    // msPinnedSiteState :  
   function msPinnedSiteState:OleVariant;dispid 73;
    // msEnableTileNotificationQueueForSquare150x150 :  
   procedure msEnableTileNotificationQueueForSquare150x150(fChange:WordBool);dispid 76;
    // msEnableTileNotificationQueueForWide310x150 :  
   procedure msEnableTileNotificationQueueForWide310x150(fChange:WordBool);dispid 77;
    // msEnableTileNotificationQueueForSquare310x310 :  
   procedure msEnableTileNotificationQueueForSquare310x310(fChange:WordBool);dispid 78;
    // msScheduledTileNotification :  
   procedure msScheduledTileNotification(bstrNotificationXml:WideString;bstrNotificationId:WideString;bstrNotificationTag:WideString;startTime:OleVariant;expirationTime:OleVariant);dispid 79;
    // msRemoveScheduledTileNotification :  
   procedure msRemoveScheduledTileNotification(bstrNotificationId:WideString);dispid 80;
    // msStartPeriodicBadgeUpdate :  
   procedure msStartPeriodicBadgeUpdate(pollingUri:WideString;startTime:OleVariant;uiUpdateRecurrence:OleVariant);dispid 81;
    // msStopPeriodicBadgeUpdate :  
   procedure msStopPeriodicBadgeUpdate;dispid 82;
    // msLaunchInternetOptions :  
   procedure msLaunchInternetOptions;dispid 74;
  end;


// IShellUIHelper7 : Shell UI Helper Control Interface 7

 IShellUIHelper7 = interface(IShellUIHelper6)
   ['{60E567C8-9573-4AB2-A264-637C6C161CB1}']
    // SetExperimentalFlag :  
   procedure SetExperimentalFlag(bstrFlagString:WideString;vfFlag:WordBool);safecall;
    // GetExperimentalFlag :  
   function GetExperimentalFlag(bstrFlagString:WideString):WordBool;safecall;
    // SetExperimentalValue :  
   procedure SetExperimentalValue(bstrValueString:WideString;dwValue:LongWord);safecall;
    // GetExperimentalValue :  
   function GetExperimentalValue(bstrValueString:WideString):LongWord;safecall;
    // ResetAllExperimentalFlagsAndValues :  
   procedure ResetAllExperimentalFlagsAndValues;safecall;
    // GetNeedIEAutoLaunchFlag :  
   function GetNeedIEAutoLaunchFlag(bstrUrl:WideString):WordBool;safecall;
    // SetNeedIEAutoLaunchFlag :  
   procedure SetNeedIEAutoLaunchFlag(bstrUrl:WideString;flag:WordBool);safecall;
    // HasNeedIEAutoLaunchFlag :  
   function HasNeedIEAutoLaunchFlag(bstrUrl:WideString):WordBool;safecall;
    // LaunchIE :  
   procedure LaunchIE(bstrUrl:WideString;automated:WordBool);safecall;
  end;


// IShellUIHelper7 : Shell UI Helper Control Interface 7

 IShellUIHelper7Disp = dispinterface
   ['{60E567C8-9573-4AB2-A264-637C6C161CB1}']
    // QueryInterface :  
   procedure QueryInterface(var riid:{!! GUID !!} OleVariant;out ppvObj:{!! Ppointer !!} OleVariant);dispid 1610612736;
    // AddRef :  
   function AddRef:LongWord;dispid 1610612737;
    // Release :  
   function Release:LongWord;dispid 1610612738;
    // GetTypeInfoCount :  
   procedure GetTypeInfoCount(out pctinfo:UInt);dispid 1610678272;
    // GetTypeInfo :  
   procedure GetTypeInfo(itinfo:UInt;lcid:LongWord;out pptinfo:{!! Ppointer !!} OleVariant);dispid 1610678273;
    // GetIDsOfNames :  
   procedure GetIDsOfNames(var riid:{!! GUID !!} OleVariant;var rgszNames:{!! PShortInt !!} OleVariant;cNames:UInt;lcid:LongWord;out rgdispid:Integer);dispid 1610678274;
    // Invoke :  
   procedure Invoke(dispidMember:Integer;var riid:{!! GUID !!} OleVariant;lcid:LongWord;wFlags:Word;var pdispparams:{!! DISPPARAMS !!} OleVariant;out pvarResult:OleVariant;out pexcepinfo:{!! EXCEPINFO !!} OleVariant;out puArgErr:UInt);dispid 1610678275;
    // ResetFirstBootMode :  
   procedure ResetFirstBootMode;dispid 1;
    // ResetSafeMode :  
   procedure ResetSafeMode;dispid 2;
    // RefreshOfflineDesktop :  
   procedure RefreshOfflineDesktop;dispid 3;
    // AddFavorite :  
   procedure AddFavorite(URL:WideString;var Title:OleVariant);dispid 4;
    // AddChannel :  
   procedure AddChannel(URL:WideString);dispid 5;
    // AddDesktopComponent :  
   procedure AddDesktopComponent(URL:WideString;Type_:WideString;var Left:OleVariant;var Top:OleVariant;var Width:OleVariant;var Height:OleVariant);dispid 6;
    // IsSubscribed :  
   function IsSubscribed(URL:WideString):WordBool;dispid 7;
    // NavigateAndFind :  
   procedure NavigateAndFind(URL:WideString;strQuery:WideString;var varTargetFrame:OleVariant);dispid 8;
    // ImportExportFavorites :  
   procedure ImportExportFavorites(fImport:WordBool;strImpExpPath:WideString);dispid 9;
    // AutoCompleteSaveForm :  
   procedure AutoCompleteSaveForm(var Form:OleVariant);dispid 10;
    // AutoScan :  
   procedure AutoScan(strSearch:WideString;strFailureUrl:WideString;var pvarTargetFrame:OleVariant);dispid 11;
    // AutoCompleteAttach :  
   procedure AutoCompleteAttach(var Reserved:OleVariant);dispid 12;
    // ShowBrowserUI :  
   function ShowBrowserUI(bstrName:WideString;var pvarIn:OleVariant):OleVariant;dispid 13;
    // AddSearchProvider :  
   procedure AddSearchProvider(URL:WideString);dispid 14;
    // RunOnceShown :  
   procedure RunOnceShown;dispid 15;
    // SkipRunOnce :  
   procedure SkipRunOnce;dispid 16;
    // CustomizeSettings :  
   procedure CustomizeSettings(fSQM:WordBool;fPhishing:WordBool;bstrLocale:WideString);dispid 17;
    // SqmEnabled :  
   function SqmEnabled:WordBool;dispid 18;
    // PhishingEnabled :  
   function PhishingEnabled:WordBool;dispid 19;
    // BrandImageUri :  
   function BrandImageUri:WideString;dispid 20;
    // SkipTabsWelcome :  
   procedure SkipTabsWelcome;dispid 21;
    // DiagnoseConnection :  
   procedure DiagnoseConnection;dispid 22;
    // CustomizeClearType :  
   procedure CustomizeClearType(fSet:WordBool);dispid 23;
    // IsSearchProviderInstalled :  
   function IsSearchProviderInstalled(URL:WideString):LongWord;dispid 24;
    // IsSearchMigrated :  
   function IsSearchMigrated:WordBool;dispid 25;
    // DefaultSearchProvider :  
   function DefaultSearchProvider:WideString;dispid 26;
    // RunOnceRequiredSettingsComplete :  
   procedure RunOnceRequiredSettingsComplete(fComplete:WordBool);dispid 27;
    // RunOnceHasShown :  
   function RunOnceHasShown:WordBool;dispid 28;
    // SearchGuideUrl :  
   function SearchGuideUrl:WideString;dispid 29;
    // AddService :  
   procedure AddService(URL:WideString);dispid 30;
    // IsServiceInstalled :  
   function IsServiceInstalled(URL:WideString;Verb:WideString):LongWord;dispid 31;
    // InPrivateFilteringEnabled :  
   function InPrivateFilteringEnabled:WordBool;dispid 37;
    // AddToFavoritesBar :  
   procedure AddToFavoritesBar(URL:WideString;Title:WideString;var Type_:OleVariant);dispid 32;
    // BuildNewTabPage :  
   procedure BuildNewTabPage;dispid 33;
    // SetRecentlyClosedVisible :  
   procedure SetRecentlyClosedVisible(fVisible:WordBool);dispid 34;
    // SetActivitiesVisible :  
   procedure SetActivitiesVisible(fVisible:WordBool);dispid 35;
    // ContentDiscoveryReset :  
   procedure ContentDiscoveryReset;dispid 36;
    // IsSuggestedSitesEnabled :  
   function IsSuggestedSitesEnabled:WordBool;dispid 38;
    // EnableSuggestedSites :  
   procedure EnableSuggestedSites(fEnable:WordBool);dispid 39;
    // NavigateToSuggestedSites :  
   procedure NavigateToSuggestedSites(bstrRelativeUrl:WideString);dispid 40;
    // ShowTabsHelp :  
   procedure ShowTabsHelp;dispid 41;
    // ShowInPrivateHelp :  
   procedure ShowInPrivateHelp;dispid 42;
    // msIsSiteMode :  
   function msIsSiteMode:WordBool;dispid 43;
    // msSiteModeShowThumbBar :  
   procedure msSiteModeShowThumbBar;dispid 47;
    // msSiteModeAddThumbBarButton :  
   function msSiteModeAddThumbBarButton(bstrIconURL:WideString;bstrTooltip:WideString):OleVariant;dispid 48;
    // msSiteModeUpdateThumbBarButton :  
   procedure msSiteModeUpdateThumbBarButton(ButtonID:OleVariant;fEnabled:WordBool;fVisible:WordBool);dispid 46;
    // msSiteModeSetIconOverlay :  
   procedure msSiteModeSetIconOverlay(IconUrl:WideString;var pvarDescription:OleVariant);dispid 44;
    // msSiteModeClearIconOverlay :  
   procedure msSiteModeClearIconOverlay;dispid 45;
    // msAddSiteMode :  
   procedure msAddSiteMode;dispid 49;
    // msSiteModeCreateJumpList :  
   procedure msSiteModeCreateJumpList(bstrHeader:WideString);dispid 51;
    // msSiteModeAddJumpListItem :  
   procedure msSiteModeAddJumpListItem(bstrName:WideString;bstrActionUri:WideString;bstrIconUri:WideString;var pvarWindowType:OleVariant);dispid 52;
    // msSiteModeClearJumpList :  
   procedure msSiteModeClearJumpList;dispid 53;
    // msSiteModeShowJumpList :  
   procedure msSiteModeShowJumpList;dispid 56;
    // msSiteModeAddButtonStyle :  
   function msSiteModeAddButtonStyle(uiButtonID:OleVariant;bstrIconURL:WideString;bstrTooltip:WideString):OleVariant;dispid 54;
    // msSiteModeShowButtonStyle :  
   procedure msSiteModeShowButtonStyle(uiButtonID:OleVariant;uiStyleID:OleVariant);dispid 55;
    // msSiteModeActivate :  
   procedure msSiteModeActivate;dispid 58;
    // msIsSiteModeFirstRun :  
   function msIsSiteModeFirstRun(fPreserveState:WordBool):OleVariant;dispid 59;
    // msAddTrackingProtectionList :  
   procedure msAddTrackingProtectionList(URL:WideString;bstrFilterName:WideString);dispid 57;
    // msTrackingProtectionEnabled :  
   function msTrackingProtectionEnabled:WordBool;dispid 60;
    // msActiveXFilteringEnabled :  
   function msActiveXFilteringEnabled:WordBool;dispid 61;
    // msProvisionNetworks :  
   function msProvisionNetworks(bstrProvisioningXml:WideString):OleVariant;dispid 62;
    // msReportSafeUrl :  
   procedure msReportSafeUrl;dispid 63;
    // msSiteModeRefreshBadge :  
   procedure msSiteModeRefreshBadge;dispid 64;
    // msSiteModeClearBadge :  
   procedure msSiteModeClearBadge;dispid 65;
    // msDiagnoseConnectionUILess :  
   procedure msDiagnoseConnectionUILess;dispid 66;
    // msLaunchNetworkClientHelp :  
   procedure msLaunchNetworkClientHelp;dispid 67;
    // msChangeDefaultBrowser :  
   procedure msChangeDefaultBrowser(fChange:WordBool);dispid 68;
    // msStopPeriodicTileUpdate :  
   procedure msStopPeriodicTileUpdate;dispid 69;
    // msStartPeriodicTileUpdate :  
   procedure msStartPeriodicTileUpdate(pollingUris:OleVariant;startTime:OleVariant;uiUpdateRecurrence:OleVariant);dispid 70;
    // msStartPeriodicTileUpdateBatch :  
   procedure msStartPeriodicTileUpdateBatch(pollingUris:OleVariant;startTime:OleVariant;uiUpdateRecurrence:OleVariant);dispid 75;
    // msClearTile :  
   procedure msClearTile;dispid 71;
    // msEnableTileNotificationQueue :  
   procedure msEnableTileNotificationQueue(fChange:WordBool);dispid 72;
    // msPinnedSiteState :  
   function msPinnedSiteState:OleVariant;dispid 73;
    // msEnableTileNotificationQueueForSquare150x150 :  
   procedure msEnableTileNotificationQueueForSquare150x150(fChange:WordBool);dispid 76;
    // msEnableTileNotificationQueueForWide310x150 :  
   procedure msEnableTileNotificationQueueForWide310x150(fChange:WordBool);dispid 77;
    // msEnableTileNotificationQueueForSquare310x310 :  
   procedure msEnableTileNotificationQueueForSquare310x310(fChange:WordBool);dispid 78;
    // msScheduledTileNotification :  
   procedure msScheduledTileNotification(bstrNotificationXml:WideString;bstrNotificationId:WideString;bstrNotificationTag:WideString;startTime:OleVariant;expirationTime:OleVariant);dispid 79;
    // msRemoveScheduledTileNotification :  
   procedure msRemoveScheduledTileNotification(bstrNotificationId:WideString);dispid 80;
    // msStartPeriodicBadgeUpdate :  
   procedure msStartPeriodicBadgeUpdate(pollingUri:WideString;startTime:OleVariant;uiUpdateRecurrence:OleVariant);dispid 81;
    // msStopPeriodicBadgeUpdate :  
   procedure msStopPeriodicBadgeUpdate;dispid 82;
    // msLaunchInternetOptions :  
   procedure msLaunchInternetOptions;dispid 74;
    // SetExperimentalFlag :  
   procedure SetExperimentalFlag(bstrFlagString:WideString;vfFlag:WordBool);dispid 85;
    // GetExperimentalFlag :  
   function GetExperimentalFlag(bstrFlagString:WideString):WordBool;dispid 84;
    // SetExperimentalValue :  
   procedure SetExperimentalValue(bstrValueString:WideString;dwValue:LongWord);dispid 86;
    // GetExperimentalValue :  
   function GetExperimentalValue(bstrValueString:WideString):LongWord;dispid 87;
    // ResetAllExperimentalFlagsAndValues :  
   procedure ResetAllExperimentalFlagsAndValues;dispid 92;
    // GetNeedIEAutoLaunchFlag :  
   function GetNeedIEAutoLaunchFlag(bstrUrl:WideString):WordBool;dispid 89;
    // SetNeedIEAutoLaunchFlag :  
   procedure SetNeedIEAutoLaunchFlag(bstrUrl:WideString;flag:WordBool);dispid 90;
    // HasNeedIEAutoLaunchFlag :  
   function HasNeedIEAutoLaunchFlag(bstrUrl:WideString):WordBool;dispid 88;
    // LaunchIE :  
   procedure LaunchIE(bstrUrl:WideString;automated:WordBool);dispid 91;
  end;


// IShellUIHelper8 : Shell UI Helper Control Interface 8

 IShellUIHelper8 = interface(IShellUIHelper7)
   ['{66DEBCF2-05B0-4F07-B49B-B96241A65DB2}']
    // GetCVListData :  
   function GetCVListData:WideString;safecall;
    // GetCVListLocalData :  
   function GetCVListLocalData:WideString;safecall;
    // GetEMIEListData :  
   function GetEMIEListData:WideString;safecall;
    // GetEMIEListLocalData :  
   function GetEMIEListLocalData:WideString;safecall;
    // OpenFavoritesPane :  
   procedure OpenFavoritesPane;safecall;
    // OpenFavoritesSettings :  
   procedure OpenFavoritesSettings;safecall;
    // LaunchInHVSI :  
   procedure LaunchInHVSI(bstrUrl:WideString);safecall;
  end;


// IShellUIHelper8 : Shell UI Helper Control Interface 8

 IShellUIHelper8Disp = dispinterface
   ['{66DEBCF2-05B0-4F07-B49B-B96241A65DB2}']
    // QueryInterface :  
   procedure QueryInterface(var riid:{!! GUID !!} OleVariant;out ppvObj:{!! Ppointer !!} OleVariant);dispid 1610612736;
    // AddRef :  
   function AddRef:LongWord;dispid 1610612737;
    // Release :  
   function Release:LongWord;dispid 1610612738;
    // GetTypeInfoCount :  
   procedure GetTypeInfoCount(out pctinfo:UInt);dispid 1610678272;
    // GetTypeInfo :  
   procedure GetTypeInfo(itinfo:UInt;lcid:LongWord;out pptinfo:{!! Ppointer !!} OleVariant);dispid 1610678273;
    // GetIDsOfNames :  
   procedure GetIDsOfNames(var riid:{!! GUID !!} OleVariant;var rgszNames:{!! PShortInt !!} OleVariant;cNames:UInt;lcid:LongWord;out rgdispid:Integer);dispid 1610678274;
    // Invoke :  
   procedure Invoke(dispidMember:Integer;var riid:{!! GUID !!} OleVariant;lcid:LongWord;wFlags:Word;var pdispparams:{!! DISPPARAMS !!} OleVariant;out pvarResult:OleVariant;out pexcepinfo:{!! EXCEPINFO !!} OleVariant;out puArgErr:UInt);dispid 1610678275;
    // ResetFirstBootMode :  
   procedure ResetFirstBootMode;dispid 1;
    // ResetSafeMode :  
   procedure ResetSafeMode;dispid 2;
    // RefreshOfflineDesktop :  
   procedure RefreshOfflineDesktop;dispid 3;
    // AddFavorite :  
   procedure AddFavorite(URL:WideString;var Title:OleVariant);dispid 4;
    // AddChannel :  
   procedure AddChannel(URL:WideString);dispid 5;
    // AddDesktopComponent :  
   procedure AddDesktopComponent(URL:WideString;Type_:WideString;var Left:OleVariant;var Top:OleVariant;var Width:OleVariant;var Height:OleVariant);dispid 6;
    // IsSubscribed :  
   function IsSubscribed(URL:WideString):WordBool;dispid 7;
    // NavigateAndFind :  
   procedure NavigateAndFind(URL:WideString;strQuery:WideString;var varTargetFrame:OleVariant);dispid 8;
    // ImportExportFavorites :  
   procedure ImportExportFavorites(fImport:WordBool;strImpExpPath:WideString);dispid 9;
    // AutoCompleteSaveForm :  
   procedure AutoCompleteSaveForm(var Form:OleVariant);dispid 10;
    // AutoScan :  
   procedure AutoScan(strSearch:WideString;strFailureUrl:WideString;var pvarTargetFrame:OleVariant);dispid 11;
    // AutoCompleteAttach :  
   procedure AutoCompleteAttach(var Reserved:OleVariant);dispid 12;
    // ShowBrowserUI :  
   function ShowBrowserUI(bstrName:WideString;var pvarIn:OleVariant):OleVariant;dispid 13;
    // AddSearchProvider :  
   procedure AddSearchProvider(URL:WideString);dispid 14;
    // RunOnceShown :  
   procedure RunOnceShown;dispid 15;
    // SkipRunOnce :  
   procedure SkipRunOnce;dispid 16;
    // CustomizeSettings :  
   procedure CustomizeSettings(fSQM:WordBool;fPhishing:WordBool;bstrLocale:WideString);dispid 17;
    // SqmEnabled :  
   function SqmEnabled:WordBool;dispid 18;
    // PhishingEnabled :  
   function PhishingEnabled:WordBool;dispid 19;
    // BrandImageUri :  
   function BrandImageUri:WideString;dispid 20;
    // SkipTabsWelcome :  
   procedure SkipTabsWelcome;dispid 21;
    // DiagnoseConnection :  
   procedure DiagnoseConnection;dispid 22;
    // CustomizeClearType :  
   procedure CustomizeClearType(fSet:WordBool);dispid 23;
    // IsSearchProviderInstalled :  
   function IsSearchProviderInstalled(URL:WideString):LongWord;dispid 24;
    // IsSearchMigrated :  
   function IsSearchMigrated:WordBool;dispid 25;
    // DefaultSearchProvider :  
   function DefaultSearchProvider:WideString;dispid 26;
    // RunOnceRequiredSettingsComplete :  
   procedure RunOnceRequiredSettingsComplete(fComplete:WordBool);dispid 27;
    // RunOnceHasShown :  
   function RunOnceHasShown:WordBool;dispid 28;
    // SearchGuideUrl :  
   function SearchGuideUrl:WideString;dispid 29;
    // AddService :  
   procedure AddService(URL:WideString);dispid 30;
    // IsServiceInstalled :  
   function IsServiceInstalled(URL:WideString;Verb:WideString):LongWord;dispid 31;
    // InPrivateFilteringEnabled :  
   function InPrivateFilteringEnabled:WordBool;dispid 37;
    // AddToFavoritesBar :  
   procedure AddToFavoritesBar(URL:WideString;Title:WideString;var Type_:OleVariant);dispid 32;
    // BuildNewTabPage :  
   procedure BuildNewTabPage;dispid 33;
    // SetRecentlyClosedVisible :  
   procedure SetRecentlyClosedVisible(fVisible:WordBool);dispid 34;
    // SetActivitiesVisible :  
   procedure SetActivitiesVisible(fVisible:WordBool);dispid 35;
    // ContentDiscoveryReset :  
   procedure ContentDiscoveryReset;dispid 36;
    // IsSuggestedSitesEnabled :  
   function IsSuggestedSitesEnabled:WordBool;dispid 38;
    // EnableSuggestedSites :  
   procedure EnableSuggestedSites(fEnable:WordBool);dispid 39;
    // NavigateToSuggestedSites :  
   procedure NavigateToSuggestedSites(bstrRelativeUrl:WideString);dispid 40;
    // ShowTabsHelp :  
   procedure ShowTabsHelp;dispid 41;
    // ShowInPrivateHelp :  
   procedure ShowInPrivateHelp;dispid 42;
    // msIsSiteMode :  
   function msIsSiteMode:WordBool;dispid 43;
    // msSiteModeShowThumbBar :  
   procedure msSiteModeShowThumbBar;dispid 47;
    // msSiteModeAddThumbBarButton :  
   function msSiteModeAddThumbBarButton(bstrIconURL:WideString;bstrTooltip:WideString):OleVariant;dispid 48;
    // msSiteModeUpdateThumbBarButton :  
   procedure msSiteModeUpdateThumbBarButton(ButtonID:OleVariant;fEnabled:WordBool;fVisible:WordBool);dispid 46;
    // msSiteModeSetIconOverlay :  
   procedure msSiteModeSetIconOverlay(IconUrl:WideString;var pvarDescription:OleVariant);dispid 44;
    // msSiteModeClearIconOverlay :  
   procedure msSiteModeClearIconOverlay;dispid 45;
    // msAddSiteMode :  
   procedure msAddSiteMode;dispid 49;
    // msSiteModeCreateJumpList :  
   procedure msSiteModeCreateJumpList(bstrHeader:WideString);dispid 51;
    // msSiteModeAddJumpListItem :  
   procedure msSiteModeAddJumpListItem(bstrName:WideString;bstrActionUri:WideString;bstrIconUri:WideString;var pvarWindowType:OleVariant);dispid 52;
    // msSiteModeClearJumpList :  
   procedure msSiteModeClearJumpList;dispid 53;
    // msSiteModeShowJumpList :  
   procedure msSiteModeShowJumpList;dispid 56;
    // msSiteModeAddButtonStyle :  
   function msSiteModeAddButtonStyle(uiButtonID:OleVariant;bstrIconURL:WideString;bstrTooltip:WideString):OleVariant;dispid 54;
    // msSiteModeShowButtonStyle :  
   procedure msSiteModeShowButtonStyle(uiButtonID:OleVariant;uiStyleID:OleVariant);dispid 55;
    // msSiteModeActivate :  
   procedure msSiteModeActivate;dispid 58;
    // msIsSiteModeFirstRun :  
   function msIsSiteModeFirstRun(fPreserveState:WordBool):OleVariant;dispid 59;
    // msAddTrackingProtectionList :  
   procedure msAddTrackingProtectionList(URL:WideString;bstrFilterName:WideString);dispid 57;
    // msTrackingProtectionEnabled :  
   function msTrackingProtectionEnabled:WordBool;dispid 60;
    // msActiveXFilteringEnabled :  
   function msActiveXFilteringEnabled:WordBool;dispid 61;
    // msProvisionNetworks :  
   function msProvisionNetworks(bstrProvisioningXml:WideString):OleVariant;dispid 62;
    // msReportSafeUrl :  
   procedure msReportSafeUrl;dispid 63;
    // msSiteModeRefreshBadge :  
   procedure msSiteModeRefreshBadge;dispid 64;
    // msSiteModeClearBadge :  
   procedure msSiteModeClearBadge;dispid 65;
    // msDiagnoseConnectionUILess :  
   procedure msDiagnoseConnectionUILess;dispid 66;
    // msLaunchNetworkClientHelp :  
   procedure msLaunchNetworkClientHelp;dispid 67;
    // msChangeDefaultBrowser :  
   procedure msChangeDefaultBrowser(fChange:WordBool);dispid 68;
    // msStopPeriodicTileUpdate :  
   procedure msStopPeriodicTileUpdate;dispid 69;
    // msStartPeriodicTileUpdate :  
   procedure msStartPeriodicTileUpdate(pollingUris:OleVariant;startTime:OleVariant;uiUpdateRecurrence:OleVariant);dispid 70;
    // msStartPeriodicTileUpdateBatch :  
   procedure msStartPeriodicTileUpdateBatch(pollingUris:OleVariant;startTime:OleVariant;uiUpdateRecurrence:OleVariant);dispid 75;
    // msClearTile :  
   procedure msClearTile;dispid 71;
    // msEnableTileNotificationQueue :  
   procedure msEnableTileNotificationQueue(fChange:WordBool);dispid 72;
    // msPinnedSiteState :  
   function msPinnedSiteState:OleVariant;dispid 73;
    // msEnableTileNotificationQueueForSquare150x150 :  
   procedure msEnableTileNotificationQueueForSquare150x150(fChange:WordBool);dispid 76;
    // msEnableTileNotificationQueueForWide310x150 :  
   procedure msEnableTileNotificationQueueForWide310x150(fChange:WordBool);dispid 77;
    // msEnableTileNotificationQueueForSquare310x310 :  
   procedure msEnableTileNotificationQueueForSquare310x310(fChange:WordBool);dispid 78;
    // msScheduledTileNotification :  
   procedure msScheduledTileNotification(bstrNotificationXml:WideString;bstrNotificationId:WideString;bstrNotificationTag:WideString;startTime:OleVariant;expirationTime:OleVariant);dispid 79;
    // msRemoveScheduledTileNotification :  
   procedure msRemoveScheduledTileNotification(bstrNotificationId:WideString);dispid 80;
    // msStartPeriodicBadgeUpdate :  
   procedure msStartPeriodicBadgeUpdate(pollingUri:WideString;startTime:OleVariant;uiUpdateRecurrence:OleVariant);dispid 81;
    // msStopPeriodicBadgeUpdate :  
   procedure msStopPeriodicBadgeUpdate;dispid 82;
    // msLaunchInternetOptions :  
   procedure msLaunchInternetOptions;dispid 74;
    // SetExperimentalFlag :  
   procedure SetExperimentalFlag(bstrFlagString:WideString;vfFlag:WordBool);dispid 85;
    // GetExperimentalFlag :  
   function GetExperimentalFlag(bstrFlagString:WideString):WordBool;dispid 84;
    // SetExperimentalValue :  
   procedure SetExperimentalValue(bstrValueString:WideString;dwValue:LongWord);dispid 86;
    // GetExperimentalValue :  
   function GetExperimentalValue(bstrValueString:WideString):LongWord;dispid 87;
    // ResetAllExperimentalFlagsAndValues :  
   procedure ResetAllExperimentalFlagsAndValues;dispid 92;
    // GetNeedIEAutoLaunchFlag :  
   function GetNeedIEAutoLaunchFlag(bstrUrl:WideString):WordBool;dispid 89;
    // SetNeedIEAutoLaunchFlag :  
   procedure SetNeedIEAutoLaunchFlag(bstrUrl:WideString;flag:WordBool);dispid 90;
    // HasNeedIEAutoLaunchFlag :  
   function HasNeedIEAutoLaunchFlag(bstrUrl:WideString):WordBool;dispid 88;
    // LaunchIE :  
   procedure LaunchIE(bstrUrl:WideString;automated:WordBool);dispid 91;
    // GetCVListData :  
   function GetCVListData:WideString;dispid 93;
    // GetCVListLocalData :  
   function GetCVListLocalData:WideString;dispid 94;
    // GetEMIEListData :  
   function GetEMIEListData:WideString;dispid 95;
    // GetEMIEListLocalData :  
   function GetEMIEListLocalData:WideString;dispid 96;
    // OpenFavoritesPane :  
   procedure OpenFavoritesPane;dispid 97;
    // OpenFavoritesSettings :  
   procedure OpenFavoritesSettings;dispid 98;
    // LaunchInHVSI :  
   procedure LaunchInHVSI(bstrUrl:WideString);dispid 99;
  end;


// DShellNameSpaceEvents : 

 DShellNameSpaceEvents = dispinterface
   ['{55136806-B2DE-11D1-B9F2-00A0C98BC547}']
    // FavoritesSelectionChange :  
   procedure FavoritesSelectionChange(cItems:Integer;hItem:Integer;strName:WideString;strUrl:WideString;cVisits:Integer;strDate:WideString;fAvailableOffline:Integer);dispid 1;
    // SelectionChange :  
   procedure SelectionChange;dispid 2;
    // DoubleClick :  
   procedure DoubleClick;dispid 3;
    // Initialized :  
   procedure Initialized;dispid 4;
  end;


// IShellFavoritesNameSpace : IShellFavoritesNameSpace Interface

 IShellFavoritesNameSpace = interface(IDispatch)
   ['{55136804-B2DE-11D1-B9F2-00A0C98BC547}']
    // MoveSelectionUp : method MoveSelectionUp 
   procedure MoveSelectionUp;safecall;
    // MoveSelectionDown : method MoveSelectionDown 
   procedure MoveSelectionDown;safecall;
    // ResetSort : method ResetSort 
   procedure ResetSort;safecall;
    // NewFolder : method NewFolder 
   procedure NewFolder;safecall;
    // Synchronize : method Synchronize 
   procedure Synchronize;safecall;
    // Import : method Import 
   procedure Import;safecall;
    // Export : method Export 
   procedure Export;safecall;
    // InvokeContextMenuCommand : method InvokeContextMenuCommand 
   procedure InvokeContextMenuCommand(strCommand:WideString);safecall;
    // MoveSelectionTo : method MoveSelectionTo 
   procedure MoveSelectionTo;safecall;
   function Get_SubscriptionsEnabled : WordBool; safecall;
    // CreateSubscriptionForSelection : method CreateSubscriptionForSelection 
   function CreateSubscriptionForSelection:WordBool;safecall;
    // DeleteSubscriptionForSelection : method DeleteSubscriptionForSelection 
   function DeleteSubscriptionForSelection:WordBool;safecall;
    // SetRoot : old, use put_Root() instead 
   procedure SetRoot(bstrFullPath:WideString);safecall;
    // SubscriptionsEnabled : Query to see if subscriptions are enabled 
   property SubscriptionsEnabled:WordBool read Get_SubscriptionsEnabled;
  end;


// IShellFavoritesNameSpace : IShellFavoritesNameSpace Interface

 IShellFavoritesNameSpaceDisp = dispinterface
   ['{55136804-B2DE-11D1-B9F2-00A0C98BC547}']
    // QueryInterface :  
   procedure QueryInterface(var riid:{!! GUID !!} OleVariant;out ppvObj:{!! Ppointer !!} OleVariant);dispid 1610612736;
    // AddRef :  
   function AddRef:LongWord;dispid 1610612737;
    // Release :  
   function Release:LongWord;dispid 1610612738;
    // GetTypeInfoCount :  
   procedure GetTypeInfoCount(out pctinfo:UInt);dispid 1610678272;
    // GetTypeInfo :  
   procedure GetTypeInfo(itinfo:UInt;lcid:LongWord;out pptinfo:{!! Ppointer !!} OleVariant);dispid 1610678273;
    // GetIDsOfNames :  
   procedure GetIDsOfNames(var riid:{!! GUID !!} OleVariant;var rgszNames:{!! PShortInt !!} OleVariant;cNames:UInt;lcid:LongWord;out rgdispid:Integer);dispid 1610678274;
    // Invoke :  
   procedure Invoke(dispidMember:Integer;var riid:{!! GUID !!} OleVariant;lcid:LongWord;wFlags:Word;var pdispparams:{!! DISPPARAMS !!} OleVariant;out pvarResult:OleVariant;out pexcepinfo:{!! EXCEPINFO !!} OleVariant;out puArgErr:UInt);dispid 1610678275;
    // MoveSelectionUp : method MoveSelectionUp 
   procedure MoveSelectionUp;dispid 1;
    // MoveSelectionDown : method MoveSelectionDown 
   procedure MoveSelectionDown;dispid 2;
    // ResetSort : method ResetSort 
   procedure ResetSort;dispid 3;
    // NewFolder : method NewFolder 
   procedure NewFolder;dispid 4;
    // Synchronize : method Synchronize 
   procedure Synchronize;dispid 5;
    // Import : method Import 
   procedure Import;dispid 6;
    // Export : method Export 
   procedure Export;dispid 7;
    // InvokeContextMenuCommand : method InvokeContextMenuCommand 
   procedure InvokeContextMenuCommand(strCommand:WideString);dispid 8;
    // MoveSelectionTo : method MoveSelectionTo 
   procedure MoveSelectionTo;dispid 9;
    // CreateSubscriptionForSelection : method CreateSubscriptionForSelection 
   function CreateSubscriptionForSelection:WordBool;dispid 11;
    // DeleteSubscriptionForSelection : method DeleteSubscriptionForSelection 
   function DeleteSubscriptionForSelection:WordBool;dispid 12;
    // SetRoot : old, use put_Root() instead 
   procedure SetRoot(bstrFullPath:WideString);dispid 13;
    // SubscriptionsEnabled : Query to see if subscriptions are enabled 
   property SubscriptionsEnabled:WordBool  readonly dispid 10;
  end;


// IShellNameSpace : IShellNameSpace Interface

 IShellNameSpace = interface(IShellFavoritesNameSpace)
   ['{E572D3C9-37BE-4AE2-825D-D521763E3108}']
   function Get_EnumOptions : Integer; safecall;
   procedure Set_EnumOptions(const pgrfEnumFlags:Integer); safecall;
   function Get_SelectedItem : IDispatch; safecall;
   procedure Set_SelectedItem(const pItem:IDispatch); safecall;
   function Get_Root : OleVariant; safecall;
   procedure Set_Root(const pvar:OleVariant); safecall;
   function Get_Depth : SYSINT; safecall;
   procedure Set_Depth(const piDepth:SYSINT); safecall;
   function Get_Mode : UInt; safecall;
   procedure Set_Mode(const puMode:UInt); safecall;
   function Get_Flags : LongWord; safecall;
   procedure Set_Flags(const pdwFlags:LongWord); safecall;
   procedure Set_TVFlags(const dwFlags:LongWord); safecall;
   function Get_TVFlags : LongWord; safecall;
   function Get_Columns : WideString; safecall;
   procedure Set_Columns(const bstrColumns:WideString); safecall;
   function Get_CountViewTypes : SYSINT; safecall;
    // SetViewType : set view type 
   procedure SetViewType(iType:SYSINT);safecall;
    // SelectedItems : collection of selected items 
   function SelectedItems:IDispatch;safecall;
    // Expand : expands item specified depth 
   procedure Expand(var_:OleVariant;iDepth:SYSINT);safecall;
    // UnselectAll : unselects all items 
   procedure UnselectAll;safecall;
    // EnumOptions : options  
   property EnumOptions:Integer read Get_EnumOptions write Set_EnumOptions;
    // SelectedItem : get the selected item 
   property SelectedItem:IDispatch read Get_SelectedItem write Set_SelectedItem;
    // Root : get the root item 
   property Root:OleVariant read Get_Root write Set_Root;
    // Depth :  
   property Depth:SYSINT read Get_Depth write Set_Depth;
    // Mode :  
   property Mode:UInt read Get_Mode write Set_Mode;
    // Flags :  
   property Flags:LongWord read Get_Flags write Set_Flags;
    // TVFlags :  
   property TVFlags:LongWord read Get_TVFlags write Set_TVFlags;
    // Columns :  
   property Columns:WideString read Get_Columns write Set_Columns;
    // CountViewTypes : number of view types 
   property CountViewTypes:SYSINT read Get_CountViewTypes;
  end;


// IShellNameSpace : IShellNameSpace Interface

 IShellNameSpaceDisp = dispinterface
   ['{E572D3C9-37BE-4AE2-825D-D521763E3108}']
    // QueryInterface :  
   procedure QueryInterface(var riid:{!! GUID !!} OleVariant;out ppvObj:{!! Ppointer !!} OleVariant);dispid 1610612736;
    // AddRef :  
   function AddRef:LongWord;dispid 1610612737;
    // Release :  
   function Release:LongWord;dispid 1610612738;
    // GetTypeInfoCount :  
   procedure GetTypeInfoCount(out pctinfo:UInt);dispid 1610678272;
    // GetTypeInfo :  
   procedure GetTypeInfo(itinfo:UInt;lcid:LongWord;out pptinfo:{!! Ppointer !!} OleVariant);dispid 1610678273;
    // GetIDsOfNames :  
   procedure GetIDsOfNames(var riid:{!! GUID !!} OleVariant;var rgszNames:{!! PShortInt !!} OleVariant;cNames:UInt;lcid:LongWord;out rgdispid:Integer);dispid 1610678274;
    // Invoke :  
   procedure Invoke(dispidMember:Integer;var riid:{!! GUID !!} OleVariant;lcid:LongWord;wFlags:Word;var pdispparams:{!! DISPPARAMS !!} OleVariant;out pvarResult:OleVariant;out pexcepinfo:{!! EXCEPINFO !!} OleVariant;out puArgErr:UInt);dispid 1610678275;
    // MoveSelectionUp : method MoveSelectionUp 
   procedure MoveSelectionUp;dispid 1;
    // MoveSelectionDown : method MoveSelectionDown 
   procedure MoveSelectionDown;dispid 2;
    // ResetSort : method ResetSort 
   procedure ResetSort;dispid 3;
    // NewFolder : method NewFolder 
   procedure NewFolder;dispid 4;
    // Synchronize : method Synchronize 
   procedure Synchronize;dispid 5;
    // Import : method Import 
   procedure Import;dispid 6;
    // Export : method Export 
   procedure Export;dispid 7;
    // InvokeContextMenuCommand : method InvokeContextMenuCommand 
   procedure InvokeContextMenuCommand(strCommand:WideString);dispid 8;
    // MoveSelectionTo : method MoveSelectionTo 
   procedure MoveSelectionTo;dispid 9;
    // CreateSubscriptionForSelection : method CreateSubscriptionForSelection 
   function CreateSubscriptionForSelection:WordBool;dispid 11;
    // DeleteSubscriptionForSelection : method DeleteSubscriptionForSelection 
   function DeleteSubscriptionForSelection:WordBool;dispid 12;
    // SetRoot : old, use put_Root() instead 
   procedure SetRoot(bstrFullPath:WideString);dispid 13;
    // SetViewType : set view type 
   procedure SetViewType(iType:SYSINT);dispid 23;
    // SelectedItems : collection of selected items 
   function SelectedItems:IDispatch;dispid 24;
    // Expand : expands item specified depth 
   procedure Expand(var_:OleVariant;iDepth:SYSINT);dispid 25;
    // UnselectAll : unselects all items 
   procedure UnselectAll;dispid 26;
    // SubscriptionsEnabled : Query to see if subscriptions are enabled 
   property SubscriptionsEnabled:WordBool  readonly dispid 10;
    // EnumOptions : options  
   property EnumOptions:Integer dispid 14;
    // SelectedItem : get the selected item 
   property SelectedItem:IDispatch dispid 15;
    // Root : get the root item 
   property Root:OleVariant dispid 16;
    // Depth :  
   property Depth:SYSINT dispid 17;
    // Mode :  
   property Mode:UInt dispid 18;
    // Flags :  
   property Flags:LongWord dispid 19;
    // TVFlags :  
   property TVFlags:LongWord dispid 20;
    // Columns :  
   property Columns:WideString dispid 21;
    // CountViewTypes : number of view types 
   property CountViewTypes:SYSINT  readonly dispid 22;
  end;


// IScriptErrorList : Script Error List Interface

 IScriptErrorList = interface(IDispatch)
   ['{F3470F24-15FD-11D2-BB2E-00805FF7EFCA}']
    // advanceError :  
   procedure advanceError;safecall;
    // retreatError :  
   procedure retreatError;safecall;
    // canAdvanceError :  
   function canAdvanceError:Integer;safecall;
    // canRetreatError :  
   function canRetreatError:Integer;safecall;
    // getErrorLine :  
   function getErrorLine:Integer;safecall;
    // getErrorChar :  
   function getErrorChar:Integer;safecall;
    // getErrorCode :  
   function getErrorCode:Integer;safecall;
    // getErrorMsg :  
   function getErrorMsg:WideString;safecall;
    // getErrorUrl :  
   function getErrorUrl:WideString;safecall;
    // getAlwaysShowLockState :  
   function getAlwaysShowLockState:Integer;safecall;
    // getDetailsPaneOpen :  
   function getDetailsPaneOpen:Integer;safecall;
    // setDetailsPaneOpen :  
   procedure setDetailsPaneOpen(fDetailsPaneOpen:Integer);safecall;
    // getPerErrorDisplay :  
   function getPerErrorDisplay:Integer;safecall;
    // setPerErrorDisplay :  
   procedure setPerErrorDisplay(fPerErrorDisplay:Integer);safecall;
  end;


// IScriptErrorList : Script Error List Interface

 IScriptErrorListDisp = dispinterface
   ['{F3470F24-15FD-11D2-BB2E-00805FF7EFCA}']
    // QueryInterface :  
   procedure QueryInterface(var riid:{!! GUID !!} OleVariant;out ppvObj:{!! Ppointer !!} OleVariant);dispid 1610612736;
    // AddRef :  
   function AddRef:LongWord;dispid 1610612737;
    // Release :  
   function Release:LongWord;dispid 1610612738;
    // GetTypeInfoCount :  
   procedure GetTypeInfoCount(out pctinfo:UInt);dispid 1610678272;
    // GetTypeInfo :  
   procedure GetTypeInfo(itinfo:UInt;lcid:LongWord;out pptinfo:{!! Ppointer !!} OleVariant);dispid 1610678273;
    // GetIDsOfNames :  
   procedure GetIDsOfNames(var riid:{!! GUID !!} OleVariant;var rgszNames:{!! PShortInt !!} OleVariant;cNames:UInt;lcid:LongWord;out rgdispid:Integer);dispid 1610678274;
    // Invoke :  
   procedure Invoke(dispidMember:Integer;var riid:{!! GUID !!} OleVariant;lcid:LongWord;wFlags:Word;var pdispparams:{!! DISPPARAMS !!} OleVariant;out pvarResult:OleVariant;out pexcepinfo:{!! EXCEPINFO !!} OleVariant;out puArgErr:UInt);dispid 1610678275;
    // advanceError :  
   procedure advanceError;dispid 10;
    // retreatError :  
   procedure retreatError;dispid 11;
    // canAdvanceError :  
   function canAdvanceError:Integer;dispid 12;
    // canRetreatError :  
   function canRetreatError:Integer;dispid 13;
    // getErrorLine :  
   function getErrorLine:Integer;dispid 14;
    // getErrorChar :  
   function getErrorChar:Integer;dispid 15;
    // getErrorCode :  
   function getErrorCode:Integer;dispid 16;
    // getErrorMsg :  
   function getErrorMsg:WideString;dispid 17;
    // getErrorUrl :  
   function getErrorUrl:WideString;dispid 18;
    // getAlwaysShowLockState :  
   function getAlwaysShowLockState:Integer;dispid 23;
    // getDetailsPaneOpen :  
   function getDetailsPaneOpen:Integer;dispid 19;
    // setDetailsPaneOpen :  
   procedure setDetailsPaneOpen(fDetailsPaneOpen:Integer);dispid 20;
    // getPerErrorDisplay :  
   function getPerErrorDisplay:Integer;dispid 21;
    // setPerErrorDisplay :  
   procedure setPerErrorDisplay(fPerErrorDisplay:Integer);dispid 22;
  end;

//CoClasses
  TDWebBrowserEventsBeforeNavigate = procedure(Sender: TObject;URL:WideString;Flags:Integer;TargetFrameName:WideString;PostData:OleVariant;Headers:WideString;var Cancel:WordBool) of object;
  TDWebBrowserEventsNavigateComplete = procedure(Sender: TObject;URL:WideString) of object;
  TDWebBrowserEventsStatusTextChange = procedure(Sender: TObject;Text_:WideString) of object;
  TDWebBrowserEventsProgressChange = procedure(Sender: TObject;Progress:Integer;ProgressMax:Integer) of object;
  TDWebBrowserEventsDownloadComplete = procedure(Sender: TObject) of object;
  TDWebBrowserEventsCommandStateChange = procedure(Sender: TObject;Command:Integer;Enable:WordBool) of object;
  TDWebBrowserEventsDownloadBegin = procedure(Sender: TObject) of object;
  TDWebBrowserEventsNewWindow = procedure(Sender: TObject;URL:WideString;Flags:Integer;TargetFrameName:WideString;var PostData:OleVariant;Headers:WideString;var Processed:WordBool) of object;
  TDWebBrowserEventsTitleChange = procedure(Sender: TObject;Text_:WideString) of object;
  TDWebBrowserEventsFrameBeforeNavigate = procedure(Sender: TObject;URL:WideString;Flags:Integer;TargetFrameName:WideString;PostData:OleVariant;Headers:WideString;var Cancel:WordBool) of object;
  TDWebBrowserEventsFrameNavigateComplete = procedure(Sender: TObject;URL:WideString) of object;
  TDWebBrowserEventsFrameNewWindow = procedure(Sender: TObject;URL:WideString;Flags:Integer;TargetFrameName:WideString;var PostData:OleVariant;Headers:WideString;var Processed:WordBool) of object;
  TDWebBrowserEventsQuit = procedure(Sender: TObject;var Cancel:WordBool) of object;
  TDWebBrowserEventsWindowMove = procedure(Sender: TObject) of object;
  TDWebBrowserEventsWindowResize = procedure(Sender: TObject) of object;
  TDWebBrowserEventsWindowActivate = procedure(Sender: TObject) of object;
  TDWebBrowserEventsPropertyChange = procedure(Sender: TObject;Property_:WideString) of object;


  CoWebBrowser_V1 = Class
  Public
    Class Function Create: IWebBrowser;
    Class Function CreateRemote(const MachineName: string): IWebBrowser;
  end;

  TEvsWebBrowser_V1 = Class(TEventSink)
  Private
    FOnBeforeNavigate:TDWebBrowserEventsBeforeNavigate;
    FOnNavigateComplete:TDWebBrowserEventsNavigateComplete;
    FOnStatusTextChange:TDWebBrowserEventsStatusTextChange;
    FOnProgressChange:TDWebBrowserEventsProgressChange;
    FOnDownloadComplete:TDWebBrowserEventsDownloadComplete;
    FOnCommandStateChange:TDWebBrowserEventsCommandStateChange;
    FOnDownloadBegin:TDWebBrowserEventsDownloadBegin;
    FOnNewWindow:TDWebBrowserEventsNewWindow;
    FOnTitleChange:TDWebBrowserEventsTitleChange;
    FOnFrameBeforeNavigate:TDWebBrowserEventsFrameBeforeNavigate;
    FOnFrameNavigateComplete:TDWebBrowserEventsFrameNavigateComplete;
    FOnFrameNewWindow:TDWebBrowserEventsFrameNewWindow;
    FOnQuit:TDWebBrowserEventsQuit;
    FOnWindowMove:TDWebBrowserEventsWindowMove;
    FOnWindowResize:TDWebBrowserEventsWindowResize;
    FOnWindowActivate:TDWebBrowserEventsWindowActivate;
    FOnPropertyChange:TDWebBrowserEventsPropertyChange;

    fServer:IWebBrowser;
    procedure EventSinkInvoke(Sender: TObject; DispID: Integer;
          const IID: TGUID; LocaleID: Integer; Flags: Word;
          Params: tagDISPPARAMS; VarResult, ExcepInfo, ArgErr: Pointer);
  Public
    constructor Create(TheOwner: TComponent); override;
    property ComServer:IWebBrowser read fServer;
    property OnBeforeNavigate : TDWebBrowserEventsBeforeNavigate read FOnBeforeNavigate write FOnBeforeNavigate;
    property OnNavigateComplete : TDWebBrowserEventsNavigateComplete read FOnNavigateComplete write FOnNavigateComplete;
    property OnStatusTextChange : TDWebBrowserEventsStatusTextChange read FOnStatusTextChange write FOnStatusTextChange;
    property OnProgressChange : TDWebBrowserEventsProgressChange read FOnProgressChange write FOnProgressChange;
    property OnDownloadComplete : TDWebBrowserEventsDownloadComplete read FOnDownloadComplete write FOnDownloadComplete;
    property OnCommandStateChange : TDWebBrowserEventsCommandStateChange read FOnCommandStateChange write FOnCommandStateChange;
    property OnDownloadBegin : TDWebBrowserEventsDownloadBegin read FOnDownloadBegin write FOnDownloadBegin;
    property OnNewWindow : TDWebBrowserEventsNewWindow read FOnNewWindow write FOnNewWindow;
    property OnTitleChange : TDWebBrowserEventsTitleChange read FOnTitleChange write FOnTitleChange;
    property OnFrameBeforeNavigate : TDWebBrowserEventsFrameBeforeNavigate read FOnFrameBeforeNavigate write FOnFrameBeforeNavigate;
    property OnFrameNavigateComplete : TDWebBrowserEventsFrameNavigateComplete read FOnFrameNavigateComplete write FOnFrameNavigateComplete;
    property OnFrameNewWindow : TDWebBrowserEventsFrameNewWindow read FOnFrameNewWindow write FOnFrameNewWindow;
    property OnQuit : TDWebBrowserEventsQuit read FOnQuit write FOnQuit;
    property OnWindowMove : TDWebBrowserEventsWindowMove read FOnWindowMove write FOnWindowMove;
    property OnWindowResize : TDWebBrowserEventsWindowResize read FOnWindowResize write FOnWindowResize;
    property OnWindowActivate : TDWebBrowserEventsWindowActivate read FOnWindowActivate write FOnWindowActivate;
    property OnPropertyChange : TDWebBrowserEventsPropertyChange read FOnPropertyChange write FOnPropertyChange;

  end;

  TDWebBrowserEvents2StatusTextChange = procedure(Sender: TObject;Text_:WideString) of object;
  TDWebBrowserEvents2ProgressChange = procedure(Sender: TObject;Progress:Integer;ProgressMax:Integer) of object;
  TDWebBrowserEvents2CommandStateChange = procedure(Sender: TObject;Command:Integer;Enable:WordBool) of object;
  TDWebBrowserEvents2DownloadBegin = procedure(Sender: TObject) of object;
  TDWebBrowserEvents2DownloadComplete = procedure(Sender: TObject) of object;
  TDWebBrowserEvents2TitleChange = procedure(Sender: TObject;Text_:WideString) of object;
  TDWebBrowserEvents2PropertyChange = procedure(Sender: TObject;szProperty:WideString) of object;
  TDWebBrowserEvents2BeforeNavigate2 = procedure(Sender: TObject;pDisp:IDispatch;var URL:OleVariant;var Flags:OleVariant;var TargetFrameName:OleVariant;var PostData:OleVariant;var Headers:OleVariant;var Cancel:WordBool) of object;
  TDWebBrowserEvents2NewWindow2 = procedure(Sender: TObject;var ppDisp:IDispatch;var Cancel:WordBool) of object;
  TDWebBrowserEvents2NavigateComplete2 = procedure(Sender: TObject;pDisp:IDispatch;var URL:OleVariant) of object;
  TDWebBrowserEvents2DocumentComplete = procedure(Sender: TObject;pDisp:IDispatch;var URL:OleVariant) of object;
  TDWebBrowserEvents2OnQuit = procedure(Sender: TObject) of object;
  TDWebBrowserEvents2OnVisible = procedure(Sender: TObject;Visible:WordBool) of object;
  TDWebBrowserEvents2OnToolBar = procedure(Sender: TObject;ToolBar:WordBool) of object;
  TDWebBrowserEvents2OnMenuBar = procedure(Sender: TObject;MenuBar:WordBool) of object;
  TDWebBrowserEvents2OnStatusBar = procedure(Sender: TObject;StatusBar:WordBool) of object;
  TDWebBrowserEvents2OnFullScreen = procedure(Sender: TObject;FullScreen:WordBool) of object;
  TDWebBrowserEvents2OnTheaterMode = procedure(Sender: TObject;TheaterMode:WordBool) of object;
  TDWebBrowserEvents2WindowSetResizable = procedure(Sender: TObject;Resizable:WordBool) of object;
  TDWebBrowserEvents2WindowSetLeft = procedure(Sender: TObject;Left:Integer) of object;
  TDWebBrowserEvents2WindowSetTop = procedure(Sender: TObject;Top:Integer) of object;
  TDWebBrowserEvents2WindowSetWidth = procedure(Sender: TObject;Width:Integer) of object;
  TDWebBrowserEvents2WindowSetHeight = procedure(Sender: TObject;Height:Integer) of object;
  TDWebBrowserEvents2WindowClosing = procedure(Sender: TObject;IsChildWindow:WordBool;var Cancel:WordBool) of object;
  TDWebBrowserEvents2ClientToHostWindow = procedure(Sender: TObject;var CX:Integer;var CY:Integer) of object;
  TDWebBrowserEvents2SetSecureLockIcon = procedure(Sender: TObject;SecureLockIcon:Integer) of object;
  TDWebBrowserEvents2FileDownload = procedure(Sender: TObject;ActiveDocument:WordBool;var Cancel:WordBool) of object;
  TDWebBrowserEvents2NavigateError = procedure(Sender: TObject;pDisp:IDispatch;var URL:OleVariant;var Frame:OleVariant;var StatusCode:OleVariant;var Cancel:WordBool) of object;
  TDWebBrowserEvents2PrintTemplateInstantiation = procedure(Sender: TObject;pDisp:IDispatch) of object;
  TDWebBrowserEvents2PrintTemplateTeardown = procedure(Sender: TObject;pDisp:IDispatch) of object;
  TDWebBrowserEvents2UpdatePageStatus = procedure(Sender: TObject;pDisp:IDispatch;var nPage:OleVariant;var fDone:OleVariant) of object;
  TDWebBrowserEvents2PrivacyImpactedStateChange = procedure(Sender: TObject;bImpacted:WordBool) of object;
  TDWebBrowserEvents2NewWindow3 = procedure(Sender: TObject;var ppDisp:IDispatch;var Cancel:WordBool;dwFlags:LongWord;bstrUrlContext:WideString;bstrUrl:WideString) of object;
  TDWebBrowserEvents2SetPhishingFilterStatus = procedure(Sender: TObject;PhishingFilterStatus:Integer) of object;
  TDWebBrowserEvents2WindowStateChanged = procedure(Sender: TObject;dwWindowStateFlags:LongWord;dwValidFlagsMask:LongWord) of object;
  TDWebBrowserEvents2NewProcess = procedure(Sender: TObject;lCauseFlag:Integer;pWB2:IDispatch;var Cancel:WordBool) of object;
  TDWebBrowserEvents2ThirdPartyUrlBlocked = procedure(Sender: TObject;var URL:OleVariant;dwCount:LongWord) of object;
  TDWebBrowserEvents2RedirectXDomainBlocked = procedure(Sender: TObject;pDisp:IDispatch;var StartURL:OleVariant;var RedirectURL:OleVariant;var Frame:OleVariant;var StatusCode:OleVariant) of object;
  TDWebBrowserEvents2BeforeScriptExecute = procedure(Sender: TObject;pDispWindow:IDispatch) of object;
  TDWebBrowserEvents2WebWorkerStarted = procedure(Sender: TObject;dwUniqueID:LongWord;bstrWorkerLabel:WideString) of object;
  TDWebBrowserEvents2WebWorkerFinsihed = procedure(Sender: TObject;dwUniqueID:LongWord) of object;


  CoWebBrowser = Class
  Public
    Class Function Create: IWebBrowser2;
    Class Function CreateRemote(const MachineName: string): IWebBrowser2;
  end;

  TEvsWebBrowser = Class(TEventSink)
  Private
    FOnStatusTextChange:TDWebBrowserEvents2StatusTextChange;
    FOnProgressChange:TDWebBrowserEvents2ProgressChange;
    FOnCommandStateChange:TDWebBrowserEvents2CommandStateChange;
    FOnDownloadBegin:TDWebBrowserEvents2DownloadBegin;
    FOnDownloadComplete:TDWebBrowserEvents2DownloadComplete;
    FOnTitleChange:TDWebBrowserEvents2TitleChange;
    FOnPropertyChange:TDWebBrowserEvents2PropertyChange;
    FOnBeforeNavigate2:TDWebBrowserEvents2BeforeNavigate2;
    FOnNewWindow2:TDWebBrowserEvents2NewWindow2;
    FOnNavigateComplete2:TDWebBrowserEvents2NavigateComplete2;
    FOnDocumentComplete:TDWebBrowserEvents2DocumentComplete;
    FOnOnQuit:TDWebBrowserEvents2OnQuit;
    FOnOnVisible:TDWebBrowserEvents2OnVisible;
    FOnOnToolBar:TDWebBrowserEvents2OnToolBar;
    FOnOnMenuBar:TDWebBrowserEvents2OnMenuBar;
    FOnOnStatusBar:TDWebBrowserEvents2OnStatusBar;
    FOnOnFullScreen:TDWebBrowserEvents2OnFullScreen;
    FOnOnTheaterMode:TDWebBrowserEvents2OnTheaterMode;
    FOnWindowSetResizable:TDWebBrowserEvents2WindowSetResizable;
    FOnWindowSetLeft:TDWebBrowserEvents2WindowSetLeft;
    FOnWindowSetTop:TDWebBrowserEvents2WindowSetTop;
    FOnWindowSetWidth:TDWebBrowserEvents2WindowSetWidth;
    FOnWindowSetHeight:TDWebBrowserEvents2WindowSetHeight;
    FOnWindowClosing:TDWebBrowserEvents2WindowClosing;
    FOnClientToHostWindow:TDWebBrowserEvents2ClientToHostWindow;
    FOnSetSecureLockIcon:TDWebBrowserEvents2SetSecureLockIcon;
    FOnFileDownload:TDWebBrowserEvents2FileDownload;
    FOnNavigateError:TDWebBrowserEvents2NavigateError;
    FOnPrintTemplateInstantiation:TDWebBrowserEvents2PrintTemplateInstantiation;
    FOnPrintTemplateTeardown:TDWebBrowserEvents2PrintTemplateTeardown;
    FOnUpdatePageStatus:TDWebBrowserEvents2UpdatePageStatus;
    FOnPrivacyImpactedStateChange:TDWebBrowserEvents2PrivacyImpactedStateChange;
    FOnNewWindow3:TDWebBrowserEvents2NewWindow3;
    FOnSetPhishingFilterStatus:TDWebBrowserEvents2SetPhishingFilterStatus;
    FOnWindowStateChanged:TDWebBrowserEvents2WindowStateChanged;
    FOnNewProcess:TDWebBrowserEvents2NewProcess;
    FOnThirdPartyUrlBlocked:TDWebBrowserEvents2ThirdPartyUrlBlocked;
    FOnRedirectXDomainBlocked:TDWebBrowserEvents2RedirectXDomainBlocked;
    FOnBeforeScriptExecute:TDWebBrowserEvents2BeforeScriptExecute;
    FOnWebWorkerStarted:TDWebBrowserEvents2WebWorkerStarted;
    FOnWebWorkerFinsihed:TDWebBrowserEvents2WebWorkerFinsihed;

    fServer:IWebBrowser2;
    procedure EventSinkInvoke(Sender: TObject; DispID: Integer;
          const IID: TGUID; LocaleID: Integer; Flags: Word;
          Params: tagDISPPARAMS; VarResult, ExcepInfo, ArgErr: Pointer);
  Public
    constructor Create(TheOwner: TComponent); override;
    property ComServer:IWebBrowser2 read fServer;
    property OnStatusTextChange : TDWebBrowserEvents2StatusTextChange read FOnStatusTextChange write FOnStatusTextChange;
    property OnProgressChange : TDWebBrowserEvents2ProgressChange read FOnProgressChange write FOnProgressChange;
    property OnCommandStateChange : TDWebBrowserEvents2CommandStateChange read FOnCommandStateChange write FOnCommandStateChange;
    property OnDownloadBegin : TDWebBrowserEvents2DownloadBegin read FOnDownloadBegin write FOnDownloadBegin;
    property OnDownloadComplete : TDWebBrowserEvents2DownloadComplete read FOnDownloadComplete write FOnDownloadComplete;
    property OnTitleChange : TDWebBrowserEvents2TitleChange read FOnTitleChange write FOnTitleChange;
    property OnPropertyChange : TDWebBrowserEvents2PropertyChange read FOnPropertyChange write FOnPropertyChange;
    property OnBeforeNavigate2 : TDWebBrowserEvents2BeforeNavigate2 read FOnBeforeNavigate2 write FOnBeforeNavigate2;
    property OnNewWindow2 : TDWebBrowserEvents2NewWindow2 read FOnNewWindow2 write FOnNewWindow2;
    property OnNavigateComplete2 : TDWebBrowserEvents2NavigateComplete2 read FOnNavigateComplete2 write FOnNavigateComplete2;
    property OnDocumentComplete : TDWebBrowserEvents2DocumentComplete read FOnDocumentComplete write FOnDocumentComplete;
    property OnOnQuit : TDWebBrowserEvents2OnQuit read FOnOnQuit write FOnOnQuit;
    property OnOnVisible : TDWebBrowserEvents2OnVisible read FOnOnVisible write FOnOnVisible;
    property OnOnToolBar : TDWebBrowserEvents2OnToolBar read FOnOnToolBar write FOnOnToolBar;
    property OnOnMenuBar : TDWebBrowserEvents2OnMenuBar read FOnOnMenuBar write FOnOnMenuBar;
    property OnOnStatusBar : TDWebBrowserEvents2OnStatusBar read FOnOnStatusBar write FOnOnStatusBar;
    property OnOnFullScreen : TDWebBrowserEvents2OnFullScreen read FOnOnFullScreen write FOnOnFullScreen;
    property OnOnTheaterMode : TDWebBrowserEvents2OnTheaterMode read FOnOnTheaterMode write FOnOnTheaterMode;
    property OnWindowSetResizable : TDWebBrowserEvents2WindowSetResizable read FOnWindowSetResizable write FOnWindowSetResizable;
    property OnWindowSetLeft : TDWebBrowserEvents2WindowSetLeft read FOnWindowSetLeft write FOnWindowSetLeft;
    property OnWindowSetTop : TDWebBrowserEvents2WindowSetTop read FOnWindowSetTop write FOnWindowSetTop;
    property OnWindowSetWidth : TDWebBrowserEvents2WindowSetWidth read FOnWindowSetWidth write FOnWindowSetWidth;
    property OnWindowSetHeight : TDWebBrowserEvents2WindowSetHeight read FOnWindowSetHeight write FOnWindowSetHeight;
    property OnWindowClosing : TDWebBrowserEvents2WindowClosing read FOnWindowClosing write FOnWindowClosing;
    property OnClientToHostWindow : TDWebBrowserEvents2ClientToHostWindow read FOnClientToHostWindow write FOnClientToHostWindow;
    property OnSetSecureLockIcon : TDWebBrowserEvents2SetSecureLockIcon read FOnSetSecureLockIcon write FOnSetSecureLockIcon;
    property OnFileDownload : TDWebBrowserEvents2FileDownload read FOnFileDownload write FOnFileDownload;
    property OnNavigateError : TDWebBrowserEvents2NavigateError read FOnNavigateError write FOnNavigateError;
    property OnPrintTemplateInstantiation : TDWebBrowserEvents2PrintTemplateInstantiation read FOnPrintTemplateInstantiation write FOnPrintTemplateInstantiation;
    property OnPrintTemplateTeardown : TDWebBrowserEvents2PrintTemplateTeardown read FOnPrintTemplateTeardown write FOnPrintTemplateTeardown;
    property OnUpdatePageStatus : TDWebBrowserEvents2UpdatePageStatus read FOnUpdatePageStatus write FOnUpdatePageStatus;
    property OnPrivacyImpactedStateChange : TDWebBrowserEvents2PrivacyImpactedStateChange read FOnPrivacyImpactedStateChange write FOnPrivacyImpactedStateChange;
    property OnNewWindow3 : TDWebBrowserEvents2NewWindow3 read FOnNewWindow3 write FOnNewWindow3;
    property OnSetPhishingFilterStatus : TDWebBrowserEvents2SetPhishingFilterStatus read FOnSetPhishingFilterStatus write FOnSetPhishingFilterStatus;
    property OnWindowStateChanged : TDWebBrowserEvents2WindowStateChanged read FOnWindowStateChanged write FOnWindowStateChanged;
    property OnNewProcess : TDWebBrowserEvents2NewProcess read FOnNewProcess write FOnNewProcess;
    property OnThirdPartyUrlBlocked : TDWebBrowserEvents2ThirdPartyUrlBlocked read FOnThirdPartyUrlBlocked write FOnThirdPartyUrlBlocked;
    property OnRedirectXDomainBlocked : TDWebBrowserEvents2RedirectXDomainBlocked read FOnRedirectXDomainBlocked write FOnRedirectXDomainBlocked;
    property OnBeforeScriptExecute : TDWebBrowserEvents2BeforeScriptExecute read FOnBeforeScriptExecute write FOnBeforeScriptExecute;
    property OnWebWorkerStarted : TDWebBrowserEvents2WebWorkerStarted read FOnWebWorkerStarted write FOnWebWorkerStarted;
    property OnWebWorkerFinsihed : TDWebBrowserEvents2WebWorkerFinsihed read FOnWebWorkerFinsihed write FOnWebWorkerFinsihed;

  end;

  CoInternetExplorer = Class
  Public
    Class Function Create: IWebBrowser2;
    Class Function CreateRemote(const MachineName: string): IWebBrowser2;
  end;

  TEvsInternetExplorer = Class(TEventSink)
  Private
    FOnStatusTextChange:TDWebBrowserEvents2StatusTextChange;
    FOnProgressChange:TDWebBrowserEvents2ProgressChange;
    FOnCommandStateChange:TDWebBrowserEvents2CommandStateChange;
    FOnDownloadBegin:TDWebBrowserEvents2DownloadBegin;
    FOnDownloadComplete:TDWebBrowserEvents2DownloadComplete;
    FOnTitleChange:TDWebBrowserEvents2TitleChange;
    FOnPropertyChange:TDWebBrowserEvents2PropertyChange;
    FOnBeforeNavigate2:TDWebBrowserEvents2BeforeNavigate2;
    FOnNewWindow2:TDWebBrowserEvents2NewWindow2;
    FOnNavigateComplete2:TDWebBrowserEvents2NavigateComplete2;
    FOnDocumentComplete:TDWebBrowserEvents2DocumentComplete;
    FOnOnQuit:TDWebBrowserEvents2OnQuit;
    FOnOnVisible:TDWebBrowserEvents2OnVisible;
    FOnOnToolBar:TDWebBrowserEvents2OnToolBar;
    FOnOnMenuBar:TDWebBrowserEvents2OnMenuBar;
    FOnOnStatusBar:TDWebBrowserEvents2OnStatusBar;
    FOnOnFullScreen:TDWebBrowserEvents2OnFullScreen;
    FOnOnTheaterMode:TDWebBrowserEvents2OnTheaterMode;
    FOnWindowSetResizable:TDWebBrowserEvents2WindowSetResizable;
    FOnWindowSetLeft:TDWebBrowserEvents2WindowSetLeft;
    FOnWindowSetTop:TDWebBrowserEvents2WindowSetTop;
    FOnWindowSetWidth:TDWebBrowserEvents2WindowSetWidth;
    FOnWindowSetHeight:TDWebBrowserEvents2WindowSetHeight;
    FOnWindowClosing:TDWebBrowserEvents2WindowClosing;
    FOnClientToHostWindow:TDWebBrowserEvents2ClientToHostWindow;
    FOnSetSecureLockIcon:TDWebBrowserEvents2SetSecureLockIcon;
    FOnFileDownload:TDWebBrowserEvents2FileDownload;
    FOnNavigateError:TDWebBrowserEvents2NavigateError;
    FOnPrintTemplateInstantiation:TDWebBrowserEvents2PrintTemplateInstantiation;
    FOnPrintTemplateTeardown:TDWebBrowserEvents2PrintTemplateTeardown;
    FOnUpdatePageStatus:TDWebBrowserEvents2UpdatePageStatus;
    FOnPrivacyImpactedStateChange:TDWebBrowserEvents2PrivacyImpactedStateChange;
    FOnNewWindow3:TDWebBrowserEvents2NewWindow3;
    FOnSetPhishingFilterStatus:TDWebBrowserEvents2SetPhishingFilterStatus;
    FOnWindowStateChanged:TDWebBrowserEvents2WindowStateChanged;
    FOnNewProcess:TDWebBrowserEvents2NewProcess;
    FOnThirdPartyUrlBlocked:TDWebBrowserEvents2ThirdPartyUrlBlocked;
    FOnRedirectXDomainBlocked:TDWebBrowserEvents2RedirectXDomainBlocked;
    FOnBeforeScriptExecute:TDWebBrowserEvents2BeforeScriptExecute;
    FOnWebWorkerStarted:TDWebBrowserEvents2WebWorkerStarted;
    FOnWebWorkerFinsihed:TDWebBrowserEvents2WebWorkerFinsihed;

    fServer:IWebBrowser2;
    procedure EventSinkInvoke(Sender: TObject; DispID: Integer;
          const IID: TGUID; LocaleID: Integer; Flags: Word;
          Params: tagDISPPARAMS; VarResult, ExcepInfo, ArgErr: Pointer);
  Public
    constructor Create(TheOwner: TComponent); override;
    property ComServer:IWebBrowser2 read fServer;
    property OnStatusTextChange : TDWebBrowserEvents2StatusTextChange read FOnStatusTextChange write FOnStatusTextChange;
    property OnProgressChange : TDWebBrowserEvents2ProgressChange read FOnProgressChange write FOnProgressChange;
    property OnCommandStateChange : TDWebBrowserEvents2CommandStateChange read FOnCommandStateChange write FOnCommandStateChange;
    property OnDownloadBegin : TDWebBrowserEvents2DownloadBegin read FOnDownloadBegin write FOnDownloadBegin;
    property OnDownloadComplete : TDWebBrowserEvents2DownloadComplete read FOnDownloadComplete write FOnDownloadComplete;
    property OnTitleChange : TDWebBrowserEvents2TitleChange read FOnTitleChange write FOnTitleChange;
    property OnPropertyChange : TDWebBrowserEvents2PropertyChange read FOnPropertyChange write FOnPropertyChange;
    property OnBeforeNavigate2 : TDWebBrowserEvents2BeforeNavigate2 read FOnBeforeNavigate2 write FOnBeforeNavigate2;
    property OnNewWindow2 : TDWebBrowserEvents2NewWindow2 read FOnNewWindow2 write FOnNewWindow2;
    property OnNavigateComplete2 : TDWebBrowserEvents2NavigateComplete2 read FOnNavigateComplete2 write FOnNavigateComplete2;
    property OnDocumentComplete : TDWebBrowserEvents2DocumentComplete read FOnDocumentComplete write FOnDocumentComplete;
    property OnOnQuit : TDWebBrowserEvents2OnQuit read FOnOnQuit write FOnOnQuit;
    property OnOnVisible : TDWebBrowserEvents2OnVisible read FOnOnVisible write FOnOnVisible;
    property OnOnToolBar : TDWebBrowserEvents2OnToolBar read FOnOnToolBar write FOnOnToolBar;
    property OnOnMenuBar : TDWebBrowserEvents2OnMenuBar read FOnOnMenuBar write FOnOnMenuBar;
    property OnOnStatusBar : TDWebBrowserEvents2OnStatusBar read FOnOnStatusBar write FOnOnStatusBar;
    property OnOnFullScreen : TDWebBrowserEvents2OnFullScreen read FOnOnFullScreen write FOnOnFullScreen;
    property OnOnTheaterMode : TDWebBrowserEvents2OnTheaterMode read FOnOnTheaterMode write FOnOnTheaterMode;
    property OnWindowSetResizable : TDWebBrowserEvents2WindowSetResizable read FOnWindowSetResizable write FOnWindowSetResizable;
    property OnWindowSetLeft : TDWebBrowserEvents2WindowSetLeft read FOnWindowSetLeft write FOnWindowSetLeft;
    property OnWindowSetTop : TDWebBrowserEvents2WindowSetTop read FOnWindowSetTop write FOnWindowSetTop;
    property OnWindowSetWidth : TDWebBrowserEvents2WindowSetWidth read FOnWindowSetWidth write FOnWindowSetWidth;
    property OnWindowSetHeight : TDWebBrowserEvents2WindowSetHeight read FOnWindowSetHeight write FOnWindowSetHeight;
    property OnWindowClosing : TDWebBrowserEvents2WindowClosing read FOnWindowClosing write FOnWindowClosing;
    property OnClientToHostWindow : TDWebBrowserEvents2ClientToHostWindow read FOnClientToHostWindow write FOnClientToHostWindow;
    property OnSetSecureLockIcon : TDWebBrowserEvents2SetSecureLockIcon read FOnSetSecureLockIcon write FOnSetSecureLockIcon;
    property OnFileDownload : TDWebBrowserEvents2FileDownload read FOnFileDownload write FOnFileDownload;
    property OnNavigateError : TDWebBrowserEvents2NavigateError read FOnNavigateError write FOnNavigateError;
    property OnPrintTemplateInstantiation : TDWebBrowserEvents2PrintTemplateInstantiation read FOnPrintTemplateInstantiation write FOnPrintTemplateInstantiation;
    property OnPrintTemplateTeardown : TDWebBrowserEvents2PrintTemplateTeardown read FOnPrintTemplateTeardown write FOnPrintTemplateTeardown;
    property OnUpdatePageStatus : TDWebBrowserEvents2UpdatePageStatus read FOnUpdatePageStatus write FOnUpdatePageStatus;
    property OnPrivacyImpactedStateChange : TDWebBrowserEvents2PrivacyImpactedStateChange read FOnPrivacyImpactedStateChange write FOnPrivacyImpactedStateChange;
    property OnNewWindow3 : TDWebBrowserEvents2NewWindow3 read FOnNewWindow3 write FOnNewWindow3;
    property OnSetPhishingFilterStatus : TDWebBrowserEvents2SetPhishingFilterStatus read FOnSetPhishingFilterStatus write FOnSetPhishingFilterStatus;
    property OnWindowStateChanged : TDWebBrowserEvents2WindowStateChanged read FOnWindowStateChanged write FOnWindowStateChanged;
    property OnNewProcess : TDWebBrowserEvents2NewProcess read FOnNewProcess write FOnNewProcess;
    property OnThirdPartyUrlBlocked : TDWebBrowserEvents2ThirdPartyUrlBlocked read FOnThirdPartyUrlBlocked write FOnThirdPartyUrlBlocked;
    property OnRedirectXDomainBlocked : TDWebBrowserEvents2RedirectXDomainBlocked read FOnRedirectXDomainBlocked write FOnRedirectXDomainBlocked;
    property OnBeforeScriptExecute : TDWebBrowserEvents2BeforeScriptExecute read FOnBeforeScriptExecute write FOnBeforeScriptExecute;
    property OnWebWorkerStarted : TDWebBrowserEvents2WebWorkerStarted read FOnWebWorkerStarted write FOnWebWorkerStarted;
    property OnWebWorkerFinsihed : TDWebBrowserEvents2WebWorkerFinsihed read FOnWebWorkerFinsihed write FOnWebWorkerFinsihed;

  end;

  CoInternetExplorerMedium = Class
  Public
    Class Function Create: IWebBrowser2;
    Class Function CreateRemote(const MachineName: string): IWebBrowser2;
  end;

  TEvsInternetExplorerMedium = Class(TEventSink)
  Private
    FOnStatusTextChange:TDWebBrowserEvents2StatusTextChange;
    FOnProgressChange:TDWebBrowserEvents2ProgressChange;
    FOnCommandStateChange:TDWebBrowserEvents2CommandStateChange;
    FOnDownloadBegin:TDWebBrowserEvents2DownloadBegin;
    FOnDownloadComplete:TDWebBrowserEvents2DownloadComplete;
    FOnTitleChange:TDWebBrowserEvents2TitleChange;
    FOnPropertyChange:TDWebBrowserEvents2PropertyChange;
    FOnBeforeNavigate2:TDWebBrowserEvents2BeforeNavigate2;
    FOnNewWindow2:TDWebBrowserEvents2NewWindow2;
    FOnNavigateComplete2:TDWebBrowserEvents2NavigateComplete2;
    FOnDocumentComplete:TDWebBrowserEvents2DocumentComplete;
    FOnOnQuit:TDWebBrowserEvents2OnQuit;
    FOnOnVisible:TDWebBrowserEvents2OnVisible;
    FOnOnToolBar:TDWebBrowserEvents2OnToolBar;
    FOnOnMenuBar:TDWebBrowserEvents2OnMenuBar;
    FOnOnStatusBar:TDWebBrowserEvents2OnStatusBar;
    FOnOnFullScreen:TDWebBrowserEvents2OnFullScreen;
    FOnOnTheaterMode:TDWebBrowserEvents2OnTheaterMode;
    FOnWindowSetResizable:TDWebBrowserEvents2WindowSetResizable;
    FOnWindowSetLeft:TDWebBrowserEvents2WindowSetLeft;
    FOnWindowSetTop:TDWebBrowserEvents2WindowSetTop;
    FOnWindowSetWidth:TDWebBrowserEvents2WindowSetWidth;
    FOnWindowSetHeight:TDWebBrowserEvents2WindowSetHeight;
    FOnWindowClosing:TDWebBrowserEvents2WindowClosing;
    FOnClientToHostWindow:TDWebBrowserEvents2ClientToHostWindow;
    FOnSetSecureLockIcon:TDWebBrowserEvents2SetSecureLockIcon;
    FOnFileDownload:TDWebBrowserEvents2FileDownload;
    FOnNavigateError:TDWebBrowserEvents2NavigateError;
    FOnPrintTemplateInstantiation:TDWebBrowserEvents2PrintTemplateInstantiation;
    FOnPrintTemplateTeardown:TDWebBrowserEvents2PrintTemplateTeardown;
    FOnUpdatePageStatus:TDWebBrowserEvents2UpdatePageStatus;
    FOnPrivacyImpactedStateChange:TDWebBrowserEvents2PrivacyImpactedStateChange;
    FOnNewWindow3:TDWebBrowserEvents2NewWindow3;
    FOnSetPhishingFilterStatus:TDWebBrowserEvents2SetPhishingFilterStatus;
    FOnWindowStateChanged:TDWebBrowserEvents2WindowStateChanged;
    FOnNewProcess:TDWebBrowserEvents2NewProcess;
    FOnThirdPartyUrlBlocked:TDWebBrowserEvents2ThirdPartyUrlBlocked;
    FOnRedirectXDomainBlocked:TDWebBrowserEvents2RedirectXDomainBlocked;
    FOnBeforeScriptExecute:TDWebBrowserEvents2BeforeScriptExecute;
    FOnWebWorkerStarted:TDWebBrowserEvents2WebWorkerStarted;
    FOnWebWorkerFinsihed:TDWebBrowserEvents2WebWorkerFinsihed;

    fServer:IWebBrowser2;
    procedure EventSinkInvoke(Sender: TObject; DispID: Integer;
          const IID: TGUID; LocaleID: Integer; Flags: Word;
          Params: tagDISPPARAMS; VarResult, ExcepInfo, ArgErr: Pointer);
  Public
    constructor Create(TheOwner: TComponent); override;
    property ComServer:IWebBrowser2 read fServer;
    property OnStatusTextChange : TDWebBrowserEvents2StatusTextChange read FOnStatusTextChange write FOnStatusTextChange;
    property OnProgressChange : TDWebBrowserEvents2ProgressChange read FOnProgressChange write FOnProgressChange;
    property OnCommandStateChange : TDWebBrowserEvents2CommandStateChange read FOnCommandStateChange write FOnCommandStateChange;
    property OnDownloadBegin : TDWebBrowserEvents2DownloadBegin read FOnDownloadBegin write FOnDownloadBegin;
    property OnDownloadComplete : TDWebBrowserEvents2DownloadComplete read FOnDownloadComplete write FOnDownloadComplete;
    property OnTitleChange : TDWebBrowserEvents2TitleChange read FOnTitleChange write FOnTitleChange;
    property OnPropertyChange : TDWebBrowserEvents2PropertyChange read FOnPropertyChange write FOnPropertyChange;
    property OnBeforeNavigate2 : TDWebBrowserEvents2BeforeNavigate2 read FOnBeforeNavigate2 write FOnBeforeNavigate2;
    property OnNewWindow2 : TDWebBrowserEvents2NewWindow2 read FOnNewWindow2 write FOnNewWindow2;
    property OnNavigateComplete2 : TDWebBrowserEvents2NavigateComplete2 read FOnNavigateComplete2 write FOnNavigateComplete2;
    property OnDocumentComplete : TDWebBrowserEvents2DocumentComplete read FOnDocumentComplete write FOnDocumentComplete;
    property OnOnQuit : TDWebBrowserEvents2OnQuit read FOnOnQuit write FOnOnQuit;
    property OnOnVisible : TDWebBrowserEvents2OnVisible read FOnOnVisible write FOnOnVisible;
    property OnOnToolBar : TDWebBrowserEvents2OnToolBar read FOnOnToolBar write FOnOnToolBar;
    property OnOnMenuBar : TDWebBrowserEvents2OnMenuBar read FOnOnMenuBar write FOnOnMenuBar;
    property OnOnStatusBar : TDWebBrowserEvents2OnStatusBar read FOnOnStatusBar write FOnOnStatusBar;
    property OnOnFullScreen : TDWebBrowserEvents2OnFullScreen read FOnOnFullScreen write FOnOnFullScreen;
    property OnOnTheaterMode : TDWebBrowserEvents2OnTheaterMode read FOnOnTheaterMode write FOnOnTheaterMode;
    property OnWindowSetResizable : TDWebBrowserEvents2WindowSetResizable read FOnWindowSetResizable write FOnWindowSetResizable;
    property OnWindowSetLeft : TDWebBrowserEvents2WindowSetLeft read FOnWindowSetLeft write FOnWindowSetLeft;
    property OnWindowSetTop : TDWebBrowserEvents2WindowSetTop read FOnWindowSetTop write FOnWindowSetTop;
    property OnWindowSetWidth : TDWebBrowserEvents2WindowSetWidth read FOnWindowSetWidth write FOnWindowSetWidth;
    property OnWindowSetHeight : TDWebBrowserEvents2WindowSetHeight read FOnWindowSetHeight write FOnWindowSetHeight;
    property OnWindowClosing : TDWebBrowserEvents2WindowClosing read FOnWindowClosing write FOnWindowClosing;
    property OnClientToHostWindow : TDWebBrowserEvents2ClientToHostWindow read FOnClientToHostWindow write FOnClientToHostWindow;
    property OnSetSecureLockIcon : TDWebBrowserEvents2SetSecureLockIcon read FOnSetSecureLockIcon write FOnSetSecureLockIcon;
    property OnFileDownload : TDWebBrowserEvents2FileDownload read FOnFileDownload write FOnFileDownload;
    property OnNavigateError : TDWebBrowserEvents2NavigateError read FOnNavigateError write FOnNavigateError;
    property OnPrintTemplateInstantiation : TDWebBrowserEvents2PrintTemplateInstantiation read FOnPrintTemplateInstantiation write FOnPrintTemplateInstantiation;
    property OnPrintTemplateTeardown : TDWebBrowserEvents2PrintTemplateTeardown read FOnPrintTemplateTeardown write FOnPrintTemplateTeardown;
    property OnUpdatePageStatus : TDWebBrowserEvents2UpdatePageStatus read FOnUpdatePageStatus write FOnUpdatePageStatus;
    property OnPrivacyImpactedStateChange : TDWebBrowserEvents2PrivacyImpactedStateChange read FOnPrivacyImpactedStateChange write FOnPrivacyImpactedStateChange;
    property OnNewWindow3 : TDWebBrowserEvents2NewWindow3 read FOnNewWindow3 write FOnNewWindow3;
    property OnSetPhishingFilterStatus : TDWebBrowserEvents2SetPhishingFilterStatus read FOnSetPhishingFilterStatus write FOnSetPhishingFilterStatus;
    property OnWindowStateChanged : TDWebBrowserEvents2WindowStateChanged read FOnWindowStateChanged write FOnWindowStateChanged;
    property OnNewProcess : TDWebBrowserEvents2NewProcess read FOnNewProcess write FOnNewProcess;
    property OnThirdPartyUrlBlocked : TDWebBrowserEvents2ThirdPartyUrlBlocked read FOnThirdPartyUrlBlocked write FOnThirdPartyUrlBlocked;
    property OnRedirectXDomainBlocked : TDWebBrowserEvents2RedirectXDomainBlocked read FOnRedirectXDomainBlocked write FOnRedirectXDomainBlocked;
    property OnBeforeScriptExecute : TDWebBrowserEvents2BeforeScriptExecute read FOnBeforeScriptExecute write FOnBeforeScriptExecute;
    property OnWebWorkerStarted : TDWebBrowserEvents2WebWorkerStarted read FOnWebWorkerStarted write FOnWebWorkerStarted;
    property OnWebWorkerFinsihed : TDWebBrowserEvents2WebWorkerFinsihed read FOnWebWorkerFinsihed write FOnWebWorkerFinsihed;

  end;

  CoShellBrowserWindow = Class
  Public
    Class Function Create: IWebBrowser2;
    Class Function CreateRemote(const MachineName: string): IWebBrowser2;
  end;

  TEvsShellBrowserWindow = Class(TEventSink)
  Private
    FOnStatusTextChange:TDWebBrowserEvents2StatusTextChange;
    FOnProgressChange:TDWebBrowserEvents2ProgressChange;
    FOnCommandStateChange:TDWebBrowserEvents2CommandStateChange;
    FOnDownloadBegin:TDWebBrowserEvents2DownloadBegin;
    FOnDownloadComplete:TDWebBrowserEvents2DownloadComplete;
    FOnTitleChange:TDWebBrowserEvents2TitleChange;
    FOnPropertyChange:TDWebBrowserEvents2PropertyChange;
    FOnBeforeNavigate2:TDWebBrowserEvents2BeforeNavigate2;
    FOnNewWindow2:TDWebBrowserEvents2NewWindow2;
    FOnNavigateComplete2:TDWebBrowserEvents2NavigateComplete2;
    FOnDocumentComplete:TDWebBrowserEvents2DocumentComplete;
    FOnOnQuit:TDWebBrowserEvents2OnQuit;
    FOnOnVisible:TDWebBrowserEvents2OnVisible;
    FOnOnToolBar:TDWebBrowserEvents2OnToolBar;
    FOnOnMenuBar:TDWebBrowserEvents2OnMenuBar;
    FOnOnStatusBar:TDWebBrowserEvents2OnStatusBar;
    FOnOnFullScreen:TDWebBrowserEvents2OnFullScreen;
    FOnOnTheaterMode:TDWebBrowserEvents2OnTheaterMode;
    FOnWindowSetResizable:TDWebBrowserEvents2WindowSetResizable;
    FOnWindowSetLeft:TDWebBrowserEvents2WindowSetLeft;
    FOnWindowSetTop:TDWebBrowserEvents2WindowSetTop;
    FOnWindowSetWidth:TDWebBrowserEvents2WindowSetWidth;
    FOnWindowSetHeight:TDWebBrowserEvents2WindowSetHeight;
    FOnWindowClosing:TDWebBrowserEvents2WindowClosing;
    FOnClientToHostWindow:TDWebBrowserEvents2ClientToHostWindow;
    FOnSetSecureLockIcon:TDWebBrowserEvents2SetSecureLockIcon;
    FOnFileDownload:TDWebBrowserEvents2FileDownload;
    FOnNavigateError:TDWebBrowserEvents2NavigateError;
    FOnPrintTemplateInstantiation:TDWebBrowserEvents2PrintTemplateInstantiation;
    FOnPrintTemplateTeardown:TDWebBrowserEvents2PrintTemplateTeardown;
    FOnUpdatePageStatus:TDWebBrowserEvents2UpdatePageStatus;
    FOnPrivacyImpactedStateChange:TDWebBrowserEvents2PrivacyImpactedStateChange;
    FOnNewWindow3:TDWebBrowserEvents2NewWindow3;
    FOnSetPhishingFilterStatus:TDWebBrowserEvents2SetPhishingFilterStatus;
    FOnWindowStateChanged:TDWebBrowserEvents2WindowStateChanged;
    FOnNewProcess:TDWebBrowserEvents2NewProcess;
    FOnThirdPartyUrlBlocked:TDWebBrowserEvents2ThirdPartyUrlBlocked;
    FOnRedirectXDomainBlocked:TDWebBrowserEvents2RedirectXDomainBlocked;
    FOnBeforeScriptExecute:TDWebBrowserEvents2BeforeScriptExecute;
    FOnWebWorkerStarted:TDWebBrowserEvents2WebWorkerStarted;
    FOnWebWorkerFinsihed:TDWebBrowserEvents2WebWorkerFinsihed;

    fServer:IWebBrowser2;
    procedure EventSinkInvoke(Sender: TObject; DispID: Integer;
          const IID: TGUID; LocaleID: Integer; Flags: Word;
          Params: tagDISPPARAMS; VarResult, ExcepInfo, ArgErr: Pointer);
  Public
    constructor Create(TheOwner: TComponent); override;
    property ComServer:IWebBrowser2 read fServer;
    property OnStatusTextChange : TDWebBrowserEvents2StatusTextChange read FOnStatusTextChange write FOnStatusTextChange;
    property OnProgressChange : TDWebBrowserEvents2ProgressChange read FOnProgressChange write FOnProgressChange;
    property OnCommandStateChange : TDWebBrowserEvents2CommandStateChange read FOnCommandStateChange write FOnCommandStateChange;
    property OnDownloadBegin : TDWebBrowserEvents2DownloadBegin read FOnDownloadBegin write FOnDownloadBegin;
    property OnDownloadComplete : TDWebBrowserEvents2DownloadComplete read FOnDownloadComplete write FOnDownloadComplete;
    property OnTitleChange : TDWebBrowserEvents2TitleChange read FOnTitleChange write FOnTitleChange;
    property OnPropertyChange : TDWebBrowserEvents2PropertyChange read FOnPropertyChange write FOnPropertyChange;
    property OnBeforeNavigate2 : TDWebBrowserEvents2BeforeNavigate2 read FOnBeforeNavigate2 write FOnBeforeNavigate2;
    property OnNewWindow2 : TDWebBrowserEvents2NewWindow2 read FOnNewWindow2 write FOnNewWindow2;
    property OnNavigateComplete2 : TDWebBrowserEvents2NavigateComplete2 read FOnNavigateComplete2 write FOnNavigateComplete2;
    property OnDocumentComplete : TDWebBrowserEvents2DocumentComplete read FOnDocumentComplete write FOnDocumentComplete;
    property OnOnQuit : TDWebBrowserEvents2OnQuit read FOnOnQuit write FOnOnQuit;
    property OnOnVisible : TDWebBrowserEvents2OnVisible read FOnOnVisible write FOnOnVisible;
    property OnOnToolBar : TDWebBrowserEvents2OnToolBar read FOnOnToolBar write FOnOnToolBar;
    property OnOnMenuBar : TDWebBrowserEvents2OnMenuBar read FOnOnMenuBar write FOnOnMenuBar;
    property OnOnStatusBar : TDWebBrowserEvents2OnStatusBar read FOnOnStatusBar write FOnOnStatusBar;
    property OnOnFullScreen : TDWebBrowserEvents2OnFullScreen read FOnOnFullScreen write FOnOnFullScreen;
    property OnOnTheaterMode : TDWebBrowserEvents2OnTheaterMode read FOnOnTheaterMode write FOnOnTheaterMode;
    property OnWindowSetResizable : TDWebBrowserEvents2WindowSetResizable read FOnWindowSetResizable write FOnWindowSetResizable;
    property OnWindowSetLeft : TDWebBrowserEvents2WindowSetLeft read FOnWindowSetLeft write FOnWindowSetLeft;
    property OnWindowSetTop : TDWebBrowserEvents2WindowSetTop read FOnWindowSetTop write FOnWindowSetTop;
    property OnWindowSetWidth : TDWebBrowserEvents2WindowSetWidth read FOnWindowSetWidth write FOnWindowSetWidth;
    property OnWindowSetHeight : TDWebBrowserEvents2WindowSetHeight read FOnWindowSetHeight write FOnWindowSetHeight;
    property OnWindowClosing : TDWebBrowserEvents2WindowClosing read FOnWindowClosing write FOnWindowClosing;
    property OnClientToHostWindow : TDWebBrowserEvents2ClientToHostWindow read FOnClientToHostWindow write FOnClientToHostWindow;
    property OnSetSecureLockIcon : TDWebBrowserEvents2SetSecureLockIcon read FOnSetSecureLockIcon write FOnSetSecureLockIcon;
    property OnFileDownload : TDWebBrowserEvents2FileDownload read FOnFileDownload write FOnFileDownload;
    property OnNavigateError : TDWebBrowserEvents2NavigateError read FOnNavigateError write FOnNavigateError;
    property OnPrintTemplateInstantiation : TDWebBrowserEvents2PrintTemplateInstantiation read FOnPrintTemplateInstantiation write FOnPrintTemplateInstantiation;
    property OnPrintTemplateTeardown : TDWebBrowserEvents2PrintTemplateTeardown read FOnPrintTemplateTeardown write FOnPrintTemplateTeardown;
    property OnUpdatePageStatus : TDWebBrowserEvents2UpdatePageStatus read FOnUpdatePageStatus write FOnUpdatePageStatus;
    property OnPrivacyImpactedStateChange : TDWebBrowserEvents2PrivacyImpactedStateChange read FOnPrivacyImpactedStateChange write FOnPrivacyImpactedStateChange;
    property OnNewWindow3 : TDWebBrowserEvents2NewWindow3 read FOnNewWindow3 write FOnNewWindow3;
    property OnSetPhishingFilterStatus : TDWebBrowserEvents2SetPhishingFilterStatus read FOnSetPhishingFilterStatus write FOnSetPhishingFilterStatus;
    property OnWindowStateChanged : TDWebBrowserEvents2WindowStateChanged read FOnWindowStateChanged write FOnWindowStateChanged;
    property OnNewProcess : TDWebBrowserEvents2NewProcess read FOnNewProcess write FOnNewProcess;
    property OnThirdPartyUrlBlocked : TDWebBrowserEvents2ThirdPartyUrlBlocked read FOnThirdPartyUrlBlocked write FOnThirdPartyUrlBlocked;
    property OnRedirectXDomainBlocked : TDWebBrowserEvents2RedirectXDomainBlocked read FOnRedirectXDomainBlocked write FOnRedirectXDomainBlocked;
    property OnBeforeScriptExecute : TDWebBrowserEvents2BeforeScriptExecute read FOnBeforeScriptExecute write FOnBeforeScriptExecute;
    property OnWebWorkerStarted : TDWebBrowserEvents2WebWorkerStarted read FOnWebWorkerStarted write FOnWebWorkerStarted;
    property OnWebWorkerFinsihed : TDWebBrowserEvents2WebWorkerFinsihed read FOnWebWorkerFinsihed write FOnWebWorkerFinsihed;

  end;

  TDShellWindowsEventsWindowRegistered = procedure(Sender: TObject;lCookie:Integer) of object;
  TDShellWindowsEventsWindowRevoked = procedure(Sender: TObject;lCookie:Integer) of object;


  CoShellWindows = Class
  Public
    Class Function Create: IShellWindows;
    Class Function CreateRemote(const MachineName: string): IShellWindows;
  end;

  TEvsShellWindows = Class(TEventSink)
  Private
    FOnWindowRegistered:TDShellWindowsEventsWindowRegistered;
    FOnWindowRevoked:TDShellWindowsEventsWindowRevoked;

    fServer:IShellWindows;
    procedure EventSinkInvoke(Sender: TObject; DispID: Integer;
          const IID: TGUID; LocaleID: Integer; Flags: Word;
          Params: tagDISPPARAMS; VarResult, ExcepInfo, ArgErr: Pointer);
  Public
    constructor Create(TheOwner: TComponent); override;
    property ComServer:IShellWindows read fServer;
    property OnWindowRegistered : TDShellWindowsEventsWindowRegistered read FOnWindowRegistered write FOnWindowRegistered;
    property OnWindowRevoked : TDShellWindowsEventsWindowRevoked read FOnWindowRevoked write FOnWindowRevoked;

  end;

  CoShellUIHelper = Class
  Public
    Class Function Create: IShellUIHelper8;
    Class Function CreateRemote(const MachineName: string): IShellUIHelper8;
  end;

  TDShellNameSpaceEventsFavoritesSelectionChange = procedure(Sender: TObject;cItems:Integer;hItem:Integer;strName:WideString;strUrl:WideString;cVisits:Integer;strDate:WideString;fAvailableOffline:Integer) of object;
  TDShellNameSpaceEventsSelectionChange = procedure(Sender: TObject) of object;
  TDShellNameSpaceEventsDoubleClick = procedure(Sender: TObject) of object;
  TDShellNameSpaceEventsInitialized = procedure(Sender: TObject) of object;


  CoShellNameSpace = Class
  Public
    Class Function Create: IShellNameSpace;
    Class Function CreateRemote(const MachineName: string): IShellNameSpace;
  end;

  TEvsShellNameSpace = Class(TEventSink)
  Private
    FOnFavoritesSelectionChange:TDShellNameSpaceEventsFavoritesSelectionChange;
    FOnSelectionChange:TDShellNameSpaceEventsSelectionChange;
    FOnDoubleClick:TDShellNameSpaceEventsDoubleClick;
    FOnInitialized:TDShellNameSpaceEventsInitialized;

    fServer:IShellNameSpace;
    procedure EventSinkInvoke(Sender: TObject; DispID: Integer;
          const IID: TGUID; LocaleID: Integer; Flags: Word;
          Params: tagDISPPARAMS; VarResult, ExcepInfo, ArgErr: Pointer);
  Public
    constructor Create(TheOwner: TComponent); override;
    property ComServer:IShellNameSpace read fServer;
    property OnFavoritesSelectionChange : TDShellNameSpaceEventsFavoritesSelectionChange read FOnFavoritesSelectionChange write FOnFavoritesSelectionChange;
    property OnSelectionChange : TDShellNameSpaceEventsSelectionChange read FOnSelectionChange write FOnSelectionChange;
    property OnDoubleClick : TDShellNameSpaceEventsDoubleClick read FOnDoubleClick write FOnDoubleClick;
    property OnInitialized : TDShellNameSpaceEventsInitialized read FOnInitialized write FOnInitialized;

  end;

  CoCScriptErrorList = Class
  Public
    Class Function Create: IScriptErrorList;
    Class Function CreateRemote(const MachineName: string): IScriptErrorList;
  end;

implementation

uses comobj;

Class Function CoWebBrowser_V1.Create: IWebBrowser;
begin
  Result := CreateComObject(CLASS_WebBrowser_V1) as IWebBrowser;
end;

Class Function CoWebBrowser_V1.CreateRemote(const MachineName: string): IWebBrowser;
begin
  Result := CreateRemoteComObject(MachineName,CLASS_WebBrowser_V1) as IWebBrowser;
end;

constructor TEvsWebBrowser_V1.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);
  OnInvoke:=EventSinkInvoke;
  fServer:=CoWebBrowser_V1.Create;
  Connect(fServer,DWebBrowserEvents);
end;

procedure TEvsWebBrowser_V1.EventSinkInvoke(Sender: TObject; DispID: Integer;
  const IID: TGUID; LocaleID: Integer; Flags: Word; Params: tagDISPPARAMS;
  VarResult, ExcepInfo, ArgErr: Pointer);
begin
  case DispID of
    100: if assigned(OnBeforeNavigate) then
          OnBeforeNavigate(Self, OleVariant(Params.rgvarg[5]), OleVariant(Params.rgvarg[4]), OleVariant(Params.rgvarg[3]), OleVariant(Params.rgvarg[2].byRef^), OleVariant(Params.rgvarg[1]), Params.rgvarg[0].pbool^);
    101: if assigned(OnNavigateComplete) then
          OnNavigateComplete(Self, OleVariant(Params.rgvarg[0]));
    102: if assigned(OnStatusTextChange) then
          OnStatusTextChange(Self, OleVariant(Params.rgvarg[0]));
    108: if assigned(OnProgressChange) then
          OnProgressChange(Self, OleVariant(Params.rgvarg[1]), OleVariant(Params.rgvarg[0]));
    104: if assigned(OnDownloadComplete) then
          OnDownloadComplete(Self);
    105: if assigned(OnCommandStateChange) then
          OnCommandStateChange(Self, OleVariant(Params.rgvarg[1]), OleVariant(Params.rgvarg[0]));
    106: if assigned(OnDownloadBegin) then
          OnDownloadBegin(Self);
    107: if assigned(OnNewWindow) then
          OnNewWindow(Self, OleVariant(Params.rgvarg[5]), OleVariant(Params.rgvarg[4]), OleVariant(Params.rgvarg[3]), OleVariant(Params.rgvarg[2].byRef^), OleVariant(Params.rgvarg[1]), Params.rgvarg[0].pbool^);
    113: if assigned(OnTitleChange) then
          OnTitleChange(Self, OleVariant(Params.rgvarg[0]));
    200: if assigned(OnFrameBeforeNavigate) then
          OnFrameBeforeNavigate(Self, OleVariant(Params.rgvarg[5]), OleVariant(Params.rgvarg[4]), OleVariant(Params.rgvarg[3]), OleVariant(Params.rgvarg[2].byRef^), OleVariant(Params.rgvarg[1]), Params.rgvarg[0].pbool^);
    201: if assigned(OnFrameNavigateComplete) then
          OnFrameNavigateComplete(Self, OleVariant(Params.rgvarg[0]));
    204: if assigned(OnFrameNewWindow) then
          OnFrameNewWindow(Self, OleVariant(Params.rgvarg[5]), OleVariant(Params.rgvarg[4]), OleVariant(Params.rgvarg[3]), OleVariant(Params.rgvarg[2].byRef^), OleVariant(Params.rgvarg[1]), Params.rgvarg[0].pbool^);
    103: if assigned(OnQuit) then
          OnQuit(Self, Params.rgvarg[0].pbool^);
    109: if assigned(OnWindowMove) then
          OnWindowMove(Self);
    110: if assigned(OnWindowResize) then
          OnWindowResize(Self);
    111: if assigned(OnWindowActivate) then
          OnWindowActivate(Self);
    112: if assigned(OnPropertyChange) then
          OnPropertyChange(Self, OleVariant(Params.rgvarg[0]));

  end;
end;

Class Function CoWebBrowser.Create: IWebBrowser2;
begin
  Result := CreateComObject(CLASS_WebBrowser) as IWebBrowser2;
end;

Class Function CoWebBrowser.CreateRemote(const MachineName: string): IWebBrowser2;
begin
  Result := CreateRemoteComObject(MachineName,CLASS_WebBrowser) as IWebBrowser2;
end;

constructor TEvsWebBrowser.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);
  OnInvoke:=EventSinkInvoke;
  fServer:=CoWebBrowser.Create;
  Connect(fServer,DWebBrowserEvents2);
end;

procedure TEvsWebBrowser.EventSinkInvoke(Sender: TObject; DispID: Integer;
  const IID: TGUID; LocaleID: Integer; Flags: Word; Params: tagDISPPARAMS;
  VarResult, ExcepInfo, ArgErr: Pointer);
begin
  case DispID of
    102: if assigned(OnStatusTextChange) then
          OnStatusTextChange(Self, OleVariant(Params.rgvarg[0]));
    108: if assigned(OnProgressChange) then
          OnProgressChange(Self, OleVariant(Params.rgvarg[1]), OleVariant(Params.rgvarg[0]));
    105: if assigned(OnCommandStateChange) then
          OnCommandStateChange(Self, OleVariant(Params.rgvarg[1]), OleVariant(Params.rgvarg[0]));
    106: if assigned(OnDownloadBegin) then
          OnDownloadBegin(Self);
    104: if assigned(OnDownloadComplete) then
          OnDownloadComplete(Self);
    113: if assigned(OnTitleChange) then
          OnTitleChange(Self, OleVariant(Params.rgvarg[0]));
    112: if assigned(OnPropertyChange) then
          OnPropertyChange(Self, OleVariant(Params.rgvarg[0]));
    250: if assigned(OnBeforeNavigate2) then
          OnBeforeNavigate2(Self, OleVariant(Params.rgvarg[6]), OleVariant(Params.rgvarg[5].byRef^), OleVariant(Params.rgvarg[4].byRef^), OleVariant(Params.rgvarg[3].byRef^), OleVariant(Params.rgvarg[2].byRef^), OleVariant(Params.rgvarg[1].byRef^), Params.rgvarg[0].pbool^);
    251: if assigned(OnNewWindow2) then
          OnNewWindow2(Self, Params.rgvarg[1].pdispVal^, Params.rgvarg[0].pbool^);
    252: if assigned(OnNavigateComplete2) then
          OnNavigateComplete2(Self, OleVariant(Params.rgvarg[1]), OleVariant(Params.rgvarg[0].byRef^));
    259: if assigned(OnDocumentComplete) then
          OnDocumentComplete(Self, OleVariant(Params.rgvarg[1]), OleVariant(Params.rgvarg[0].byRef^));
    253: if assigned(OnOnQuit) then
          OnOnQuit(Self);
    254: if assigned(OnOnVisible) then
          OnOnVisible(Self, OleVariant(Params.rgvarg[0]));
    255: if assigned(OnOnToolBar) then
          OnOnToolBar(Self, OleVariant(Params.rgvarg[0]));
    256: if assigned(OnOnMenuBar) then
          OnOnMenuBar(Self, OleVariant(Params.rgvarg[0]));
    257: if assigned(OnOnStatusBar) then
          OnOnStatusBar(Self, OleVariant(Params.rgvarg[0]));
    258: if assigned(OnOnFullScreen) then
          OnOnFullScreen(Self, OleVariant(Params.rgvarg[0]));
    260: if assigned(OnOnTheaterMode) then
          OnOnTheaterMode(Self, OleVariant(Params.rgvarg[0]));
    262: if assigned(OnWindowSetResizable) then
          OnWindowSetResizable(Self, OleVariant(Params.rgvarg[0]));
    264: if assigned(OnWindowSetLeft) then
          OnWindowSetLeft(Self, OleVariant(Params.rgvarg[0]));
    265: if assigned(OnWindowSetTop) then
          OnWindowSetTop(Self, OleVariant(Params.rgvarg[0]));
    266: if assigned(OnWindowSetWidth) then
          OnWindowSetWidth(Self, OleVariant(Params.rgvarg[0]));
    267: if assigned(OnWindowSetHeight) then
          OnWindowSetHeight(Self, OleVariant(Params.rgvarg[0]));
    263: if assigned(OnWindowClosing) then
          OnWindowClosing(Self, OleVariant(Params.rgvarg[1]), Params.rgvarg[0].pbool^);
    268: if assigned(OnClientToHostWindow) then
          OnClientToHostWindow(Self, Params.rgvarg[1].plVal^, Params.rgvarg[0].plVal^);
    269: if assigned(OnSetSecureLockIcon) then
          OnSetSecureLockIcon(Self, OleVariant(Params.rgvarg[0]));
    270: if assigned(OnFileDownload) then
          OnFileDownload(Self, OleVariant(Params.rgvarg[1]), Params.rgvarg[0].pbool^);
    271: if assigned(OnNavigateError) then
          OnNavigateError(Self, OleVariant(Params.rgvarg[4]), OleVariant(Params.rgvarg[3].byRef^), OleVariant(Params.rgvarg[2].byRef^), OleVariant(Params.rgvarg[1].byRef^), Params.rgvarg[0].pbool^);
    225: if assigned(OnPrintTemplateInstantiation) then
          OnPrintTemplateInstantiation(Self, OleVariant(Params.rgvarg[0]));
    226: if assigned(OnPrintTemplateTeardown) then
          OnPrintTemplateTeardown(Self, OleVariant(Params.rgvarg[0]));
    227: if assigned(OnUpdatePageStatus) then
          OnUpdatePageStatus(Self, OleVariant(Params.rgvarg[2]), OleVariant(Params.rgvarg[1].byRef^), OleVariant(Params.rgvarg[0].byRef^));
    272: if assigned(OnPrivacyImpactedStateChange) then
          OnPrivacyImpactedStateChange(Self, OleVariant(Params.rgvarg[0]));
    273: if assigned(OnNewWindow3) then
          OnNewWindow3(Self, Params.rgvarg[4].pdispVal^, Params.rgvarg[3].pbool^, OleVariant(Params.rgvarg[2]), OleVariant(Params.rgvarg[1]), OleVariant(Params.rgvarg[0]));
    282: if assigned(OnSetPhishingFilterStatus) then
          OnSetPhishingFilterStatus(Self, OleVariant(Params.rgvarg[0]));
    283: if assigned(OnWindowStateChanged) then
          OnWindowStateChanged(Self, OleVariant(Params.rgvarg[1]), OleVariant(Params.rgvarg[0]));
    284: if assigned(OnNewProcess) then
          OnNewProcess(Self, OleVariant(Params.rgvarg[2]), OleVariant(Params.rgvarg[1]), Params.rgvarg[0].pbool^);
    285: if assigned(OnThirdPartyUrlBlocked) then
          OnThirdPartyUrlBlocked(Self, OleVariant(Params.rgvarg[1].byRef^), OleVariant(Params.rgvarg[0]));
    286: if assigned(OnRedirectXDomainBlocked) then
          OnRedirectXDomainBlocked(Self, OleVariant(Params.rgvarg[4]), OleVariant(Params.rgvarg[3].byRef^), OleVariant(Params.rgvarg[2].byRef^), OleVariant(Params.rgvarg[1].byRef^), OleVariant(Params.rgvarg[0].byRef^));
    290: if assigned(OnBeforeScriptExecute) then
          OnBeforeScriptExecute(Self, OleVariant(Params.rgvarg[0]));
    288: if assigned(OnWebWorkerStarted) then
          OnWebWorkerStarted(Self, OleVariant(Params.rgvarg[1]), OleVariant(Params.rgvarg[0]));
    289: if assigned(OnWebWorkerFinsihed) then
          OnWebWorkerFinsihed(Self, OleVariant(Params.rgvarg[0]));

  end;
end;

Class Function CoInternetExplorer.Create: IWebBrowser2;
begin
  Result := CreateComObject(CLASS_InternetExplorer) as IWebBrowser2;
end;

Class Function CoInternetExplorer.CreateRemote(const MachineName: string): IWebBrowser2;
begin
  Result := CreateRemoteComObject(MachineName,CLASS_InternetExplorer) as IWebBrowser2;
end;

constructor TEvsInternetExplorer.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);
  OnInvoke:=EventSinkInvoke;
  fServer:=CoInternetExplorer.Create;
  Connect(fServer,DWebBrowserEvents2);
end;

procedure TEvsInternetExplorer.EventSinkInvoke(Sender: TObject; DispID: Integer;
  const IID: TGUID; LocaleID: Integer; Flags: Word; Params: tagDISPPARAMS;
  VarResult, ExcepInfo, ArgErr: Pointer);
begin
  case DispID of
    102: if assigned(OnStatusTextChange) then
          OnStatusTextChange(Self, OleVariant(Params.rgvarg[0]));
    108: if assigned(OnProgressChange) then
          OnProgressChange(Self, OleVariant(Params.rgvarg[1]), OleVariant(Params.rgvarg[0]));
    105: if assigned(OnCommandStateChange) then
          OnCommandStateChange(Self, OleVariant(Params.rgvarg[1]), OleVariant(Params.rgvarg[0]));
    106: if assigned(OnDownloadBegin) then
          OnDownloadBegin(Self);
    104: if assigned(OnDownloadComplete) then
          OnDownloadComplete(Self);
    113: if assigned(OnTitleChange) then
          OnTitleChange(Self, OleVariant(Params.rgvarg[0]));
    112: if assigned(OnPropertyChange) then
          OnPropertyChange(Self, OleVariant(Params.rgvarg[0]));
    250: if assigned(OnBeforeNavigate2) then
          OnBeforeNavigate2(Self, OleVariant(Params.rgvarg[6]), OleVariant(Params.rgvarg[5].byRef^), OleVariant(Params.rgvarg[4].byRef^), OleVariant(Params.rgvarg[3].byRef^), OleVariant(Params.rgvarg[2].byRef^), OleVariant(Params.rgvarg[1].byRef^), Params.rgvarg[0].pbool^);
    251: if assigned(OnNewWindow2) then
          OnNewWindow2(Self, Params.rgvarg[1].pdispVal^, Params.rgvarg[0].pbool^);
    252: if assigned(OnNavigateComplete2) then
          OnNavigateComplete2(Self, OleVariant(Params.rgvarg[1]), OleVariant(Params.rgvarg[0].byRef^));
    259: if assigned(OnDocumentComplete) then
          OnDocumentComplete(Self, OleVariant(Params.rgvarg[1]), OleVariant(Params.rgvarg[0].byRef^));
    253: if assigned(OnOnQuit) then
          OnOnQuit(Self);
    254: if assigned(OnOnVisible) then
          OnOnVisible(Self, OleVariant(Params.rgvarg[0]));
    255: if assigned(OnOnToolBar) then
          OnOnToolBar(Self, OleVariant(Params.rgvarg[0]));
    256: if assigned(OnOnMenuBar) then
          OnOnMenuBar(Self, OleVariant(Params.rgvarg[0]));
    257: if assigned(OnOnStatusBar) then
          OnOnStatusBar(Self, OleVariant(Params.rgvarg[0]));
    258: if assigned(OnOnFullScreen) then
          OnOnFullScreen(Self, OleVariant(Params.rgvarg[0]));
    260: if assigned(OnOnTheaterMode) then
          OnOnTheaterMode(Self, OleVariant(Params.rgvarg[0]));
    262: if assigned(OnWindowSetResizable) then
          OnWindowSetResizable(Self, OleVariant(Params.rgvarg[0]));
    264: if assigned(OnWindowSetLeft) then
          OnWindowSetLeft(Self, OleVariant(Params.rgvarg[0]));
    265: if assigned(OnWindowSetTop) then
          OnWindowSetTop(Self, OleVariant(Params.rgvarg[0]));
    266: if assigned(OnWindowSetWidth) then
          OnWindowSetWidth(Self, OleVariant(Params.rgvarg[0]));
    267: if assigned(OnWindowSetHeight) then
          OnWindowSetHeight(Self, OleVariant(Params.rgvarg[0]));
    263: if assigned(OnWindowClosing) then
          OnWindowClosing(Self, OleVariant(Params.rgvarg[1]), Params.rgvarg[0].pbool^);
    268: if assigned(OnClientToHostWindow) then
          OnClientToHostWindow(Self, Params.rgvarg[1].plVal^, Params.rgvarg[0].plVal^);
    269: if assigned(OnSetSecureLockIcon) then
          OnSetSecureLockIcon(Self, OleVariant(Params.rgvarg[0]));
    270: if assigned(OnFileDownload) then
          OnFileDownload(Self, OleVariant(Params.rgvarg[1]), Params.rgvarg[0].pbool^);
    271: if assigned(OnNavigateError) then
          OnNavigateError(Self, OleVariant(Params.rgvarg[4]), OleVariant(Params.rgvarg[3].byRef^), OleVariant(Params.rgvarg[2].byRef^), OleVariant(Params.rgvarg[1].byRef^), Params.rgvarg[0].pbool^);
    225: if assigned(OnPrintTemplateInstantiation) then
          OnPrintTemplateInstantiation(Self, OleVariant(Params.rgvarg[0]));
    226: if assigned(OnPrintTemplateTeardown) then
          OnPrintTemplateTeardown(Self, OleVariant(Params.rgvarg[0]));
    227: if assigned(OnUpdatePageStatus) then
          OnUpdatePageStatus(Self, OleVariant(Params.rgvarg[2]), OleVariant(Params.rgvarg[1].byRef^), OleVariant(Params.rgvarg[0].byRef^));
    272: if assigned(OnPrivacyImpactedStateChange) then
          OnPrivacyImpactedStateChange(Self, OleVariant(Params.rgvarg[0]));
    273: if assigned(OnNewWindow3) then
          OnNewWindow3(Self, Params.rgvarg[4].pdispVal^, Params.rgvarg[3].pbool^, OleVariant(Params.rgvarg[2]), OleVariant(Params.rgvarg[1]), OleVariant(Params.rgvarg[0]));
    282: if assigned(OnSetPhishingFilterStatus) then
          OnSetPhishingFilterStatus(Self, OleVariant(Params.rgvarg[0]));
    283: if assigned(OnWindowStateChanged) then
          OnWindowStateChanged(Self, OleVariant(Params.rgvarg[1]), OleVariant(Params.rgvarg[0]));
    284: if assigned(OnNewProcess) then
          OnNewProcess(Self, OleVariant(Params.rgvarg[2]), OleVariant(Params.rgvarg[1]), Params.rgvarg[0].pbool^);
    285: if assigned(OnThirdPartyUrlBlocked) then
          OnThirdPartyUrlBlocked(Self, OleVariant(Params.rgvarg[1].byRef^), OleVariant(Params.rgvarg[0]));
    286: if assigned(OnRedirectXDomainBlocked) then
          OnRedirectXDomainBlocked(Self, OleVariant(Params.rgvarg[4]), OleVariant(Params.rgvarg[3].byRef^), OleVariant(Params.rgvarg[2].byRef^), OleVariant(Params.rgvarg[1].byRef^), OleVariant(Params.rgvarg[0].byRef^));
    290: if assigned(OnBeforeScriptExecute) then
          OnBeforeScriptExecute(Self, OleVariant(Params.rgvarg[0]));
    288: if assigned(OnWebWorkerStarted) then
          OnWebWorkerStarted(Self, OleVariant(Params.rgvarg[1]), OleVariant(Params.rgvarg[0]));
    289: if assigned(OnWebWorkerFinsihed) then
          OnWebWorkerFinsihed(Self, OleVariant(Params.rgvarg[0]));

  end;
end;

Class Function CoInternetExplorerMedium.Create: IWebBrowser2;
begin
  Result := CreateComObject(CLASS_InternetExplorerMedium) as IWebBrowser2;
end;

Class Function CoInternetExplorerMedium.CreateRemote(const MachineName: string): IWebBrowser2;
begin
  Result := CreateRemoteComObject(MachineName,CLASS_InternetExplorerMedium) as IWebBrowser2;
end;

constructor TEvsInternetExplorerMedium.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);
  OnInvoke:=EventSinkInvoke;
  fServer:=CoInternetExplorerMedium.Create;
  Connect(fServer,DWebBrowserEvents2);
end;

procedure TEvsInternetExplorerMedium.EventSinkInvoke(Sender: TObject; DispID: Integer;
  const IID: TGUID; LocaleID: Integer; Flags: Word; Params: tagDISPPARAMS;
  VarResult, ExcepInfo, ArgErr: Pointer);
begin
  case DispID of
    102: if assigned(OnStatusTextChange) then
          OnStatusTextChange(Self, OleVariant(Params.rgvarg[0]));
    108: if assigned(OnProgressChange) then
          OnProgressChange(Self, OleVariant(Params.rgvarg[1]), OleVariant(Params.rgvarg[0]));
    105: if assigned(OnCommandStateChange) then
          OnCommandStateChange(Self, OleVariant(Params.rgvarg[1]), OleVariant(Params.rgvarg[0]));
    106: if assigned(OnDownloadBegin) then
          OnDownloadBegin(Self);
    104: if assigned(OnDownloadComplete) then
          OnDownloadComplete(Self);
    113: if assigned(OnTitleChange) then
          OnTitleChange(Self, OleVariant(Params.rgvarg[0]));
    112: if assigned(OnPropertyChange) then
          OnPropertyChange(Self, OleVariant(Params.rgvarg[0]));
    250: if assigned(OnBeforeNavigate2) then
          OnBeforeNavigate2(Self, OleVariant(Params.rgvarg[6]), OleVariant(Params.rgvarg[5].byRef^), OleVariant(Params.rgvarg[4].byRef^), OleVariant(Params.rgvarg[3].byRef^), OleVariant(Params.rgvarg[2].byRef^), OleVariant(Params.rgvarg[1].byRef^), Params.rgvarg[0].pbool^);
    251: if assigned(OnNewWindow2) then
          OnNewWindow2(Self, Params.rgvarg[1].pdispVal^, Params.rgvarg[0].pbool^);
    252: if assigned(OnNavigateComplete2) then
          OnNavigateComplete2(Self, OleVariant(Params.rgvarg[1]), OleVariant(Params.rgvarg[0].byRef^));
    259: if assigned(OnDocumentComplete) then
          OnDocumentComplete(Self, OleVariant(Params.rgvarg[1]), OleVariant(Params.rgvarg[0].byRef^));
    253: if assigned(OnOnQuit) then
          OnOnQuit(Self);
    254: if assigned(OnOnVisible) then
          OnOnVisible(Self, OleVariant(Params.rgvarg[0]));
    255: if assigned(OnOnToolBar) then
          OnOnToolBar(Self, OleVariant(Params.rgvarg[0]));
    256: if assigned(OnOnMenuBar) then
          OnOnMenuBar(Self, OleVariant(Params.rgvarg[0]));
    257: if assigned(OnOnStatusBar) then
          OnOnStatusBar(Self, OleVariant(Params.rgvarg[0]));
    258: if assigned(OnOnFullScreen) then
          OnOnFullScreen(Self, OleVariant(Params.rgvarg[0]));
    260: if assigned(OnOnTheaterMode) then
          OnOnTheaterMode(Self, OleVariant(Params.rgvarg[0]));
    262: if assigned(OnWindowSetResizable) then
          OnWindowSetResizable(Self, OleVariant(Params.rgvarg[0]));
    264: if assigned(OnWindowSetLeft) then
          OnWindowSetLeft(Self, OleVariant(Params.rgvarg[0]));
    265: if assigned(OnWindowSetTop) then
          OnWindowSetTop(Self, OleVariant(Params.rgvarg[0]));
    266: if assigned(OnWindowSetWidth) then
          OnWindowSetWidth(Self, OleVariant(Params.rgvarg[0]));
    267: if assigned(OnWindowSetHeight) then
          OnWindowSetHeight(Self, OleVariant(Params.rgvarg[0]));
    263: if assigned(OnWindowClosing) then
          OnWindowClosing(Self, OleVariant(Params.rgvarg[1]), Params.rgvarg[0].pbool^);
    268: if assigned(OnClientToHostWindow) then
          OnClientToHostWindow(Self, Params.rgvarg[1].plVal^, Params.rgvarg[0].plVal^);
    269: if assigned(OnSetSecureLockIcon) then
          OnSetSecureLockIcon(Self, OleVariant(Params.rgvarg[0]));
    270: if assigned(OnFileDownload) then
          OnFileDownload(Self, OleVariant(Params.rgvarg[1]), Params.rgvarg[0].pbool^);
    271: if assigned(OnNavigateError) then
          OnNavigateError(Self, OleVariant(Params.rgvarg[4]), OleVariant(Params.rgvarg[3].byRef^), OleVariant(Params.rgvarg[2].byRef^), OleVariant(Params.rgvarg[1].byRef^), Params.rgvarg[0].pbool^);
    225: if assigned(OnPrintTemplateInstantiation) then
          OnPrintTemplateInstantiation(Self, OleVariant(Params.rgvarg[0]));
    226: if assigned(OnPrintTemplateTeardown) then
          OnPrintTemplateTeardown(Self, OleVariant(Params.rgvarg[0]));
    227: if assigned(OnUpdatePageStatus) then
          OnUpdatePageStatus(Self, OleVariant(Params.rgvarg[2]), OleVariant(Params.rgvarg[1].byRef^), OleVariant(Params.rgvarg[0].byRef^));
    272: if assigned(OnPrivacyImpactedStateChange) then
          OnPrivacyImpactedStateChange(Self, OleVariant(Params.rgvarg[0]));
    273: if assigned(OnNewWindow3) then
          OnNewWindow3(Self, Params.rgvarg[4].pdispVal^, Params.rgvarg[3].pbool^, OleVariant(Params.rgvarg[2]), OleVariant(Params.rgvarg[1]), OleVariant(Params.rgvarg[0]));
    282: if assigned(OnSetPhishingFilterStatus) then
          OnSetPhishingFilterStatus(Self, OleVariant(Params.rgvarg[0]));
    283: if assigned(OnWindowStateChanged) then
          OnWindowStateChanged(Self, OleVariant(Params.rgvarg[1]), OleVariant(Params.rgvarg[0]));
    284: if assigned(OnNewProcess) then
          OnNewProcess(Self, OleVariant(Params.rgvarg[2]), OleVariant(Params.rgvarg[1]), Params.rgvarg[0].pbool^);
    285: if assigned(OnThirdPartyUrlBlocked) then
          OnThirdPartyUrlBlocked(Self, OleVariant(Params.rgvarg[1].byRef^), OleVariant(Params.rgvarg[0]));
    286: if assigned(OnRedirectXDomainBlocked) then
          OnRedirectXDomainBlocked(Self, OleVariant(Params.rgvarg[4]), OleVariant(Params.rgvarg[3].byRef^), OleVariant(Params.rgvarg[2].byRef^), OleVariant(Params.rgvarg[1].byRef^), OleVariant(Params.rgvarg[0].byRef^));
    290: if assigned(OnBeforeScriptExecute) then
          OnBeforeScriptExecute(Self, OleVariant(Params.rgvarg[0]));
    288: if assigned(OnWebWorkerStarted) then
          OnWebWorkerStarted(Self, OleVariant(Params.rgvarg[1]), OleVariant(Params.rgvarg[0]));
    289: if assigned(OnWebWorkerFinsihed) then
          OnWebWorkerFinsihed(Self, OleVariant(Params.rgvarg[0]));

  end;
end;

Class Function CoShellBrowserWindow.Create: IWebBrowser2;
begin
  Result := CreateComObject(CLASS_ShellBrowserWindow) as IWebBrowser2;
end;

Class Function CoShellBrowserWindow.CreateRemote(const MachineName: string): IWebBrowser2;
begin
  Result := CreateRemoteComObject(MachineName,CLASS_ShellBrowserWindow) as IWebBrowser2;
end;

constructor TEvsShellBrowserWindow.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);
  OnInvoke:=EventSinkInvoke;
  fServer:=CoShellBrowserWindow.Create;
  Connect(fServer,DWebBrowserEvents2);
end;

procedure TEvsShellBrowserWindow.EventSinkInvoke(Sender: TObject; DispID: Integer;
  const IID: TGUID; LocaleID: Integer; Flags: Word; Params: tagDISPPARAMS;
  VarResult, ExcepInfo, ArgErr: Pointer);
begin
  case DispID of
    102: if assigned(OnStatusTextChange) then
          OnStatusTextChange(Self, OleVariant(Params.rgvarg[0]));
    108: if assigned(OnProgressChange) then
          OnProgressChange(Self, OleVariant(Params.rgvarg[1]), OleVariant(Params.rgvarg[0]));
    105: if assigned(OnCommandStateChange) then
          OnCommandStateChange(Self, OleVariant(Params.rgvarg[1]), OleVariant(Params.rgvarg[0]));
    106: if assigned(OnDownloadBegin) then
          OnDownloadBegin(Self);
    104: if assigned(OnDownloadComplete) then
          OnDownloadComplete(Self);
    113: if assigned(OnTitleChange) then
          OnTitleChange(Self, OleVariant(Params.rgvarg[0]));
    112: if assigned(OnPropertyChange) then
          OnPropertyChange(Self, OleVariant(Params.rgvarg[0]));
    250: if assigned(OnBeforeNavigate2) then
          OnBeforeNavigate2(Self, OleVariant(Params.rgvarg[6]), OleVariant(Params.rgvarg[5].byRef^), OleVariant(Params.rgvarg[4].byRef^), OleVariant(Params.rgvarg[3].byRef^), OleVariant(Params.rgvarg[2].byRef^), OleVariant(Params.rgvarg[1].byRef^), Params.rgvarg[0].pbool^);
    251: if assigned(OnNewWindow2) then
          OnNewWindow2(Self, Params.rgvarg[1].pdispVal^, Params.rgvarg[0].pbool^);
    252: if assigned(OnNavigateComplete2) then
          OnNavigateComplete2(Self, OleVariant(Params.rgvarg[1]), OleVariant(Params.rgvarg[0].byRef^));
    259: if assigned(OnDocumentComplete) then
          OnDocumentComplete(Self, OleVariant(Params.rgvarg[1]), OleVariant(Params.rgvarg[0].byRef^));
    253: if assigned(OnOnQuit) then
          OnOnQuit(Self);
    254: if assigned(OnOnVisible) then
          OnOnVisible(Self, OleVariant(Params.rgvarg[0]));
    255: if assigned(OnOnToolBar) then
          OnOnToolBar(Self, OleVariant(Params.rgvarg[0]));
    256: if assigned(OnOnMenuBar) then
          OnOnMenuBar(Self, OleVariant(Params.rgvarg[0]));
    257: if assigned(OnOnStatusBar) then
          OnOnStatusBar(Self, OleVariant(Params.rgvarg[0]));
    258: if assigned(OnOnFullScreen) then
          OnOnFullScreen(Self, OleVariant(Params.rgvarg[0]));
    260: if assigned(OnOnTheaterMode) then
          OnOnTheaterMode(Self, OleVariant(Params.rgvarg[0]));
    262: if assigned(OnWindowSetResizable) then
          OnWindowSetResizable(Self, OleVariant(Params.rgvarg[0]));
    264: if assigned(OnWindowSetLeft) then
          OnWindowSetLeft(Self, OleVariant(Params.rgvarg[0]));
    265: if assigned(OnWindowSetTop) then
          OnWindowSetTop(Self, OleVariant(Params.rgvarg[0]));
    266: if assigned(OnWindowSetWidth) then
          OnWindowSetWidth(Self, OleVariant(Params.rgvarg[0]));
    267: if assigned(OnWindowSetHeight) then
          OnWindowSetHeight(Self, OleVariant(Params.rgvarg[0]));
    263: if assigned(OnWindowClosing) then
          OnWindowClosing(Self, OleVariant(Params.rgvarg[1]), Params.rgvarg[0].pbool^);
    268: if assigned(OnClientToHostWindow) then
          OnClientToHostWindow(Self, Params.rgvarg[1].plVal^, Params.rgvarg[0].plVal^);
    269: if assigned(OnSetSecureLockIcon) then
          OnSetSecureLockIcon(Self, OleVariant(Params.rgvarg[0]));
    270: if assigned(OnFileDownload) then
          OnFileDownload(Self, OleVariant(Params.rgvarg[1]), Params.rgvarg[0].pbool^);
    271: if assigned(OnNavigateError) then
          OnNavigateError(Self, OleVariant(Params.rgvarg[4]), OleVariant(Params.rgvarg[3].byRef^), OleVariant(Params.rgvarg[2].byRef^), OleVariant(Params.rgvarg[1].byRef^), Params.rgvarg[0].pbool^);
    225: if assigned(OnPrintTemplateInstantiation) then
          OnPrintTemplateInstantiation(Self, OleVariant(Params.rgvarg[0]));
    226: if assigned(OnPrintTemplateTeardown) then
          OnPrintTemplateTeardown(Self, OleVariant(Params.rgvarg[0]));
    227: if assigned(OnUpdatePageStatus) then
          OnUpdatePageStatus(Self, OleVariant(Params.rgvarg[2]), OleVariant(Params.rgvarg[1].byRef^), OleVariant(Params.rgvarg[0].byRef^));
    272: if assigned(OnPrivacyImpactedStateChange) then
          OnPrivacyImpactedStateChange(Self, OleVariant(Params.rgvarg[0]));
    273: if assigned(OnNewWindow3) then
          OnNewWindow3(Self, Params.rgvarg[4].pdispVal^, Params.rgvarg[3].pbool^, OleVariant(Params.rgvarg[2]), OleVariant(Params.rgvarg[1]), OleVariant(Params.rgvarg[0]));
    282: if assigned(OnSetPhishingFilterStatus) then
          OnSetPhishingFilterStatus(Self, OleVariant(Params.rgvarg[0]));
    283: if assigned(OnWindowStateChanged) then
          OnWindowStateChanged(Self, OleVariant(Params.rgvarg[1]), OleVariant(Params.rgvarg[0]));
    284: if assigned(OnNewProcess) then
          OnNewProcess(Self, OleVariant(Params.rgvarg[2]), OleVariant(Params.rgvarg[1]), Params.rgvarg[0].pbool^);
    285: if assigned(OnThirdPartyUrlBlocked) then
          OnThirdPartyUrlBlocked(Self, OleVariant(Params.rgvarg[1].byRef^), OleVariant(Params.rgvarg[0]));
    286: if assigned(OnRedirectXDomainBlocked) then
          OnRedirectXDomainBlocked(Self, OleVariant(Params.rgvarg[4]), OleVariant(Params.rgvarg[3].byRef^), OleVariant(Params.rgvarg[2].byRef^), OleVariant(Params.rgvarg[1].byRef^), OleVariant(Params.rgvarg[0].byRef^));
    290: if assigned(OnBeforeScriptExecute) then
          OnBeforeScriptExecute(Self, OleVariant(Params.rgvarg[0]));
    288: if assigned(OnWebWorkerStarted) then
          OnWebWorkerStarted(Self, OleVariant(Params.rgvarg[1]), OleVariant(Params.rgvarg[0]));
    289: if assigned(OnWebWorkerFinsihed) then
          OnWebWorkerFinsihed(Self, OleVariant(Params.rgvarg[0]));

  end;
end;

Class Function CoShellWindows.Create: IShellWindows;
begin
  Result := CreateComObject(CLASS_ShellWindows) as IShellWindows;
end;

Class Function CoShellWindows.CreateRemote(const MachineName: string): IShellWindows;
begin
  Result := CreateRemoteComObject(MachineName,CLASS_ShellWindows) as IShellWindows;
end;

constructor TEvsShellWindows.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);
  OnInvoke:=EventSinkInvoke;
  fServer:=CoShellWindows.Create;
  Connect(fServer,DShellWindowsEvents);
end;

procedure TEvsShellWindows.EventSinkInvoke(Sender: TObject; DispID: Integer;
  const IID: TGUID; LocaleID: Integer; Flags: Word; Params: tagDISPPARAMS;
  VarResult, ExcepInfo, ArgErr: Pointer);
begin
  case DispID of
    200: if assigned(OnWindowRegistered) then
          OnWindowRegistered(Self, OleVariant(Params.rgvarg[0]));
    201: if assigned(OnWindowRevoked) then
          OnWindowRevoked(Self, OleVariant(Params.rgvarg[0]));

  end;
end;

Class Function CoShellUIHelper.Create: IShellUIHelper8;
begin
  Result := CreateComObject(CLASS_ShellUIHelper) as IShellUIHelper8;
end;

Class Function CoShellUIHelper.CreateRemote(const MachineName: string): IShellUIHelper8;
begin
  Result := CreateRemoteComObject(MachineName,CLASS_ShellUIHelper) as IShellUIHelper8;
end;

Class Function CoShellNameSpace.Create: IShellNameSpace;
begin
  Result := CreateComObject(CLASS_ShellNameSpace) as IShellNameSpace;
end;

Class Function CoShellNameSpace.CreateRemote(const MachineName: string): IShellNameSpace;
begin
  Result := CreateRemoteComObject(MachineName,CLASS_ShellNameSpace) as IShellNameSpace;
end;

constructor TEvsShellNameSpace.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);
  OnInvoke:=EventSinkInvoke;
  fServer:=CoShellNameSpace.Create;
  Connect(fServer,DShellNameSpaceEvents);
end;

procedure TEvsShellNameSpace.EventSinkInvoke(Sender: TObject; DispID: Integer;
  const IID: TGUID; LocaleID: Integer; Flags: Word; Params: tagDISPPARAMS;
  VarResult, ExcepInfo, ArgErr: Pointer);
begin
  case DispID of
    1: if assigned(OnFavoritesSelectionChange) then
          OnFavoritesSelectionChange(Self, OleVariant(Params.rgvarg[6]), OleVariant(Params.rgvarg[5]), OleVariant(Params.rgvarg[4]), OleVariant(Params.rgvarg[3]), OleVariant(Params.rgvarg[2]), OleVariant(Params.rgvarg[1]), OleVariant(Params.rgvarg[0]));
    2: if assigned(OnSelectionChange) then
          OnSelectionChange(Self);
    3: if assigned(OnDoubleClick) then
          OnDoubleClick(Self);
    4: if assigned(OnInitialized) then
          OnInitialized(Self);

  end;
end;

Class Function CoCScriptErrorList.Create: IScriptErrorList;
begin
  Result := CreateComObject(CLASS_CScriptErrorList) as IScriptErrorList;
end;

Class Function CoCScriptErrorList.CreateRemote(const MachineName: string): IScriptErrorList;
begin
  Result := CreateRemoteComObject(MachineName,CLASS_CScriptErrorList) as IScriptErrorList;
end;

end.
