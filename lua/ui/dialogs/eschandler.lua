--*****************************************************************************
--* File: lua/modules/ui/dialogs/eschandler.lua
--* Author: Chris Blackwell
--* Summary: Determines appropriate actions to take when the escape key is pressed in game
--*
--* Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
--*****************************************************************************

local UIUtil = import('/lua/ui/uiutil.lua')
local Prefs = import('/lua/user/prefs.lua')
local Utils = import('/lua/system/utils.lua')

local quickDialog = false

--- Terminate the game in a vaguely graceful fashion. This may or may not reduce the amount of times
-- sudden quits lead to players having to wait for a timeout.
function SafeQuit()
    if SessionIsActive() and not SessionIsReplay() then
        ForkThread(function ()
            ConExecute('ren_oblivion true')
            ConExecute('ren_ui false')
            SessionEndGame()
            WaitSeconds(1)
            ExitApplication()
        end)
    else
        ExitApplication()
    end
end

local _dialog

function CreateDialog()
    if _dialog then
        return
    end

    if Prefs.GetOption('quick_exit') == 'true' then
        SafeQuit()
    else
        GetCursor():Show()
        _dialog = UIUtil.QuickDialog(GetFrame(0),
            "<LOC EXITDLG_0000>Are you sure you'd like to quit?",
            "<LOC _Yes>", function() SafeQuit() end,
            "<LOC _No>", function() _dialog:Destroy() _dialog = false end,
            nil,
            nil,
            true,
            {escapeButton = 2, enterButton = 1, worldCover = true})
    end
end
