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
_AFT.testVerbResponseEquals('testPingSuccess','hello', 'ping', {}, "Some String")
_AFT.testVerbResponseEquals('testPingSuccess','hello', 'ping', {}, "Unexpected String")
_AFT.testVerbCb('testPingSuccess','hello', 'ping', {}, _callback)
_AFT.testVerbStatusError('testPingError', 'hello', 'pingfail', {})
_AFT.testVerbResponseEqualsError('testPingError', 'hello', 'pingfail', {}, "Ping Binder Daemon fails")
_AFT.testVerbResponseEqualsError('testPingError', 'hello', 'pingfail', {}, "Ping Binder Daemon succeed")
_AFT.testVerbCbError('testPingError', 'hello', 'pingfail', {}, _callbackError)

_AFT.testVerbStatusSuccess('testEventAdd', 'hello', 'eventadd', {tag = 'event', name = 'anEvent'})
_AFT.testVerbStatusSuccess('testEventSub', 'hello', 'eventsub', {tag = 'event'})
_AFT.testVerbStatusSuccess('testEventPush', 'hello', 'eventpush', {tag = 'event', data = { key = 'some data', another_key = 123}})

_AFT.testVerbStatusSuccess('testEventAdd', 'hello', 'eventadd', {tag = 'evt', name = 'anotherEvent'})
_AFT.testVerbStatusSuccess('testEventSub', 'hello', 'eventsub', {tag = 'evt'})
_AFT.testVerbStatusSuccess('testEventPush', 'hello', 'eventpush', {tag = 'evt', data = { key = 'weird others data', another_key = 123.456}})

_AFT.testVerbStatusSuccess('testGenerateWarning', 'hello', 'verbose', {level = 4, message = 'My Warning message!'})

_AFT.testVerbResponseEquals('testEventAdd', 'hello', 'eventadd', {tag = 'event', name = 'anEvent'},"Some String")
_AFT.testVerbResponseEquals('testEventSub', 'hello', 'eventsub', {tag = 'event'},"Some String")
_AFT.testVerbResponseEquals('testEventPush', 'hello', 'eventpush', {tag = 'event', data = { key = 'some data', another_key = 123}},"Some String")

_AFT.testVerbResponseEquals('testEventAdd', 'hello', 'eventadd', {tag = 'evt', name = 'anotherEvent'},"Some String")
_AFT.testVerbResponseEquals('testEventSub', 'hello', 'eventsub', {tag = 'evt'},"Some String")
_AFT.testVerbResponseEquals('testEventPush', 'hello', 'eventpush', {tag = 'evt', data = { key = 'weird others data', another_key = 123.456}},"Some String")

_AFT.testVerbResponseEquals('testEventAdd', 'hello', 'eventadd', {tag = 'event', name = 'anEvent'},"Unexpected String")
_AFT.testVerbResponseEquals('testEventSub', 'hello', 'eventsub', {tag = 'event'},"Unexpected String")
_AFT.testVerbResponseEquals('testEventPush', 'hello', 'eventpush', {tag = 'event', data = { key = 'some data', another_key = 123}},"Unexpected String")

_AFT.testVerbResponseEquals('testEventAdd', 'hello', 'eventadd', {tag = 'evt', name = 'anotherEvent'},"Unexpected String")
_AFT.testVerbResponseEquals('testEventSub', 'hello', 'eventsub', {tag = 'evt'},"Unexpected String")
_AFT.testVerbResponseEquals('testEventPush', 'hello', 'eventpush', {tag = 'evt', data = { key = 'weird others data', another_key = 123.456}},"Unexpected String")

_AFT.testVerbCb('testEventAdd', 'hello', 'eventadd', {tag = 'event', name = 'anEvent'},_callback)
_AFT.testVerbCb('testEventSub', 'hello', 'eventsub', {tag = 'event'},_callback)
_AFT.testVerbCb('testEventPush', 'hello', 'eventpush', {tag = 'event', data = { key = 'some data', another_key = 123}},_callback)

_AFT.testVerbCb('testEventAdd', 'hello', 'eventadd', {tag = 'evt', name = 'anotherEvent'},_callback)
_AFT.testVerbCb('testEventSub', 'hello', 'eventsub', {tag = 'evt'},_callback)
_AFT.testVerbCb('testEventPush', 'hello', 'eventpush', {tag = 'evt', data = { key = 'weird others data', another_key = 123.456}},_callback)

