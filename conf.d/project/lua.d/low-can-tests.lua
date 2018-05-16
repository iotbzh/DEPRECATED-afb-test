
--[[
    Copyright (C) 2016 "IoT.bzh"
    Author Fulup Ar Foll <fulup@iot.bzh>

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

      http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.


    NOTE: strict mode: every global variables should be prefixed by '_'
--]]
EXPORT_ASSERT_TO_GLOBALS = true
require('luaunit')
--module( "low-can-testcase", lunit.testcase, package.seeall )

-- Static variables should be prefixed with _
_EventHandle = {}

_engine_on_msg_received = false

local clock = os.clock
function sleep(n)  -- seconds
  local t0 = clock()
  while clock() - t0 <= n do end
end

function _evt_catcher_ (source, action, event)
    local match = string.find(event.data.message, "is_engine_on: engine.speed CAN signal found, but engine seems off")
    if match ~= nil then
        _engine_on_msg_received = true
    end
end

-- Display receive arguments and echo them to caller
function _launch_tests (source, args)
    local responseJ = {}

    AFB:servsync(source, "monitor","set", { verbosity = "debug" })
    AFB:servsync(source, "monitor","trace", { add = { api = "low-can", daemon = "vverbose" }})

    local err,responseJ = AFB:servsync(source, "low-can","subscribe", { event = "diagnostic_messages.engine.speed" })

    assertStrMatches(responseJ.request.status, "success", nil, nil, "Correctly subscribed to engine.speed signal")

    AFB:servsync(source, "monitor","trace", { drop = true})

    assertTrue(_engine_on_msg_received, "Ok, got the message indicating that engine is Off")

    return 0 -- happy end
end
