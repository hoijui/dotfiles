let s:save_cpo = &cpo
set cpo&vim

function! autohotkey#complete(findstart, base) "{{{1
  if a:findstart
    let line = getline('.')
    let start = col('.') - 1
    while start > 0 && line[start - 1] =~ '\S'
      let start -= 1
    endwhile
    return start
  else
    let res = []
    for m in split("#AllowSameLineComments #ClipboardTimeout #CommentFlag #ErrorStdOut #EscapeChar #HotkeyInterval #HotkeyModifierTimeout #Hotstring #IfWinActive #IfWinExist #Include #InstallKeybdHook #InstallMouseHook #KeyHistory #MaxHotkeysPerInterval #MaxMem #MaxThreads #MaxThreadsBuffer #MaxThreadsPerHotkey #NoEnv #NoTrayIcon #Persistent #SingleInstance #UseHook #WinActivateForce & && &= ** *= .= // //= /= := ?: ^= _Addref _Clone _Getaddress _Getcapacity _Haskey _Insert _Maxindex _Minindex _Newenum _Release _Remove _Setcapacity ` {!} {#} {$} {^} {`} {~} {+} {BLIND} | || |= } += < << <<= <= <> = -= == > >= >> >>= A_AhkVersion A_AppData A_AppDataCommon A_AutoTrim A_BatchLines A_CaretX A_CaretY A_ComputerName A_ControlDelay A_Cursor A_DD A_DDD A_DDDD A_DefaultMouseSpeed A_Desktop A_DesktopCommon A_DetectHiddenText A_DetectHiddenWindows A_EndChar A_EventInfo A_ExitReason A_FormatFloat A_FormatInteger A_Gui A_GuiControl A_GuiControlEvent A_GuiEvent A_GuiHeight A_GuiWidth A_GuiX A_GuiY A_Hour A_IconFile A_IconHidden A_IconNumber A_IconTip A_Index A_IPAddress1 A_IPAddress2 A_IPAddress3 A_IPAddress4 A_ISAdmin A_IsCompiled A_IsCritical A_IsPaused A_IsSuspended A_KeyDelay A_Language A_LastError A_LineFile A_LineNumber A_LoopField A_LoopFileAttrib A_LoopFileDir A_LoopFileExt A_LoopFileFullPath A_LoopFileLongPath A_LoopFileName A_LoopFileShortName A_LoopFileShortPath A_LoopFileSize A_LoopFileSizeKB A_LoopFileSizeMB A_LoopFileTimeAccessed A_LoopFileTimeCreated A_LoopFileTimeModified A_LoopReadLine A_LoopRegKey A_LoopRegName A_LoopRegSubkey A_LoopRegTimeModified A_LoopRegType A_MDAY A_Min A_MM A_MMM A_MMMM A_Mon A_MouseDelay A_MSec A_MyDocuments A_Now A_NowUTC A_NumBatchLines A_OSType A_OSVersion A_PriorHotkey A_ProgramFiles A_Programs A_ProgramsCommon A_ScreenHeight A_ScreenWidth A_ScriptDir A_ScriptFullPath A_ScriptName A_Sec A_Space A_StartMenu A_StartMenuCommon A_Startup A_StartupCommon A_StringCaseSense A_Tab A_Temp A_ThisFunc A_ThisHotkey A_ThisLabel A_ThisMenu A_ThisMenuItem A_ThisMenuItemPos A_TickCount A_TimeIdle A_TimeIdlePhysical A_TimeSincePriorHotkey A_TimeSinceThisHotkey A_TitleMatchMode A_TitleMatchModeSpeed A_UserName A_WDay A_WinDelay A_WinDir A_WorkingDir A_YDay A_Year A_YWeek A_YYYY %A_AhkVersion% %A_AppData% %A_AppDataCommon% %A_AutoTrim% %A_BatchLines% %A_CaretX% %A_CaretY% %A_ComputerName% %A_ControlDelay% %A_Cursor% %A_DD% %A_DDD% %A_DDDD% %A_DefaultMouseSpeed% %A_Desktop% %A_DesktopCommon% %A_DetectHiddenText% %A_DetectHiddenWindows% %A_EndChar% %A_EventInfo% %A_ExitReason% %A_FormatFloat% %A_FormatInteger% %A_Gui% %A_GuiControl% %A_GuiControlEvent% %A_GuiEvent% %A_GuiHeight% %A_GuiWidth% %A_GuiX% %A_GuiY% %A_Hour% %A_IconFile% %A_IconHidden% %A_IconNumber% %A_IconTip% %A_Index% %A_IPAddress1% %A_IPAddress2% %A_IPAddress3% %A_IPAddress4% %A_ISAdmin% %A_IsCompiled% %A_IsCritical% %A_IsPaused% %A_IsSuspended% %A_KeyDelay% %A_Language% %A_LastError% %A_LineFile% %A_LineNumber% %A_LoopField% %A_LoopFileAttrib% %A_LoopFileDir% %A_LoopFileExt% %A_LoopFileFullPath% %A_LoopFileLongPath% %A_LoopFileName% %A_LoopFileShortName% %A_LoopFileShortPath% %A_LoopFileSize% %A_LoopFileSizeKB% %A_LoopFileSizeMB% %A_LoopFileTimeAccessed% %A_LoopFileTimeCreated% %A_LoopFileTimeModified% %A_LoopReadLine% %A_LoopRegKey% %A_LoopRegName% %A_LoopRegSubkey% %A_LoopRegTimeModified% %A_LoopRegType% %A_MDAY% %A_Min% %A_MM% %A_MMM% %A_MMMM% %A_Mon% %A_MouseDelay% %A_MSec% %A_MyDocuments% %A_Now% %A_NowUTC% %A_NumBatchLines% %A_OSType% %A_OSVersion% %A_PriorHotkey% %A_ProgramFiles% %A_Programs% %A_ProgramsCommon% %A_ScreenHeight% %A_ScreenWidth% %A_ScriptDir% %A_ScriptFullPath% %A_ScriptName% %A_Sec% %A_Space% %A_StartMenu% %A_StartMenuCommon% %A_Startup% %A_StartupCommon% %A_StringCaseSense% %A_Tab% %A_Temp% %A_ThisFunc% %A_ThisHotkey% %A_ThisLabel% %A_ThisMenu% %A_ThisMenuItem% %A_ThisMenuItemPos% %A_TickCount% %A_TimeIdle% %A_TimeIdlePhysical% %A_TimeSincePriorHotkey% %A_TimeSinceThisHotkey% %A_TitleMatchMode% %A_TitleMatchModeSpeed% %A_UserName% %A_WDay% %A_WinDelay% %A_WinDir% %A_WorkingDir% %A_YDay% %A_Year% %A_YWeek% %A_YYYY% Abort Abs Acos Add ahk_class ahk_group ahk_id ahk_pid All Alnum Alpha Alt Altdown AltSubmit AltTab AltTabAndMenu AltTabMenu AltTabMenuDismiss Altup AlwaysOnTop And Appskey Array Asc Asin Atan Autotrim Background BackgroundTrans Backspace Between BitAnd BitNot BitOr BitShiftLeft BitShiftRight BitXOr Blind Blockinput Border Bottom break Browser_back Browser_favorites Browser_forward Browser_home Browser_refresh Browser_search Browser_stop Bs Button Buttons ByRef Cancel Capacity Capslock Caption Ceil Center Char CharP Check Check3 Checkbox Checked CheckedGray Choose ChooseString Chr Click Clipboard ClipboardAll Clipwait Close Color ComboBox Comobjactive Comobjarray Comobjconnect Comobjcreate Comobjenwrap Comobjerror Comobjflags Comobjget Comobjmissing Comobjparameter Comobjquery Comobjtype Comobjunwrap Comobjvalue ComSpec Contains Continue Control Controlclick Controlfocus Controlget Controlgetfocus Controlgetpos Controlgettext ControlList Controlmove Controlsend Controlsendraw Controlsettext Coordmode Cos Count Critical Ctrl Ctrlbreak Ctrldown Ctrlup Date DateTime Days DDL Default Del Delete DeleteAll Delimiter Deref Destroy Detecthiddentext Detecthiddenwindows Digit Disable Disabled Dllcall Double DoubleP Down Drive Driveget Drivespacefree DropDownList Edit Eject Else Enable Enabled End Endrepeat Enter Envadd Envdiv Envget Envmult Envset Envsub Envupdate Error ErrorLevel Esc Escape Exit Exitapp Exp ExStyle F1 F10 F11 F12 F13 F14 F15 F16 F17 F18 F19 F2 F20 F21 F22 F23 F24 F3 F4 F5 F6 F7 F8 F9 False Fileappend Filecopy Filecopydir Filecreatedir Filecreateshortcut Filedelete Fileencoding Fileexist Filegetattrib Filegetshortcut Filegetsize Filegettime Filegetversion Fileinstall Filemove Filemovedir Fileopen Fileread Filereadline Filerecycle Filerecycleempty Fileremovedir Fileselectfile Fileselectfolder Filesetattrib Filesettime FileSystem Flash Float FloatFast FloatP Floor Focus Font Formattime Getkeystate Global Gosub Goto Group Groupactivate Groupadd GroupBox Groupclose Groupdeactivate Gui Guicontrol Guicontrolget Hdr Hex Hidden Hide Hideautoitwin HKCC HKCR HKCU HKEY_CLASSES_ROOT HKEY_CURRENT_CONFIG HKEY_CURRENT_USER HKEY_LOCAL_MACHINE HKEY_USERS HKLM HKU Home Hotkey Hours hp HScroll Icon ID IDLast If Ifequal Ifexist Ifgreater Ifgreaterorequal Ifinstring Ifless Iflessorequal Ifmsgbox Ifnotequal Ifnotexist Ifnotinstring Ifwinactive Ifwinexist Ifwinnotactive Ifwinnotexist Ignore Il_add Il_create Il_destroy Imagesearch In Inidelete Iniread Iniwrite input Inputbox Ins Insert Instr Int Int64 Int64P Integer IntegerFast Interrupt IntP Is Isfunc Islabel Isobject Join Joy1 Joy10 Joy11 Joy12 Joy13 Joy14 Joy15 Joy16 Joy17 Joy18 Joy19 Joy2 Joy20 Joy21 Joy22 Joy23 Joy24 Joy25 Joy26 Joy27 Joy28 Joy29 Joy3 Joy30 Joy31 Joy32 Joy4 Joy5 Joy6 Joy7 Joy8 Joy9 Joyaxes Joybuttons Joyinfo Joyname Joypov Joyr Joyu Joyv Joyx Joyy Joyz Keyhistory Keywait Label Lalt LastFound Launch_app1 Launch_app2 Launch_mail Launch_media Lbutton Lcontrol Lctrl Left Limit List ListBox Listhotkeys Listlines Listvars ListView Ln local Lock Log Logoff Loop Lower Lowercase Lshift LTrim Lv_add Lv_delete Lv_deletecol Lv_getcount Lv_getnext Lv_gettext Lv_insert Lv_insertcol Lv_modify Lv_modifycol Lv_setimagelist Lwin Lwindown Lwinup MainWindow Margin Maximize MaximizeBox Mbutton Media_next Media_play_pause Media_prev Media_stop Menu Minimize MinimizeBox MinMax MinSize Minutes Mod MonthCal Mouse Mouseclick Mouseclickdrag Mousegetpos Mousemove Move Msgbox Multi NA No NoActivate NoDefault NoHide NoIcon NoMainWindow NoStandard Not NoTab NoTimers Number Numget Numlock Numpad0 Numpad1 Numpad2 Numpad3 Numpad4 Numpad5 Numpad6 Numpad7 Numpad8 Numpad9 Numpadadd Numpadclear Numpaddel Numpaddiv Numpaddot Numpaddown Numpadend Numpadenter Numpadhome Numpadins Numpadleft Numpadmult Numpadpgdn Numpadpgup Numpadright Numpadsub Numpadup Numput Objaddref Objclone Object Objgetaddress Objgetcapacity Objhaskey Objinsert Objmaxindex Objminindex Objnewenum Objrelease Objremove Objsetcapacity Off Ok On Onexit Onmessage Or Outputdebug OwnDialogs Owner Parse Password Pause Pgdn Pgup Pic Picture Pixel Pixelgetcolor Pixelsearch Pos Postmessage Pow Printscreen Priority Process ProcessName ProgramFiles Progress Radio Ralt Random Raw Rbutton Rcontrol Rctrl read ReadOnly Redraw REG_BINARY REG_DWORD REG_DWORD_BIG_ENDIAN REG_EXPAND_SZ REG_FULL_RESOURCE_DESCRIPTOR REG_LINK REG_MULTI_SZ REG_QWORD REG_RESOURCE_LIST REG_RESOURCE_REQUIREMENTS_LIST REG_SZ Regdelete Regexmatch Regexreplace Region Registercallback Regread Regwrite Relative Reload Rename Repeat Resize Restore Retry return RGB Right Round Rshift Rtrim Run Runas Runwait Rwin Rwindown Rwinup Sb_seticon Sb_setparts Sb_settext Screen Scrolllock Seconds Section Send Sendevent Sendinput Sendmessage Sendmode Sendplay Sendraw Serial Setbatchlines Setcapslockstate Setcontroldelay Setdefaultmousespeed Setenv Setformat Setkeydelay SetLabel Setmousedelay Setnumlockstate Setscrolllockstate Setstorecapslockmode Settimer Settitlematchmode Setwindelay Setworkingdir Shift ShiftAltTab Shiftdown Shiftup Short ShortP Show Shutdown Sin Single Sleep Slider Sort Soundbeep Soundget Soundgetwavevolume Soundplay Soundset Soundsetwavevolume Space Splashimage Splashtextoff Splashtexton Splitpath Sqrt Standard Static Status StatusBar Statusbargettext Statusbarwait StatusCD Str Strget Stringcasesense Stringgetpos Stringleft Stringlen Stringlower Stringmid Stringreplace Stringright Stringsplit Stringtrimleft Stringtrimright Stringupper Strlen StrP Strput Style Submit Substr Suspend Sysget SysMenu Tab Tab2 TabStop Tan text Theme Thread Time Tip ToggleCheck ToggleEnable Tooltip ToolWindow Top Topmost TransColor Transform Transparent Tray Traytip TreeView Trim True Tv_add Tv_delete Tv_get Tv_getchild Tv_getcount Tv_getnext Tv_getparent Tv_getprev Tv_getselection Tv_gettext Tv_modify Type UChar UCharP UInt UInt64 UInt64P UIntP UnCheck Unicode Unlock Up UpDown Upper Uppercase Urldownloadtofile UseErrorLevel UShort UShortP UStr UStrP Varsetcapacity Visible Volume_down Volume_mute Volume_up VScroll WaitClose WantReturn Wheeldown Wheelleft Wheelright Wheelup While Winactivate Winactivatebottom Winactive Winclose Winexist Winget Wingetactivestats Wingetactivetitle Wingetclass Wingetpos Wingettext Wingettitle Winhide Winkill Winmaximize Winmenuselectitem Winminimize Winminimizeall Winminimizeallundo Winmove Winrestore Winset Winsettitle Winshow Winwait Winwaitactive Winwaitclose Winwaitnotactive wp Wrap Xbutton1 Xbutton2 Xdigit xm xp xs Yes ym yp ys")
      if m =~ '^' . a:base
        call add(res, m)
      endif
    endfor
    return res
  endif
endfunction

let &cpo = s:save_cpo
" __END__ {{{1
