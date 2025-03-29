#Include, <Main>

Global Overloading 
Global Absorbing
Global RapidHealing

Global AbsorbTimer := 60
Global OverloadTimer := 5

Global ShouldOverload := true

Global LowerHP1st := 4
Global LowerHP2nd := 10

ToolTip, Press Home to start, 960, 540
return

Home::
ToolTip,
Sleep, 250
PreStart()
return

SipOverload:
    if (!Overloading) {
        Overloading := true
        Critical, On
        if (A_TickCount - NextFlick >= 35000) {
            PrayFlick()
            Wait(250, 550)
        }
        Overload()
        Wait(300, 1000)
        Overloading := false
        Critical, Off
    } else {
        GoTo, SipOverload
    }
return

SipAbsorb:
    if (!Absorbing) {
        Absorbing := true
        Critical, On
        if (A_TickCount - NextFlick >= 30000) {
            PrayFlick()
            Wait(250, 550)
        }
        Absorb()
        Wait(300, 1000)
        if (A_TickCount - NextFlick >= 30000)
            PrayFlick()
        Absorbing := false
        Critical, Off
    } else {
        GoTo, SipAbsorb
    }
return

RapidHeal:
    if (!RapidHealing) {
        RapidHealing := true
        Critical, On
        PrayFlick()
        RapidHealing := false
        Critical, Off
    }
return

EndSession:
    ExitApp
return

PreStart() {
    Interface.OpenTab("Inventory")
    Sleep, 1000
    LowerHP(LowerHP1st)
    Overload()
    Absorb()
    LowerHP(LowerHP2nd)
    PrayFlick()
}

Overload() {
    if (!ShouldOverload)
        return
    Interface.OpenTab("Inventory")
    if (Inventory.HasColor(Blue)) {
        Inventory.ClickColor(Blue)
        ReOvl := (OverloadTimer * 60000) + Count(1000, 3000)
        SetTimer, Overload, % ReOvl
    } else {
        SetTimer, SipOverload, Off
        LowerHP(5)
        if (!Inventory.HasColor(Red))
            SetTimer, EndSession, 1380000
    }
}

Absorb() {
    Interface.OpenTab("Inventory")
    if (Inventory.HasColor(Red)) {
        Loop % Count(4, 5) {
            Inventory.ClickMultipleColorSlots(5, Red)
        }
        ReAbsorb := (AbsorbTimer * 60000) + Count(1000, 3000)
        SetTimer, SipAbsorb, % ReAbsorb
        if (!Inventory.HasColor(Red)) {
            SetTimer, SipAbsorb, Off
            SetTimer, EndSession, 1380000
        }
    } else {
        SetTimer, SipAbsorb, Off
        if (!Inventory.HasColor(Blue))
            SetTimer, EndSession, 1380000
    }
}

LowerHP(amount) {
    if (amount < 1)
        return
    Interface.OpenTab("Inventory")
    if (Inventory.HasColor(Green)) {
        Inventory.ClickColor(Green)
        Loop, % (amount - 1) {
            Sleep, 750
            Click
        }
    }
}

PrayFlick() {
    Prayer.Flick()
    Global NextFlick := A_TickCount
    SetTimer, RapidHeal, % Count(36000, 51000)
}

End::exitapp