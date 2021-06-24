Attribute VB_Name = "modDisableKeys"
Option Explicit

Public Declare Sub CopyMemory Lib "kernel32" Alias "RtlMoveMemory" (Destination As Any, Source As Any, ByVal Length As Long)
Public Declare Function GetKeyState Lib "user32" (ByVal nVirtKey As Long) As Integer
Public Declare Function SetWindowsHookEx Lib "user32" Alias "SetWindowsHookExA" (ByVal idHook As Long, ByVal lpfn As Long, ByVal hmod As Long, ByVal dwThreadId As Long) As Long
Public Declare Function CallNextHookEx Lib "user32" (ByVal hHook As Long, ByVal nCode As Long, ByVal wParam As Long, lParam As Any) As Long
Public Declare Function UnhookWindowsHookEx Lib "user32" (ByVal hHook As Long) As Long

Public Const HC_ACTION = 0
Public Const WM_KEYDOWN = &H100
Public Const WM_KEYUP = &H101
Public Const WM_SYSKEYDOWN = &H104
Public Const WM_SYSKEYUP = &H105
Public Const WH_KEYBOARD_LL = 13

Public Type KBDLLHOOKSTRUCT
    vkCode As Long
    scanCode As Long
    flags As Long
    time As Long
    dwExtraInfo As Long
End Type

Public Enum VirtualKey
  VK_LBUTTON = &H1
  VK_RBUTTON = &H2
  VK_CTRLBREAK = &H3
  VK_MBUTTON = &H4
  VK_BACKSPACE = &H8
  VK_TAB = &H9
  VK_ENTER = &HD
  VK_SHIFT = &H10
  VK_CONTROL = &H11
  VK_ALT = &H12
  VK_PAUSE = &H13
  VK_CAPSLOCK = &H14
  VK_ESCAPE = &H1B
  VK_SPACE = &H20
  VK_PAGEUP = &H21
  VK_PAGEDOWN = &H22
  VK_END = &H23
  VK_HOME = &H24
  VK_LEFT = &H25
  VK_UP = &H26
  VK_RIGHT = &H27
  VK_DOWN = &H28
  VK_PRINTSCREEN = &H2C
  VK_INSERT = &H2D
  VK_DELETE = &H2E
  VK_0 = &H30
  VK_1 = &H31
  VK_2 = &H32
  VK_3 = &H33
  VK_4 = &H34
  VK_5 = &H35
  VK_6 = &H36
  VK_7 = &H37
  VK_8 = &H38
  VK_9 = &H39
  VK_A = &H41
  VK_B = &H42
  VK_C = &H43
  VK_D = &H44
  VK_E = &H45
  VK_F = &H46
  VK_G = &H47
  VK_H = &H48
  VK_I = &H49
  VK_J = &H4A
  VK_K = &H4B
  VK_L = &H4C
  VK_M = &H4D
  vk_n = &H4E
  VK_O = &H4F
  VK_P = &H50
  VK_Q = &H51
  VK_R = &H52
  VK_S = &H53
  VK_T = &H54
  VK_U = &H55
  VK_V = &H56
  VK_W = &H57
  VK_X = &H58
  VK_Y = &H59
  VK_Z = &H5A
  VK_LWINDOWS = &H5B
  VK_RWINDOWS = &H5C
  VK_APPSPOPUP = &H5D
  VK_NUMPAD_0 = &H60
  VK_NUMPAD_1 = &H61
  VK_NUMPAD_2 = &H62
  VK_NUMPAD_3 = &H63
  VK_NUMPAD_4 = &H64
  VK_NUMPAD_5 = &H65
  VK_NUMPAD_6 = &H66
  VK_NUMPAD_7 = &H67
  VK_NUMPAD_8 = &H68
  VK_NUMPAD_9 = &H69
  VK_NUMPAD_MULTIPLY = &H6A
  VK_NUMPAD_ADD = &H6B
  VK_NUMPAD_PLUS = &H6B
  VK_NUMPAD_SUBTRACT = &H6D
  VK_NUMPAD_MINUS = &H6D
  VK_NUMPAD_MOINS = &H6D
  VK_NUMPAD_DECIMAL = &H6E
  VK_NUMPAD_POINT = &H6E
  VK_NUMPAD_DIVIDE = &H6F
  VK_F1 = &H70
  VK_F2 = &H71
  VK_F3 = &H72
  VK_F4 = &H73
  VK_F5 = &H74
  VK_F6 = &H75
  VK_F7 = &H76
  VK_F8 = &H77
  VK_F9 = &H78
  VK_F10 = &H79
  VK_F11 = &H7A
  VK_F12 = &H7B
  VK_NUMLOCK = &H90
  VK_SCROLL = &H91
  VK_LSHIFT = &HA0
  VK_RSHIFT = &HA1
  VK_LCONTROL = &HA2
  VK_RCONTROL = &HA3
  VK_LALT = &HA4
  VK_RALT = &HA5
  VK_POINTVIRGULE = &HBA
  VK_ADD = &HBB
  VK_PLUS = &HBB
  VK_EQUAL = &HBB
  VK_VIRGULE = &HBC
  VK_SUBTRACT = &HBD
  VK_MINUS = &HBD
  VK_MOINS = &HBD
  VK_UNDERLINE = &HBD
  VK_POINT = &HBE
  VK_SLASH = &HBF
  VK_TILDE = &HC0
  VK_LEFTBRACKET = &HDB
  VK_BACKSLASH = &HDC
  VK_RIGHTBRACKET = &HDD
  VK_QUOTE = &HDE
  VK_APOSTROPHE = &HDE
