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


local corout = coroutine.create( print )

_AFT.testCustom("testAssertEquals", function() _AFT.assertEquals(false, false) end)
_AFT.testCustom("testAssertNotEquals", function()  _AFT.assertNotEquals(true,false) end)
_AFT.testCustom("testAssertItemsEquals", function()	_AFT.assertItemsEquals({1,2,3},{3,1,2}) end)
_AFT.testCustom("testAssertAlmostEquals", function()	_AFT.assertAlmostEquals(1.25 ,1.5,0.5) end)
_AFT.testCustom("testAssertNotAlmostEquals", function()	_AFT.assertNotAlmostEquals(1.25,1.5,0.125) end)
_AFT.testCustom("testAssertEvalToTrue", function()	_AFT.assertEvalToTrue(true) end)
_AFT.testCustom("testAssertEvalToFalse", function()  _AFT.assertEvalToFalse(false) end)

_AFT.testCustom("testAssertStrContains", function()  _AFT.assertStrContains("Hello I'm a string","string") end)
_AFT.testCustom("testAssertStrContains", function()  _AFT.assertStrContains("Hello I'm a second string","second",5) end)

_AFT.testCustom("testAssertStrIContains", function()  _AFT.assertStrIContains("Hello I'm another string","I'm") end)

_AFT.testCustom("testAssertNotStrContains", function()  _AFT.assertNotStrContains("Hello it's me again, the other string","banana") end)
_AFT.testCustom("testAssertNotStrContains", function()  _AFT.assertNotStrContains("Hello it's me again, the other string","banana",8) end)

_AFT.testCustom("testAssertNotStrIContains", function()  _AFT.assertNotStrIContains("Hello it's not me this time !","trebuchet") end)

_AFT.testCustom("testAssertStrMatches", function()  _AFT.assertStrMatches("Automotive Grade Linux","Automotive Grade Linux") end)
_AFT.testCustom("testAssertStrMatches", function()  _AFT.assertStrMatches("Automotive Grade Linux from IoT.bzh","Automotive Grade Linux",1,22) end)
_AFT.testCustom("testAssertError", function()  _AFT.assertError(_AFT.assertEquals(true,true)) end)

_AFT.testCustom("testAssertErrorMsgEquals", function()  _AFT.assertErrorMsgEquals("attempt to call a nil value",
																									                              _AFT.assertStrMatches("test assertErrorMsgEquals","test",1,4)) end)
_AFT.testCustom("testAssertErrorMsgContains", function()	_AFT.assertErrorMsgContains("attempt to call",
																									                              _AFT.assertStrMatches("test assertErrorMsgEquals","test",1,4)) end)
_AFT.testCustom("testAssertErrorMsgMatches", function()	_AFT.assertErrorMsgMatches('attempt to call a nil value',
																								                              _AFT.assertStrMatches("test assertErrorMsgEquals","test",1,4)) end)

_AFT.testCustom("testAssertIs", function()	_AFT.assertIs('toto','to'..'to') end)
_AFT.testCustom("testAssertNotIs", function()  _AFT.assertNotIs({1,2},{1,2}) end)

