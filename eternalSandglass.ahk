#SingleInstance, off
#NoTrayIcon
timeStep=1000
Menu, esgmenu, Add, (&1) Load `Left `Time, Load1
Menu, esgmenu, Add,	(&2) Load `Center `Time, Load2
Menu, esgmenu, Add,	(&3) Load `Right `Time, Load3
Menu, esgmenu, Add,	(&4) Load Current `Time, Load4
Menu, esgmenu, Add,	
Menu, esgmenu, Add, &Milliseconds, MSD
Menu, esgmenu, Add,	&User Defined Command, UDC
Menu, esgmenu, Add, &`Caption, CAP
Menu, esgmenu, Add, &Reset, RESET
etenalSandglass:
Gui,+AlwaysOnTop
Gui, font, bold ,Verdana
Gui, Add,GroupBox,xm ym w225 h80 vState,---------&Eternal Sandglass--------
Gui, font, s25
Gui, Add, Edit,number xm+10 ym+18 w55 h50 vHH, 00
Gui, Add, Edit,number x+20 ym+18 w55 h50  vMM, 02
Gui, Add, Edit,number x+20 ym+18 w55 h50  vSS, 00  
Gui, font, s9
Gui, Add, Text, xm+10 y+15 w55 h15 cFF4500 vSaved1 gSave1, 000000
Gui, Add, Text, x+20  w55 h15 c1E90FF vSaved2 gSave2, 000000
Gui, Add, Text, x+20  w55 h15 c228B22 vSaved3 gSave3, 000000
Gui, Add, Slider, xm y+10 w225 h20 TickInterval1  Range1-3 vMode gEnable,2
Gui, Show, ,eternal sandglass
return

Save1:
GuiControlGet, Hget,,HH
GuiControlGet, Mget,,MM
GuiControlGet, Sget,,SS
GuiControl,,Saved1,%Hget%%Mget%%Sget%
return

Save2:
GuiControlGet, Hget,,HH
GuiControlGet, Mget,,MM
GuiControlGet, Sget,,SS
GuiControl,,Saved2,%Hget%%Mget%%Sget%
return

Save3:
GuiControlGet, Hget,,HH
GuiControlGet, Mget,,MM
GuiControlGet, Sget,,SS
GuiControl,,Saved3,%Hget%%Mget%%Sget%
return

Enable:
GuiControlGet, Hget,,HH
GuiControlGet, Mget,,MM
GuiControlGet, Sget,,SS
if(Mode=1)
{
	GuiControl,,State,&countdown
	gosub, conutdown
}
if(Mode=2)
{
	GuiControl,,State,&alarm
	gosub, alarm
}
if(Mode=3)
{
	GuiControl,,State,&stopwatch
	gosub, stopwatch
}
return


conutdown:
SetTimer, AddTic,Off
SetTimer, CheckTic, Off
SetTimer, OneTic,%timeStep%
return

alarm:
SetTimer, AddTic,Off
SetTimer, OneTic,Off
SetTimer, CheckTic,100
return

stopwatch:
SetTimer, OneTic,Off
SetTimer, CheckTic, Off
SetTimer, AddTic,%timeStep%
return

OneTic:
GuiControlGet, Hget,,HH
GuiControlGet, Mget,,MM
GuiControlGet, Sget,,SS
if(Hget=0)&&(Mget=0)&&(Sget=0){	
	SetTimer, OneTic, Off
	GuiControl,,State,&countdown `pause
	MsgBox, 4132, caution!, your time is up`nDo command ?,60
	IfMsgBox, Yes 
		gosub, Ucommand
	IfMsgBox, Timeout
		gosub, Ucommand
	else
		return
}
if(Hget>0)&&(Mget=0)&&(Sget=0){
	Hget--
	GuiControl,,SS,59
	GuiControl,,MM,59
	GuiControl,,HH,%Hget%
}
; sec control flip
if(Sget=00)&&(Mget>0){
	Sget=59
	GuiControl,,SS,%Sget%
	Mget--
	if(Mget>=10){
		GuiControl,,MM,%Mget%
	}
	if(Mget<10){
		GuiControl,,MM,0%Mget%
	}
	; min control flip
	if(Mget=00)&&(Hget>0){
		Mget=59
		GuiControl,,MM,%Mget%
		Hget--
		if(Hget>=10){
			GuiControl,,HH,%Hget%
		}
		if(Hget<10){
			GuiControl,,HH,0%Hget%
		}
		; Hour don't control flip
		if(Hget=00){
			GuiControl,,HH,00
		}
		
	}
}
if(Sget>0){
	Sget--
	if(Sget>10){
		GuiControl,,SS,%Sget%
	}
	if(Sget<=10){
		GuiControl,,SS,0%Sget%
	}	
}
return