End Enum

Dim p As KBDLLHOOKSTRUCT

'Public Function LowLevelKeyboardProc(ByVal nCode As Long, ByVal wParam As Long, ByVal lParam As Long) As Long
'  Dim fEatKeystroke As Boolean
'  If (nCode = HC_ACTION) Then
'    If wParam = WM_KEYDOWN Or wParam = WM_SYSKEYDOWN Or wParam = WM_KEYUP Or wParam = WM_SYSKEYUP Then
'      CopyMemory p, ByVal lParam, Len(p)
'      fEatKeystroke = _
'        (p.vkCode = VK_CAPSLOCK) Or _
'        (p.vkCode = VK_LWINDOWS) Or _
'        (p.vkCode = VK_RWINDOWS) Or _
'        (p.vkCode = VK_APPSPOPUP) Or _
'        ((p.vkCode = VK_SPACE) And ((GetKeyState(VK_ALT) And &H8000) <> 0)) Or _
'        ((p.vkCode = VK_TAB) And ((GetKeyState(VK_ALT) And &H8000) <> 0)) Or _
'        ((p.vkCode = VK_ESCAPE) And ((GetKeyState(VK_CONTROL) And &H8000) <> 0))
'    End If
'  End If
'  If fEatKeystroke Then
'    LowLevelKeyboardProc = -1
'  Else
'    LowLevelKeyboardProc = CallNextHookEx(0, nCode, wParam, ByVal lParam)
'  End If
'End Function

Public Function LowLevelKeyboardProc(ByVal nCode As Long, ByVal wParam As Long, ByVal lParam As Long) As Long
  Dim fEatKeystroke As Boolean
  If (nCode = HC_ACTION) Then
    If wParam = WM_KEYDOWN Or wParam = WM_SYSKEYDOWN Or wParam = WM_KEYUP Or wParam = WM_SYSKEYUP Then
      CopyMemory p, ByVal lParam, Len(p)
      fEatKeystroke = _
        (p.vkCode = VK_LWINDOWS) Or _
        (p.vkCode = VK_RWINDOWS)
    End If
  End If
  If fEatKeystroke Then
    LowLevelKeyboardProc = -1
  Else
    LowLevelKeyboardProc = CallNextHookEx(0, nCode, wParam, ByVal lParam)
  End If
End Function