_AFT.testVerbStatusError('testEventAddError', 'hello', 'eventadd', {tag = 'event', name = 'anEvent'})
_AFT.testVerbStatusError('testEventSubError', 'hello', 'eventsub', {tag = 'event'})
_AFT.testVerbStatusError('testEventPushError', 'hello', 'eventpush', {tag = 'event', data = { key = 'some data', another_key = 123}})

_AFT.testVerbStatusError('testEventAddError', 'hello', 'eventadd', {tag = 'evt', name = 'anotherEvent'})
_AFT.testVerbStatusError('testEventSubError', 'hello', 'eventsub', {tag = 'evt'})
_AFT.testVerbStatusError('testEventPushError', 'hello', 'eventpush', {tag = 'evt', data = { key = 'weird others data', another_key = 123.456}})

_AFT.testVerbResponseEqualsError('testEventAddError', 'hello', 'eventadd', {tag = 'event', name = 'anEvent'},"Ping Binder Daemon fails")
_AFT.testVerbResponseEqualsError('testEventSubError', 'hello', 'eventsub', {tag = 'event'},"Ping Binder Daemon fails")
_AFT.testVerbResponseEqualsError('testEventPushError', 'hello', 'eventpush', {tag = 'event', data = { key = 'some data', another_key = 123}},"Ping Binder Daemon fails")

_AFT.testVerbResponseEqualsError('testEventAddError', 'hello', 'eventadd', {tag = 'evt', name = 'anotherEvent'},"Ping Binder Daemon fails")
_AFT.testVerbResponseEqualsError('testEventSubError', 'hello', 'eventsub', {tag = 'evt'},"Ping Binder Daemon fails")
_AFT.testVerbResponseEqualsError('testEventPushError', 'hello', 'eventpush', {tag = 'evt', data = { key = 'weird others data', another_key = 123.456}},"Ping Binder Daemon fails")

_AFT.testVerbResponseEqualsError('testEventAddError', 'hello', 'eventadd', {tag = 'event', name = 'anEvent'},"Ping Binder Daemon succeed")
_AFT.testVerbResponseEqualsError('testEventSubError', 'hello', 'eventsub', {tag = 'event'},"Ping Binder Daemon succeed")
_AFT.testVerbResponseEqualsError('testEventPushError', 'hello', 'eventpush', {tag = 'event', data = { key = 'some data', another_key = 123}},"Ping Binder Daemon succeed")

_AFT.testVerbResponseEqualsError('testEventAddError', 'hello', 'eventadd', {tag = 'evt', name = 'anotherEvent'},"Ping Binder Daemon succeed")
_AFT.testVerbResponseEqualsError('testEventSubError', 'hello', 'eventsub', {tag = 'evt'},"Ping Binder Daemon succeed")
_AFT.testVerbResponseEqualsError('testEventPushError', 'hello', 'eventpush', {tag = 'evt', data = { key = 'weird others data', another_key = 123.456}},"Ping Binder Daemon succeed")

_AFT.testVerbCb('testEventAddError', 'hello', 'eventadd', {tag = 'event', name = 'anEvent'},_callbackError)
_AFT.testVerbCb('testEventSubError', 'hello', 'eventsub', {tag = 'event'},_callbackError)
_AFT.testVerbCb('testEventPushError', 'hello', 'eventpush', {tag = 'event', data = { key = 'some data', another_key = 123}},_callbackError)

_AFT.testVerbCb('testEventAddError', 'hello', 'eventadd', {tag = 'evt', name = 'anotherEvent'},_callbackError)
_AFT.testVerbCb('testEventSubError', 'hello', 'eventsub', {tag = 'evt'},_callbackError)
_AFT.testVerbCb('testEventPushError', 'hello', 'eventpush', {tag = 'evt', data = { key = 'weird others data', another_key = 123.456}},_callbackError)

_AFT.testEvtReceived("testEvent", "hello/anEvent")
_AFT.testEvtReceived("testEventCb", "hello/anotherEvent")

_AFT.testLogReceived("LogReceived", "verbose called for My Warning message!")

_AFT.testCustom("mytest", function()
  _AFT.assertEquals(false, false)
end)
