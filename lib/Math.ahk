Global ScriptStart := A_TickCount

Wait(min, max) {
    Random, wait, min, max
    Sleep, wait
}

Random(n){
	Random, out, 0, n
	return % out
}

Count(min, max){
	Random, out, min, max
	return % out
}

AddBias(center, min, max) {
    bias := 5
    Random, offset, -bias, bias
    if (offset > 0) {
        return center + offset > max ? max : center + offset
    } else {
        return center + offset < min ? min : center + offset
    }
}

Distance(x1, y1, x2, y2) {
    return Sqrt((x2 - x1) ** 2 + (y2 - y1) ** 2)
}

CheckMouseCoordinates(x, y) {
    MouseGetPos, mouseX, mouseY
    if (mouseX = x && mouseY = y) 
        return true
    return false
}

TimerMath(T, Fmt:="{:02}h {:02}m {:02}s") { 
    Local H, M, Q:=60, R:=3600
    Return Format(Fmt, H:=T//R, M:=(T:=T-H*R)//Q, T-M*Q)
}

Timer() {
    CT := A_TickCount - ScriptStart 
    E := Floor(CT / 1000)
    Time := TimerMath(E)
    ToolTip, Running Time : %Time%
    ;add 1000 timer
}

BoxDraw(x=0, y=0, w=0, h=0, c="white", t=1) {
    x += w < 0 ? w : 0, w := Abs(w)
    y += h < 0 ? h : 0, h := Abs(h)
    Gui, New, +E0x20 +E0x08000000 -Caption +AlwaysOnTop Hwndhwnd
    Gui, Color, %c%
    Gui, Show, x%x% y%y% w%w% h%h% NA
    WinSet, Transparent, 255
    WinSet, Region, % "0-0 " w "-0 " w "-" h " 0-" h " 0-0 " t "-" t " " w-t "-" t " " w-t "-" h-t " " t "-" h-t " " t "-" t, ahk_id %hwnd%
}