CheckTic:
GuiControlGet, Hget,,HH
GuiControlGet, Mget,,MM
GuiControlGet, Sget,,SS
if(Hget=A_Hour)&&(Mget=A_Min)&&(Sget=A_Sec)
{
	SetTimer, CheckTic,off
	GuiControl,,State,&alarm `pause
	MsgBox, 4132, caution!, your time is up`nDo command ?,60
	IfMsgBox, Yes 
		gosub, Ucommand
	IfMsgBox, Timeout
		gosub, Ucommand
}
else
	SetTimer, CheckTic,On
return

AddTic:
GuiControlGet, Hget,,HH
GuiControlGet, Mget,,MM
GuiControlGet, Sget,,SS
Sget++
if(Sget<10)
	GuiControl,,SS,0%Sget%
if(Sget>=10)
	GuiControl,,SS,%Sget%
if(Sget=60)
{
	Sget=00
	GuiControl,,SS,00
	Mget++
	if(Mget<10)
		GuiControl,,MM,0%Mget%
	if(Mget>=10)
		GuiControl,,MM,%Mget%
	if(Mget=60)
	{
		Mget=00
		GuiControl,,MM,00
		Hget++
		if(Hget<10)
			GuiControl,,HH,0%Hget%
		if(Hget>=10)
			GuiControl,,HH,%Hget%
	}
}
if(Hget=A_Hour)&&(Mget=A_Min)&&(Sget=A_Sec)
	GuiControl,,State,&Real Time
else
	GuiControl,,State,&stopwatch
return

GuiContextMenu:
;~ Menu, esgmenu, Add, (&1) Load `Left `Time, Load1
;~ Menu, esgmenu, Add,	(&2) Load `Center `Time, Load2
;~ Menu, esgmenu, Add,	(&3) Load `Right `Time, Load3
;~ Menu, esgmenu, Add,	(&4) Load Current `Time, Load4
;~ Menu, esgmenu, Add,	
;~ Menu, esgmenu, Add,	Toggle &Milliseconds, MSD
;~ Menu, esgmenu, Add,	User Defined Command, UDC
;~ Menu, esgmenu, Add,	Toggle &`Caption, CAP
;~ Menu, esgmenu, Add, Reset, RESET
Menu, esgmenu, UnCheck, &Milliseconds
Menu, esgmenu, Show
return

Load1:
GuiControlGet, Saved1,,Saved1
StringSplit, OutLoad, Saved1
GuiControl,,HH,%OutLoad1%%OutLoad2%
GuiControl,,MM,%OutLoad3%%OutLoad4%
GuiControl,,SS,%OutLoad5%%OutLoad6%
return

Load2:
GuiControlGet, Saved2,,Saved2
StringSplit, OutLoad, Saved2
GuiControl,,HH,%OutLoad1%%OutLoad2%
GuiControl,,MM,%OutLoad3%%OutLoad4%
GuiControl,,SS,%OutLoad5%%OutLoad6%
return

Load3:
GuiControlGet, Saved3,,Saved3
StringSplit, OutLoad, Saved3
GuiControl,,HH,%OutLoad1%%OutLoad2%
GuiControl,,MM,%OutLoad3%%OutLoad4%
GuiControl,,SS,%OutLoad5%%OutLoad6%
return

Load4:
GuiControl,,HH,%A_Hour%
GuiControl,,MM,%A_Min%
GuiControl,,SS,%A_Sec%
return

MSD:
if(revMSD=1)
{
	timeStep=1000
	Gui, font, bold s25,Verdana
	GuiControl, Font, SS  
	revMSD=0
	gosub, Enable
}
else
{
	timeStep=10
	Gui, font, norm s25,Verdana
	GuiControl, Font, SS	
	revMSD=1
	gosub, Enable
}
return


CAP:
if(revCAP=1)
{
	WinSet, Style, +0xC00000, A
	revCAP=0
}
else
{
	WinSet, Style, -0xC00000, A
	revCAP=1
}
return

UDC:
Run, eternalSandglass.txt,,UserErrorLevel
return

RESET:
Reload
return

GuiClose:
ExitApp

Ucommand:
IfExist, eternalSandglass.txt
{
	Loop	
	{
		FileReadLine, line, eternalSandglass.txt, %A_Index%
		if ErrorLevel
			break
		Run, %line%,,UseErrorLevel
	}
	return
}
return

#IfWinActive, eternal sandglass
space::
GuiControlGet, CurrentState,,State
if(CurrentState="&alarm pause")or(CurrentState="&countdown pause")or(CurrentState="---------&Eternal Sandglass--------")or(CurrentState="&STOP")
{
	GuiControlGet,Mode,,Mode
	gosub, Enable	
}
;~ if(LiveOrDie=1)
else
{
	SetTimer, OneTic,Off
	SetTimer, CheckTic, Off
	SetTimer, AddTic, Off
	GuiControl,,State, &STOP
}
return
#IfWinActive