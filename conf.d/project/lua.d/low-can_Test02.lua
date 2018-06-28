 --[[
    Copyright (C) 2018 "IoT.bzh"
    Author Clément Malléjac <clementmallejac@gmail.com>

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


-- This tests if a log is printed when a binding subscribes to a signal while the engine is off
_AFT.testCustom("Test_02/Step_2", function()
  local logMsg = "signal: Engine is off, diagnostic_messages.engine.speed won't received responses until it's on"
  _AFT.addLogToMonitor("low-can", "warning", logMsg)

  _AFT.assertVerbStatusSuccess("low-can","subscribe", { event = "diagnostic_messages.engine.speed" })
  _AFT.assertLogReceived(logMsg)
end)


-- This tests if events are sent to the subscribed bindings
_AFT.testCustom("Test_02/Step_3", function()
  local evt = "low-can/diagnostic_messages"
  _AFT.addEventToMonitor(evt)

  local ret = os.execute("./var/replay_launcher.sh ./var/test2-1.canreplay")
  _AFT.assertIsTrue(ret)

  _AFT.assertEvtReceived(evt, function(eventName, data)
      _AFT.assertIsTrue(data.name == "diagnostic_messages.engine.speed")
  end)
end)

-- This asserts that a log message is not sent when a binding subscribes to a signal when the engine is on
_AFT.testCustom("Test_02/Step_4", function()
  local logMsg = "signal: Engine is off, diagnostic_messages.engine.speed won't received responses until it's on"
  _AFT.addLogToMonitor("low-can", "warning", logMsg)

  _AFT.assertVerbStatusSuccess("low-can","subscribe", { event = "diagnostic_messages.engine.speed" })
  _AFT.assertLogNotReceived(logMsg)
end)

-- This kills the canplayer
_AFT.testCustom("Test_02/Step_5", function()
  local ret = os.execute("pkill canplayer")
  _AFT.assertIsTrue(ret)
end)

-- This tests that the events are still sent with different values
_AFT.testCustom("Test_02/Step_6", function()

  local evt = "low-can/diagnostic_messages"
  _AFT.addEventToMonitor(evt)

  local logMsg = "0"
  _AFT.addLogToMonitor("low-can","warning", logMsg)

  local ret = os.execute("./var/replay_launcher.sh ./var/test2-2.canreplay")
  _AFT.assertIsTrue(ret)

  _AFT.assertEvtReceived(evt, function(eventName, data)
      _AFT.assertIsTrue(data.name == "diagnostic_messages.engine.speed")
  end)

  _AFT.assertLogReceived(logMsg)
end)

-- This checks that the events are sent even after the engine has been turned off after being turned on at least once.
_AFT.testCustom("Test_02/Step_7", function()
  local logMsg = "signal: Engine is off, diagnostic_messages.engine.speed won't received responses until it's on"
  _AFT.addLogToMonitor("low-can", "warning", logMsg)

  _AFT.assertVerbStatusSuccess("low-can","subscribe", { event = "diagnostic_messages.engine.speed" })
  _AFT.assertLogNotReceived(logMsg)
end)
