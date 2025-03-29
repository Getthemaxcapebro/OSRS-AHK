class EquipmentTab {
    __New(x="1302", y="596", width="147", height="193"
          , cellWidth="35", cellHeight="35"
          , rowPadding="4.5", col2Padding="6", widePadding="21") {
        this.x := x
        this.y := y
        this.width := width
        this.height := height
        this.cellWidth := cellWidth
        this.cellHeight := cellHeight
        this.rowPadding := rowPadding
        this.col2Padding := col2Padding
        this.widePadding := widePadding
        
        this.CreateEquipmentTab()
    }

    CreateEquipmentTab() {
        offsetX := 13
        ; Row 1: Head
        this["Cell_1"] := {x: this.x + this.cellWidth + this.col2Padding + offsetX, y: this.y, width: this.cellWidth, height: this.cellHeight}

        ; Row 2: Cape, Neck, Ammo
        row2Y := this.y + this.cellHeight + this.rowPadding
        this["Cell_2"] := {x: this.x + offsetX, y: row2Y, width: this.cellWidth, height: this.cellHeight} ; Cape
        this["Cell_3"] := {x: this.x + this.cellWidth + this.col2Padding + offsetX, y: row2Y, width: this.cellWidth, height: this.cellHeight} ; Neck
        this["Cell_4"] := {x: this.x + 2 * this.cellWidth + 2 * this.col2Padding + offsetX, y: row2Y, width: this.cellWidth, height: this.cellHeight} ; Ammo

        ; Row 3: Weapon, Chest, Shield
        row3Y := row2Y + this.cellHeight + this.rowPadding
        this["Cell_5"] := {x: this.x, y: row3Y, width: this.cellWidth, height: this.cellHeight} ; Weapon
        this["Cell_6"] := {x: this.x + this.cellWidth + this.widePadding, y: row3Y, width: this.cellWidth, height: this.cellHeight} ; Chest
        this["Cell_7"] := {x: this.x + 2 * this.cellWidth + 2 * this.widePadding, y: row3Y, width: this.cellWidth, height: this.cellHeight} ; Shield

        ; Row 4: Legs
        row4Y := row3Y + this.cellHeight + this.rowPadding
        this["Cell_8"] := {x: this.x + this.cellWidth + this.col2Padding + offsetX, y: row4Y, width: this.cellWidth, height: this.cellHeight} ; Legs

        ; Row 5: Hands, Feet, Ring
        row5Y := row4Y + this.cellHeight + this.rowPadding
        this["Cell_9"] := {x: this.x, y: row5Y, width: this.cellWidth, height: this.cellHeight} ; Hands
        this["Cell_10"] := {x: this.x + this.cellWidth + this.widePadding, y: row5Y, width: this.cellWidth, height: this.cellHeight} ; Feet
        this["Cell_11"] := {x: this.x + 2 * this.cellWidth + 2 * this.widePadding, y: row5Y, width: this.cellWidth, height: this.cellHeight} ; Ring

        Loop, 11 {
            slot := this["Cell_" A_Index]
            centerX := slot.x + this.cellWidth // 2
            centerY := slot.y + this.cellHeight // 2
            if (globalDebug) {
                BoxDraw(slot.x, slot.y, this.cellWidth, this.cellHeight, "White")
                BoxDraw(centerX - 2, centerY - 2, 4, 4, "White")
            }
        }
        if (globalDebug) {
            BoxDraw(this.x, this.y, this.width, this.height, "White")
        }
    }
    
    GetSlotCoordinates(slot) {
        if (slot < 1 || slot > 11 || !this["Cell_" slot])
            return false
        
        slotData := this["Cell_" slot]
        return {x: slotData.x, y: slotData.y, width: slotData.width, height: slotData.height}
    }

    GetClickCoordinates(slot) {
        if (slot < 1 || slot > 11 || !this["Cell_" slot])
            return false
        
        clickRange := this["Cell_" slot]
        x := AddBias(clickRange.x + clickRange.width // 2, clickRange.x, clickRange.x + clickRange.width)
        y := AddBias(clickRange.y + clickRange.height // 2, clickRange.y, clickRange.y + clickRange.height)
        return {x: x, y: y}
    }

    ClickSlot(slot) {
        coords := this.GetClickCoordinates(slot)
        if (coords)
            MoveAndClick(coords.x, coords.y)
    }

    ClickMultipleSlots(slots*) {
        Loop, % slots.MaxIndex() {
            slot := slots[A_Index]
            if (slot > 0 && slot <= 11) {
                this.ClickSlot(slot)
                Wait(0, 10)
            }
        }
    }

    HasColor(color) {
        Loop, 11 {
            slot := this.GetSlotCoordinates(A_Index)
            if (slot) {
                x1 := slot.x + 2
                y1 := slot.y + 2
                x2 := slot.x + slot.width - 2
                y2 := slot.y + slot.height - 2
                PixelSearch, foundX, foundY, x1, y1, x2, y2, color, 0, Fast RGB
                if (!ErrorLevel) {
                    return true
                }
            }
        }
        return false
    }

    ClickColor(color) {
        Loop, 11 {
            currentSlot := A_Index
            slot := this.GetSlotCoordinates(currentSlot)
            if (slot) {
                x1 := slot.x + 2
                y1 := slot.y + 2
                x2 := slot.x + slot.width - 2
                y2 := slot.y + slot.height - 2
                PixelSearch, foundX, foundY, x1, y1, x2, y2, color, 0, Fast RGB
                if (!ErrorLevel) {
                    this.ClickSlot(currentSlot)
                    return true
                }
            }
        }
    }

    ClickMultipleColorSlots(numSlots, color) {
        clickedSlots := []
        count := 0
        Loop, 11 {
            slotNumber := A_Index
            if (!this.ArrayContains(clickedSlots, slotNumber)) {
                slot := this.GetSlotCoordinates(slotNumber)
                x1 := slot.x + 2
                y1 := slot.y + 2
                x2 := slot.x + slot.width - 2
                y2 := slot.y + slot.height - 2
                PixelSearch, foundX, foundY, x1, y1, x2, y2, color, 0, Fast RGB
                if (!ErrorLevel) {
                    this.ClickSlot(slotNumber)
                    clickedSlots.Push(slotNumber)
                    count++
                    if (count >= numSlots)
                        return
                }
            }
        }
    }

    ArrayContains(arr, value) {
        Loop, % arr.MaxIndex() {
            if (arr[A_Index] = value)
                return true
        }
        return false
    }
}

class Inventory {
    Pattern1 := [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28]
    Pattern2 := [1, 2, 3, 4, 8, 7, 6, 5, 9, 10, 11, 12, 16, 15, 14, 13, 17, 18, 19, 20, 24, 23, 22, 21, 25, 26, 27, 28]
    Pattern3 := [1, 5, 2, 6, 3, 7, 4, 8, 9, 13, 10, 14, 11, 15, 12, 16, 17, 21, 18, 22, 19, 23, 20, 24, 25, 26, 27, 28]
    Pattern4 := [1, 5, 2, 6, 3, 7, 4, 8, 9, 13, 10, 14, 11, 15, 12, 16, 17, 21, 18, 22, 19, 23, 20, 24, 28, 27, 26, 25]
    Pattern5 := [1, 5, 9, 13, 17, 21, 25, 2, 6, 10, 14, 18, 22, 26, 3, 7, 11, 15, 19, 23, 27, 4, 8, 12, 16, 20, 24, 28]
    Pattern6 := [1, 5, 9, 13, 17, 21, 25, 26, 22, 18, 14, 10, 6, 2, 3, 7, 11, 15, 19, 23, 27, 28, 24, 20, 16, 12, 8, 4]
    Pattern7 := [1, 2, 4, 3, 5, 6, 8, 7, 9, 10, 12, 11, 13, 14, 16, 15, 17, 18, 20, 19, 21, 22, 24, 23, 25, 26, 28, 27]
    Pattern8 := [28, 27, 26, 25, 24, 23, 22, 21, 20, 19, 18, 17, 16, 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1]
    Pattern9 := [1, 6, 2, 11, 7, 3, 16, 12, 8, 4, 21, 17, 13, 9, 26, 22, 18, 14, 5, 27, 23, 19, 15, 10, 28, 24, 20, 25]
    Pattern10 := [1, 2, 3, 4, 8, 12, 16, 20, 24, 28, 27, 26, 25, 21, 17, 13, 9, 5, 6, 7, 11, 15, 19, 23, 22, 18, 14, 10]

    __New(x="1296", y="600", width="163", height="249"
          , rowCount="7", colCount="4", cellWidth="37", cellHeight="33"
          , horizontalPadding="5.25", verticalPadding="3") {

        this.x := x
        this.y := y
        this.width := width
        this.height := height
        this.rowCount := rowCount
        this.colCount := colCount
        this.cellWidth := cellWidth
        this.cellHeight := cellHeight
        this.horizontalPadding := horizontalPadding
        this.verticalPadding := verticalPadding
        this.patterns := []
        
        Loop, 6 {
            this.patterns[A_Index] := this["Pattern" A_Index]
        }

        this.CreateInventory()
    }

    CreateInventory() {
        Loop, % this.rowCount {
            row := A_Index
            y := this.y + (this.cellHeight * (row - 1)) + (row - 1) * this.verticalPadding
            Loop, % this.colCount {
                col := A_Index
                x := this.x + (this.cellWidth * (col - 1)) + (col - 1) * this.horizontalPadding
                cellNumber := (row - 1) * this.colCount + col
                
                this["Cell_" cellNumber] := {x: x, y: y, width: this.cellWidth, height: this.cellHeight}
                
                centerX := x + this.cellWidth // 2
                centerY := y + this.cellHeight // 2
                
                if (globalDebug) {
                    BoxDraw(x, y, this.cellWidth, this.cellHeight, "White")
                    BoxDraw(centerX - 2, centerY - 2, 4, 4, "White")
                }
            }
        }
        if (globalDebug) {
            BoxDraw(this.x, this.y, this.width, this.height, "White")
        }
    }
    
    GetSlotCoordinates(slot) {
        if (slot < 1 || slot > 28 || !this["Cell_" slot])
            return false
        
        slotData := this["Cell_" slot]
        return {x: slotData.x, y: slotData.y, width: slotData.width, height: slotData.height}
    }

    GetClickCoordinates(slot) {
        if (slot < 1 || slot > 28 || !this["Cell_" slot])
            return false
        
        clickRange := this["Cell_" slot]
        x := AddBias(clickRange.x + clickRange.width // 2, clickRange.x, clickRange.x + clickRange.width)
        y := AddBias(clickRange.y + clickRange.height // 2, clickRange.y, clickRange.y + clickRange.height)
        return {x: x, y: y}
    }

    ClickSlot(slot) {
        coords := this.GetClickCoordinates(slot)
        if (coords)
            MoveAndClick(coords.x, coords.y)
    }

    ClickMultipleSlots(slots*) {
        Loop, % slots.MaxIndex() {
            slot := slots[A_Index]
            if (slot > 0 && slot <= 28) {
                this.ClickSlot(slot)
                Wait(0, 10)
            }
        }
    }

    HasColor(color) {
        Loop, 28 {
            slot := this.GetSlotCoordinates(A_Index)
            if (slot) {
                x1 := slot.x + 2
                y1 := slot.y + 2
                x2 := slot.x + slot.width - 2
                y2 := slot.y + slot.height - 2
                PixelSearch, foundX, foundY, x1, y1, x2, y2, color, 0, Fast RGB
                if (!ErrorLevel) {
                    return true
                }
            }
        }
        return false
    }

    ClickColor(color) {
        Loop, 28 {
            currentSlot := A_Index
            slot := this.GetSlotCoordinates(currentSlot)
            if (slot) {
                x1 := slot.x + 2
                y1 := slot.y + 2
                x2 := slot.x + slot.width - 2
                y2 := slot.y + slot.height - 2
                PixelSearch, foundX, foundY, x1, y1, x2, y2, color, 0, Fast RGB
                if (!ErrorLevel) {
                    this.ClickSlot(currentSlot)
                    return true
                }
            }
        }
    }

    ClickMultipleColorSlots(numSlots, color) {
        clickedSlots := []
        count := 0
        Loop, 28 {
            slotNumber := A_Index
            if (!this.ArrayContains(clickedSlots, slotNumber)) {
                slot := this.GetSlotCoordinates(slotNumber)
                x1 := slot.x + 2
                y1 := slot.y + 2
                x2 := slot.x + slot.width - 2
                y2 := slot.y + slot.height - 2
                PixelSearch, foundX, foundY, x1, y1, x2, y2, color, 0, Fast RGB
                if (!ErrorLevel) {
                    this.ClickSlot(slotNumber)
                    clickedSlots.Push(slotNumber)
                    count++
                    if (count >= numSlots)
                        return
                }
            }
        }
    }

    DropInventory(excludeSlots*) {
        Random, patternIdx, 1, % this.patterns.MaxIndex()
        pattern := this.patterns[patternIdx]
        skippedSlots := []

        Loop, % pattern.MaxIndex() {
            slot := pattern[A_Index]
            if (this.ArrayContains(excludeSlots, slot))
                continue
                
            Random, chance, 0, 100
            if (chance <= 2.5) {
                skippedSlots.Insert(slot)
            } else {
                this.ClickSlot(slot)
                Wait(0, 10)
            }
        }

        Wait(125, 750)

        Loop, % skippedSlots.MaxIndex() {
            slot := skippedSlots[skippedSlots.MaxIndex() - A_Index + 1]
            if (!this.ArrayContains(excludeSlots, slot)) {
                this.ClickSlot(slot)
                Wait(0, 10)
            }
        }
    }

    HoverSlot(slot) {
        coords := this.GetClickCoordinates(slot)
        if (coords)
            MoveMouse(coords.x, coords.y)
    }

    ArrayContains(arr, value) {
        Loop, % arr.MaxIndex() {
            if (arr[A_Index] = value)
                return true
        }
        return false
    }
}

class PrayerBook {
    __New(x="1288", y="604", width="175", height="215"
          , rowCount="6", colCount="5", cellWidth="30", cellHeight="30"
          , horizontalPadding="6.25", verticalPadding="7") {
        this.x := x
        this.y := y
        this.width := width
        this.height := height
        this.rowCount := rowCount
        this.colCount := colCount
        this.cellWidth := cellWidth
        this.cellHeight := cellHeight
        this.horizontalPadding := horizontalPadding
        this.verticalPadding := verticalPadding
        this.Orb := {x: 1318, y: 219, width: 16, height: 16}
        
        this.CreatePrayerBook()
    }

    CreatePrayerBook() {
        Loop, % this.rowCount {
            row := A_Index
            y := this.y + (this.cellHeight * (row - 1)) + (row - 1) * this.verticalPadding
            Loop, % this.colCount {
                col := A_Index
                x := this.x + (this.cellWidth * (col - 1)) + (col - 1) * this.horizontalPadding
                cellNumber := (row - 1) * this.colCount + col
                
                this["Cell_" cellNumber] := {x: x, y: y, width: this.cellWidth, height: this.cellHeight}
                
                centerX := x + this.cellWidth // 2
                centerY := y + this.cellHeight // 2
                
                if (globalDebug) {
                    BoxDraw(x, y, this.cellWidth, this.cellHeight, "White")
                    BoxDraw(centerX - 2, centerY - 2, 4, 4, "White")
                }
            }
        }
        if (globalDebug) {
            BoxDraw(this.x, this.y, this.width, this.height, "White")
            
            ; Orb
            BoxDraw(this.Orb.x, this.Orb.y, this.Orb.width, this.Orb.height, "White")
            centerX := this.Orb.x + this.Orb.width // 2
            centerY := this.Orb.y + this.Orb.height // 2
            BoxDraw(centerX - 2, centerY - 2, 4, 4, "White")
        }
    }
    
    GetSlotCoordinates(slot) {
        if (slot < 1 || slot > 30 || !this["Cell_" slot])
            return false
        
        slotData := this["Cell_" slot]
        return {x: slotData.x, y: slotData.y, width: slotData.width, height: slotData.height}
    }

    GetClickCoordinates(slot) {
        if (slot < 1 || slot > 30 || !this["Cell_" slot])
            return false
        
        clickRange := this["Cell_" slot]
        x := AddBias(clickRange.x + clickRange.width // 2, clickRange.x, clickRange.x + clickRange.width)
        y := AddBias(clickRange.y + clickRange.height // 2, clickRange.y, clickRange.y + clickRange.height)
        return {x: x, y: y}
    }

    ClickSlot(slot) {
        coords := this.GetClickCoordinates(slot)
        if (coords)
            MoveAndClick(coords.x, coords.y)
    }

    ClickMultipleSlots(slots*) {
        Loop, % slots.MaxIndex() {
            slot := slots[A_Index]
            if (slot > 0 && slot <= 30) {
                this.ClickSlot(slot)
                Wait(0, 10)
            }
        }
    }
    
    GetOrbCoordinates() {
        return {x: this.Orb.x, y: this.Orb.y, width: this.Orb.width, height: this.Orb.height}
    }
    
    GetOrbClickCoordinates() {
        x := AddBias(this.Orb.x + this.Orb.width // 2, this.Orb.x, this.Orb.x + this.Orb.width)
        y := AddBias(this.Orb.y + this.Orb.height // 2, this.Orb.y, this.Orb.y + this.Orb.height)
        return {x: x, y: y}
    }
    
    ClickOrb() {
        coords := this.GetOrbClickCoordinates()
        if (coords)
            MoveAndClick(coords.x, coords.y)
    }

    Flick() {
        coords := this.GetOrbClickCoordinates()
        if (coords) {
            MoveMouse(coords.x, coords.y)
            Wait(75, 105)
            DoubleClick()
        }
    }
}

class Tabs {
    TopTabs := ["Combat", "Stats", "Quests", "Inventory", "Equipment", "Prayer", "Magic"]
    BottomTabs := ["Clan", "Friends", "Ignore", "Logout", "Settings", "Emotes", "Music"]
    
    HotkeyMap := { "Inventory": "{F1}"
                 , "Equipment": "F2"
                 , "Prayer": "F3"
                 , "Magic": "F4"
                 , "Combat": "F5"
                 , "Clan": "F7"
                 , "Friends": "F8"
                 , "Settings": "F10"
                 , "Emotes": "F11"
                 , "Music": "F12" }

    __New(tabWidth="20", tabHeight="25") {
        this.tabWidth := tabWidth
        this.tabHeight := tabHeight
        this.CreateInterface()
    }

    CreateInterface() {
        topTabX := 1266
        topTabY := 561
        Loop, 7 {
            tabIndex := A_Index
            tabName := this.TopTabs[tabIndex]
            tabXPos := topTabX + (this.tabWidth * (tabIndex - 1)) + ((tabIndex - 1) * 13)
            this["Tab_" tabName] := {x: tabXPos, y: topTabY, width: this.tabWidth, height: this.tabHeight}
            if (globalDebug) {
                BoxDraw(tabXPos, topTabY, this.tabWidth, this.tabHeight, "White")
            }
        }

        bottomTabX := 1262
        bottomTabY := 857
        Loop, 7 {
            tabIndex := A_Index
            tabName := this.BottomTabs[tabIndex]
            tabXPos := bottomTabX + (this.tabWidth * (tabIndex - 1)) + ((tabIndex - 1) * 14.25)
            this["Tab_" tabName] := {x: tabXPos, y: bottomTabY, width: this.tabWidth, height: this.tabHeight}
            if (globalDebug) {
                BoxDraw(tabXPos, bottomTabY, this.tabWidth, this.tabHeight, "White")
            }
        }
    }
    
    OpenTab(tabName) {
        if (!this["Tab_" tabName])
            return false
        if (tabName = "Inventory" && InventoryOpen)
            return true
        else if (tabName = "Equipment" && EquipmentOpen)
            return true
        else if (tabName = "Prayer" && PrayerOpen)
            return true
        else if (tabName = "Magic" && MagicOpen)
            return true
        else if (tabName = "Combat" && CombatOpen)
            return true
        else if (tabName = "Clan" && ClanOpen)
            return true
        else if (tabName = "Friends" && FriendsOpen)
            return true
        else if (tabName = "Settings" && SettingsOpen)
            return true
        else if (tabName = "Emotes" && EmotesOpen)
            return true
        else if (tabName = "Music" && MusicOpen)
            return true
        Random, useHotkey, 1, 100
        if (useHotkey <= 60 && this.HotkeyMap[tabName]) {
            hotkey := this.HotkeyMap[tabName]
            Send % hotkey
        } else {
            this.ClickTab(tabName)
        }
        SetActiveTab(tabName)
    }

    GetTabCoordinates(tabName) {
        if (!this["Tab_" tabName])
            return false
        
        tabData := this["Tab_" tabName]
        return {x: tabData.x, y: tabData.y, width: tabData.width, height: tabData.height}
    }

    GetClickCoordinates(tabName) {
        if (!this["Tab_" tabName])
            return false
        
        clickRange := this["Tab_" tabName]
        x := AddBias(clickRange.x + clickRange.width // 2, clickRange.x, clickRange.x + clickRange.width)
        y := AddBias(clickRange.y + clickRange.height // 2, clickRange.y, clickRange.y + clickRange.height)
        return {x: x, y: y}
    }

    ClickTab(tabName) {
        coords := this.GetClickCoordinates(tabName)
        if (coords) {
            MoveAndClick(coords.x, coords.y)
            SetActiveTab(tabName)
        }
    }

    ClickMultipleTabs(tabs*) {
        Loop, % tabs.MaxIndex() {
            tab := tabs[A_Index]
            if (this["Tab_" tab]) {
                this.OpenTab(tab)
                Wait(0, 10)
            }
        }
    }
}

global InventoryOpen := false
global EquipmentOpen := false
global PrayerOpen := false
global MagicOpen := false
global CombatOpen := false
global ClanOpen := false
global FriendsOpen := false
global SettingsOpen := false
global EmotesOpen := false
global MusicOpen := false

SetActiveTab(tabName) {
    InventoryOpen := false
    EquipmentOpen := false
    PrayerOpen := false
    MagicOpen := false
    CombatOpen := false
    ClanOpen := false
    FriendsOpen := false
    SettingsOpen := false
    EmotesOpen := false
    MusicOpen := false
    
    if (tabName = "Inventory")
        InventoryOpen := true
    else if (tabName = "Equipment")
        EquipmentOpen := true
    else if (tabName = "Prayer")
        PrayerOpen := true
    else if (tabName = "Magic")
        MagicOpen := true
    else if (tabName = "Combat")
        CombatOpen := true
    else if (tabName = "Clan")
        ClanOpen := true
    else if (tabName = "Friends")
        FriendsOpen := true
    else if (tabName = "Settings")
        SettingsOpen := true
    else if (tabName = "Emotes")
        EmotesOpen := true
    else if (tabName = "Music")
        MusicOpen := true
}
