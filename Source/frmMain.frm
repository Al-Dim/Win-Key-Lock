VERSION 5.00
Begin VB.Form frmMain 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "WinKey No More :)"
   ClientHeight    =   990
   ClientLeft      =   1950
   ClientTop       =   1530
   ClientWidth     =   3480
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   ScaleHeight     =   990
   ScaleWidth      =   3480
   StartUpPosition =   2  'CenterScreen
   WindowState     =   1  'Minimized
End
Attribute VB_Name = "frmMain"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
Dim hhkLowLevelKybd As Long
Private Sub Form_Load()
  hhkLowLevelKybd = SetWindowsHookEx(WH_KEYBOARD_LL, AddressOf LowLevelKeyboardProc, App.hInstance, 0)
End Sub
Private Sub Form_Unload(Cancel As Integer)
  If hhkLowLevelKybd <> 0 Then UnhookWindowsHookEx hhkLowLevelKybd
End Sub
