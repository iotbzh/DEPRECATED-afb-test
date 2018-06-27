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

_AFT.testEvtReceived("testEvent", "hello/anEvent")
_AFT.testEvtReceived("testEventCb", "hello/anotherEvent")

_AFT.testLogReceived("LogReceived", "verbose called for My Warning message!")

local corout = coroutine.create( print )

_AFT.testCustom("luaUnitAssertionsTest", function()
  _AFT.assertEquals(false, false)
  _AFT.assertNotEquals(true,false)
	_AFT.assertItemsEquals({1,2,3},{3,1,2})
	_AFT.assertAlmostEquals(1.25 ,1.5,0.5)
	_AFT.assertNotAlmostEquals(1.25,1.5,0.125)
	_AFT.assertEvalToTrue(true)
  _AFT.assertEvalToFalse(false)
  
  _AFT.assertStrContains("Hello I'm a string","string")
  _AFT.assertStrContains("Hello I'm a second string","second",5)

  _AFT.assertStrIContains("Hello I'm another string","I'm")
  
  _AFT.assertNotStrContains("Hello it's me again, the other string","banana")
  _AFT.assertNotStrContains("Hello it's me again, the other string","banana",8)

  _AFT.assertNotStrIContains("Hello it's not me this time !","trebuchet")
  
  _AFT.assertStrMatches("Automotive Grade Linux","Automotive Grade Linux")
  _AFT.assertStrMatches("Automotive Grade Linux from IoT.bzh","Automotive Grade Linux",1,22)
  _AFT.assertError(_AFT.assertEquals(true,true))

  _AFT.assertErrorMsgEquals("attempt to call a nil value",
                              _AFT.assertStrMatches("test assertErrorMsgEquals","test",1,4))
	_AFT.assertErrorMsgContains("attempt to call",
                              _AFT.assertStrMatches("test assertErrorMsgEquals","test",1,4))
	_AFT.assertErrorMsgMatches('attempt to call a nil value',
                              _AFT.assertStrMatches("test assertErrorMsgEquals","test",1,4))

	_AFT.assertIs('toto','to'..'to')
  _AFT.assertNotIs({1,2},{1,2})

  _AFT.assertIsNumber(23)
	_AFT.assertIsString("Lapin bihan")
	_AFT.assertIsTable({1,2,3,4})
	_AFT.assertIsBoolean(true)
	_AFT.assertIsNil(nil)
	_AFT.assertIsTrue(true)
	_AFT.assertIsFalse(false)
	_AFT.assertIsNaN(0/0)
	_AFT.assertIsInf(1/0)
	_AFT.assertIsPlusInf(1/0)
	_AFT.assertIsMinusInf(-1/0)
	_AFT.assertIsPlusZero(1/(1/0))
	_AFT.assertIsMinusZero(-1/(1/0))
	_AFT.assertIsFunction(print)
	_AFT.assertIsThread(corout)
  _AFT.assertIsUserdata(_AFT.context)

  _AFT.assertNotIsNumber('a')
	_AFT.assertNotIsString(2)
	_AFT.assertNotIsTable(2)
	_AFT.assertNotIsBoolean(2)
	_AFT.assertNotIsNil(2)
	_AFT.assertNotIsTrue(false)
	_AFT.assertNotIsFalse(true)
	_AFT.assertNotIsNaN(1)
	_AFT.assertNotIsInf(2)
	_AFT.assertNotIsPlusInf(2)
	_AFT.assertNotIsMinusInf(2)
	_AFT.assertNotIsPlusZero(2)
	_AFT.assertNotIsMinusZero(2)
	_AFT.assertNotIsFunction(2)
	_AFT.assertNotIsThread(2)
	_AFT.assertNotIsUserdata(2)
end)

--_AFT.resetEventReceivedCount()
--_AFT.resetLogReceivedCount()
print("################################################################s")
_AFT.assertVerbStatusSuccess("hello","eventadd",{tag='event2', name='verbEventAddTest'})
--[[_AFT.assertVerbResponseEquals("hello","eventunsub",{tag="event"},"yolo")
_AFT.assertVerbCb()
_AFT.assertVerbStatusError()
_AFT.assertVerbResponseEqualsError()
_AFT.assertVerbCbError()
_AFT.assertLogReceived()
_AFT.assertLogNotReceived()
--]]