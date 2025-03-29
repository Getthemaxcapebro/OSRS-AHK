#NoEnv
#Persistent
SetWorkingDir %A_ScriptDir%
SendMode Input
SetBatchLines -1
SetWinDelay -1
SetKeyDelay -1
SetMouseDelay -1
SetControlDelay -1
Process, Priority,, High
CoordMode, Mouse, Screen
CoordMode, Pixel, Screen
CoordMode, ToolTip, Screen
#SingleInstance force
#MaxHotkeysPerInterval 99000000
#HotkeyInterval 99000000
DetectHiddenWindows On
WinActivate, RuneLite
WinMove, RuneLite, ,  428, 102, 1080, 800

#Include, Math.ahk
#Include, WindHumanMouse.ahk
#Include, Interface.ahk

global globalDebug := true

Global Red := 0xFF0000
Global Blue := 0x0000FF
Global Green := 0x00FF00
Global Pink := 0xFF00FF
Global Cyan := 0x00FFFF
Global Black := 0x000000
Global Yellow := 0xFFFF00

;global Equipment := new EquipmentTab()
;global Inventory := new Inventory()
;global Prayer := new PrayerBook()
global Interface := new Tabs()




