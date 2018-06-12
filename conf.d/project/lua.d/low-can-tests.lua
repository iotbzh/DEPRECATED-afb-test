
--[[
    Copyright (C) 2018 "IoT.bzh"
    Author Romain Forlot <romain.forlot@iot.bzh>

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

-- BOUNDARY WIP

package.path = package.path .. ';./var/?.lua'
local lu = require('luaunit')
local src = nil
local arg = nil

-- Static variables should be prefixed with _
_EventHandle = {}

local engine_off_evt_received   = false
local engine_speed_evt_received = false

local clock = os.clock
function sleep(n)  -- seconds
  local t0 = clock()
  while clock() - t0 <= n do end
end

function _evt_catcher_ (source, action, event)
    local match = string.find(event.data.message, "is_engine_on: engine.speed CAN signal found, but engine seems off")
    if match ~= nil then
        engine_off_evt_received = true
    end

    match = string.find(event.data.message, "diagnostic_messages.engine.speed")
    if match ~= nil then
        engine_speed_evt_received = true
    end
end

function _start_afb_logging()
    AFB:servsync(src, "monitor","set", { verbosity = "debug" })
    AFB:servsync(src, "monitor","trace", { add = { api = "low-can", daemon = "vverbose" }})
end

function _stop_afb_logging()
    AFB:servsync(src, "monitor","trace", { drop = true})
end

Test_Engine = {}
    function Test_Engine:test_detection_is_off()
        local responseJ = {}

        _start_afb_logging()

        local err,responseJ = AFB:servsync(src, "low-can","subscribe", { event = "diagnostic_messages.engine.speed" })

        lu.assertStrMatches(responseJ.request.status, "success", nil, nil, "Correctly subscribed to engine.speed signal")

        _stop_afb_logging()

        lu.assertTrue(engine_off_evt_received, "Expected message did not comes up from binder log")
    end

    function Test_Engine:Test_turning_on()
        _start_afb_logging()

        local ret = os.execute("./var/replay_launcher.sh ./var/test1.canreplay")
        lu.assertTrue(ret)
        --sleep(60)
        lu.assertTrue(engine_speed_evt_received, "Engine still off")

        _stop_afb_logging()
    end


function _launch_test (source, args)
    src = source
    arg = args

    os.exit(lu.LuaUnit.run()) -- run the tests!
end
