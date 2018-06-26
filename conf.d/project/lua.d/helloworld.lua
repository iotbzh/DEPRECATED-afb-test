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

function _callback(responseJ)
  _AFT.assertStrContains(responseJ.response, "Some String")
end

function _callbackError(responseJ)
  _AFT.assertStrContains(responseJ.request.info, "Ping Binder Daemon fails")
end

function _callbackEvent(eventName, eventData)
  _AFT.assertEquals(eventData, {data = { key = 'weird others data', another_key = 123.456 }})
end

_AFT.addEventToMonitor("hello/anEvent")
_AFT.addEventToMonitor("hello/anotherEvent", _callbackEvent)
_AFT.addLogToMonitor("hello", "warning", "verbose called for My Warning message!")

_AFT.testVerbStatusSuccess('testPingSuccess','hello', 'ping', {})
_AFT.testVerbResponseEquals('testPingSuccessAndResponse','hello', 'ping', {}, "Some String")
_AFT.testVerbResponseEquals('testPingSuccessResponseFail','hello', 'ping', {}, "Unexpected String")
_AFT.testVerbCb('testPingSuccessCallback','hello', 'ping', {}, _callback)

_AFT.testVerbStatusError('testPingError', 'hello', 'pingfail', {})
_AFT.testVerbResponseEqualsError('testPingErrorAndResponse', 'hello', 'pingfail', {}, "Ping Binder Daemon fails")
_AFT.testVerbResponseEqualsError('testPingErrorResponseFail', 'hello', 'pingfail', {}, "Ping Binder Daemon succeed")
_AFT.testVerbCbError('testPingErrorCallback', 'hello', 'pingfail', {}, _callbackError)

_AFT.testVerbStatusSuccess('testEventAddanEvent', 'hello', 'eventadd', {tag = 'event', name = 'anEvent'})
_AFT.testVerbStatusSuccess('testEventSubanEvent', 'hello', 'eventsub', {tag = 'event'})
_AFT.testVerbStatusSuccess('testEventPushanEvent', 'hello', 'eventpush', {tag = 'event', data = { key = 'some data', another_key = 123}})

_AFT.testVerbStatusSuccess('testEventAddanotherEvent', 'hello', 'eventadd', {tag = 'evt', name = 'anotherEvent'})
_AFT.testVerbStatusSuccess('testEventSubanotherEvent', 'hello', 'eventsub', {tag = 'evt'})
_AFT.testVerbStatusSuccess('testEventPushanotherEvent', 'hello', 'eventpush', {tag = 'evt', data = { key = 'weird others data', another_key = 123.456}})

_AFT.testVerbStatusSuccess('testGenerateWarning', 'hello', 'verbose', {level = 4, message = 'My Warning message!'})

_AFT.testEvtReceived("testanEventReceived", "hello/anEvent")
_AFT.testEvtReceived("testanotherEventReceived", "hello/anotherEvent")

_AFT.testLogReceived("LogReceived", "verbose called for My Warning message!")

_AFT.testCustom("mytest", function()
  _AFT.assertEquals(false, false)
end)
