--- Maintains a stack of escapehandlers
--
-- Running HandleEscape() will run the topmost escapehandler,
-- and default to the user mapped action for escape if there is
-- no current escapehandler.
EscapeHandler = Class() {
    __init = function(self)
        self._handlers = {}
    end,

    --- Push a new escape handler onto the stack. This becomes the current escape handler, ahead of the
    -- old one.
    --
    -- @param handler
    --
    -- @see PopEscapeHandler
    PushEscapeHandler = function(self, handler)
        if handler ~= nil then
            table.insert(self._handlers, handler)
        end
    end,

    --- Remove the current escape handler and restore the previous one pushed.
    PopEscapeHandler = function(self)
        if table.getn(self._handlers) < 1 then
            LOG("Error popping escape handler, stack is empty")
            LOG(repr(debug.traceback()))
            return
        end
        table.remove(self._handlers)
    end,

    HandleEscape = function(self)
        LOG("EscapeHandler:HandleEscape()")
        local eschandler = self._handlers[table.getn(self._handlers)]
        if eschandler then
            eschandler()
        else
            ConExecute(import('/lua/keymap/keyactions.lua').keyActions['escape'].action)
        end
    end,
}

--- Global representing the current escape handler
--
CurrentEscapeHandler = EscapeHandler()

function InitEscapeHandler()
    CurrentEscapeHandler = EscapeHandler()
end