_AFT.testCustom("testAssertIsNumber", function()  _AFT.assertIsNumber(23) end)
_AFT.testCustom("testAssertIsString", function()	_AFT.assertIsString("Lapin bihan") end)
_AFT.testCustom("testAssertIsTable", function()	_AFT.assertIsTable({1,2,3,4}) end)
_AFT.testCustom("testAssertIsBoolean", function()	_AFT.assertIsBoolean(true) end)
_AFT.testCustom("testAssertIsNil", function()	_AFT.assertIsNil(nil) end)
_AFT.testCustom("testAssertIsTrue", function()	_AFT.assertIsTrue(true) end)
_AFT.testCustom("testAssertIsFalse", function()	_AFT.assertIsFalse(false) end)
_AFT.testCustom("testAssertIsNaN", function()	_AFT.assertIsNaN(0/0) end)
_AFT.testCustom("testAssertIsInf", function()	_AFT.assertIsInf(1/0) end)
_AFT.testCustom("testAssertIsPlusInf", function()	_AFT.assertIsPlusInf(1/0) end)
_AFT.testCustom("testAssertIsMinusInf", function()	_AFT.assertIsMinusInf(-1/0) end)
_AFT.testCustom("testAssertIsPlusZero", function()	_AFT.assertIsPlusZero(1/(1/0)) end)
_AFT.testCustom("testAssertIsMinusZero", function()	_AFT.assertIsMinusZero(-1/(1/0)) end)
_AFT.testCustom("testAssertIsFunction", function()	_AFT.assertIsFunction(print) end)
_AFT.testCustom("testAssertIsThread", function()	_AFT.assertIsThread(corout) end)
_AFT.testCustom("testAssertIsUserdata", function()  _AFT.assertIsUserdata(_AFT.context) end)

_AFT.testCustom("testAssertNotIsNumber", function()  _AFT.assertNotIsNumber('a') end)
_AFT.testCustom("testAssertNotIsString", function()	_AFT.assertNotIsString(2) end)
_AFT.testCustom("testAssertNotIsTable", function()	_AFT.assertNotIsTable(2) end)
_AFT.testCustom("testAssertNotIsBoolean", function()	_AFT.assertNotIsBoolean(2) end)
_AFT.testCustom("testAssertNotIsNil", function()	_AFT.assertNotIsNil(2) end)
_AFT.testCustom("testAssertNotIsTrue", function()	_AFT.assertNotIsTrue(false) end)
_AFT.testCustom("testAssertNotIsFalse", function()	_AFT.assertNotIsFalse(true) end)
_AFT.testCustom("testAssertNotIsNaN", function()	_AFT.assertNotIsNaN(1) end)
_AFT.testCustom("testAssertNotIsInf", function()	_AFT.assertNotIsInf(2) end)
_AFT.testCustom("testAssertNotIsPlusInf", function()	_AFT.assertNotIsPlusInf(2) end)
_AFT.testCustom("testAssertNotIsMinusInf", function()	_AFT.assertNotIsMinusInf(2) end)
_AFT.testCustom("testAssertNotIsPlusZero", function()	_AFT.assertNotIsPlusZero(2) end)
_AFT.testCustom("testAssertNotIsMinusZero", function()	_AFT.assertNotIsMinusZero(2) end)
_AFT.testCustom("testAssertNotIsFunction", function()	_AFT.assertNotIsFunction(2) end)
_AFT.testCustom("testAssertNotIsThread", function()	_AFT.assertNotIsThread(2) end)
_AFT.testCustom("testAssertNotIsUserdata", function()	_AFT.assertNotIsUserdata(2) end)


function _callback(responseJ) _AFT.assertStrContains(responseJ.response, "Some String") end
function _callbackError(responseJ) _AFT.assertStrContains(responseJ.request.info, "Ping Binder Daemon fails") end

_AFT.testCustom("testAssertVerbStatusSuccess",function() _AFT.assertVerbStatusSuccess('hello', 'ping', {}) end)
_AFT.testCustom("testAssertVerbResponseEquals",function() _AFT.assertVerbResponseEquals('hello', 'ping', {},"Some String") end)
_AFT.testCustom("testAssertVerbCb",function() _AFT.assertVerbCb('hello', 'ping', {},_callback) end)
_AFT.testCustom("testAssertVerbStatusError",function() _AFT.assertVerbStatusError('hello', 'pingfail', {}) end)
_AFT.testCustom("testAssertVerbResponseEqualsError",function() _AFT.assertVerbResponseEqualsError('hello', 'pingfail', {},"Ping Binder Daemon fails") end)
_AFT.testCustom("testAssertVerbCbError",function() _AFT.assertVerbCbError('hello', 'pingfail', {},_callbackError) end)
