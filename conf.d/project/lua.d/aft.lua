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

package.path = package.path .. ';./var/?.lua'
local lu = require('luaunit')
lu.LuaUnit:setOutputType('JUNIT')
lu.LuaUnit.fname = "var/jUnitResults.xml"

_AFT = {
	context = _ctx,
	tests_list = {},
	event_history = false,
	monitored_events = {},
}

function _AFT.enableEventHistory()
	_AFT.event_history = true
end

--[[
  Events listener and assertion function to test correctness of received
  event data.
]]

function _evt_catcher_ (source, action, eventObj)
	local eventName = eventObj.event.name
	local eventListeners = eventObj.data.result

	-- Remove from event to hold the bare event data and be able to assert it
	eventObj.data.result = nil
	local eventData = eventObj.data

	if type(_AFT.monitored_events[eventName]) == 'table' then
		_AFT.monitored_events[eventName].eventListeners = eventListeners

		if _AFT.monitored_events[eventName].receivedCount then
			_AFT.monitored_events[eventName].receivedCount = _AFT.monitored_events[eventName].receivedCount + 1
		else
			_AFT.monitored_events[eventName].receivedCount = 1
		end

		if _AFT.monitored_events[eventName].data and type(_AFT.monitored_events[eventName].data) == 'table' then
			if _AFT.event_history == true then
				table.insert(_AFT.monitored_events[eventName].data, eventObj, 1)
			else
				_AFT.monitored_events[eventName].data[1] = eventData
			end
		else
			_AFT.monitored_events[eventName].data = {}
			table.insert(_AFT.monitored_events[eventName].data, eventData)
		end
	end
end

function _AFT.addEventToMonitor(eventName, callback)
	AFB:servsync(_AFT.context, "monitor", "set", { verbosity = "debug" })
	--AFB:servsync(_AFT.context, "monitor", "trace", { add = { event = "push_before", event = "push_after" }})
	AFB:servsync(_AFT.context, "monitor", "trace", { add = { event = "push_after" }})
	if callback then
		_AFT.monitored_events[eventName] = { cb = callback }
	else
		_AFT.monitored_events[eventName] = { cb = EvtReceived }
	end
end

function _AFT.assertEvtReceived(eventName)
	local count = 0
	if _AFT.monitored_events[eventName].receivedCount then
		count = _AFT.monitored_events[eventName].receivedCount
	end

	_AFT.assertIsTrue(count > 0, "No event '".. eventName .."' received")
end

function _AFT.testEvtReceived(testName, eventName, timeout)
	table.insert(_AFT.tests_list, {testName, function()
		if timeout then sleep(timeout) end
		_AFT.assertEvtReceived(eventName)
		if _AFT.monitored_events[eventName].cb then
			local data_n = #_AFT.monitored_events[eventName].data
			_AFT.monitored_events[eventName].cb(eventName, _AFT.monitored_events[eventName].data[data_n])
		end
	end})
end

--[[
  Assert Wrapping function meant to tests API Verbs calls
]]

local function assertVerbCallParameters(src, api, verb, args)
	_AFT.assertIsUserdata(src, "Source must be an opaque userdata pointer which will be passed to the binder")
	_AFT.assertIsString(api, "API and Verb must be string")
	_AFT.assertIsString(verb, "API and Verb must be string")
	_AFT.assertIsTable(args, "Arguments must use LUA Table (event empty)")
end

function _AFT.assertVerb(api, verb, args, cb)
	assertVerbCallParameters(_AFT.context, api, verb, args)
	local err,responseJ = AFB:servsync(_AFT.context, api, verb, args)
	_AFT.assertIsFalse(err)
	_AFT.assertStrContains(responseJ.request.status, "success", nil, nil, "Call for API/Verb failed.")

	local tcb = type(cb)
	if cb then
		if tcb == 'function' then
			cb(responseJ)
		elseif tcb == 'table' then
			_AFT.assertEquals(responseJ.response, cb)
		elseif tcb == 'string' or tcb == 'number' then
			_AFT.assertEquals(responseJ.response, cb)
		else
			_AFT.assertIsTrue(false, "Wrong parameter passed to assertion. Last parameter should be function, table representing a JSON object or nil")
		end
	end
end

function _AFT.assertVerbError(api, verb, args, cb)
	assertVerbCallParameters(_AFT.context, api, verb, args)
	local err,responseJ = AFB:servsync(_AFT.context, api, verb, args)
	_AFT.assertIsTrue(err)
	_AFT.assertNotStrContains(responseJ.request.status, "success", nil, nil, "Call for API/Verb succeed but it shouldn't.")

	local tcb = type(cb)
	if cb then
		if tcb == 'function' then
			cb(responseJ)
		elseif tcb == 'string' then
			_AFT.assertNotEquals(responseJ.request.info, cb)
		else
			_AFT.assertIsFalse(false, "Wrong parameter passed to assertion. Last parameter should be a string representing the failure informations")
		end
	end
end

function _AFT.testVerb(testName, api, verb, args, cb)
	table.insert(_AFT.tests_list, {testName, function()
		_AFT.assertVerb(api, verb, args, cb)
	end})
end

function _AFT.testVerbError(testName, api, verb, args, cb)
	table.insert(_AFT.tests_list, {testName, function()
		_AFT.assertVerbError(api, verb, args, cb)
	end})
end

--[[
	Make all assertions accessible using _AFT and declare some convenients
	aliases.
]]

local luaunit_list_of_funcs = {
	--  official function name from luaunit test framework

	-- general assertions
	'assertEquals',
	'assertItemsEquals',
	'assertNotEquals',
	'assertAlmostEquals',
	'assertNotAlmostEquals',
	'assertEvalToTrue',
	'assertEvalToFalse',
	'assertStrContains',
	'assertStrIContains',
	'assertNotStrContains',
	'assertNotStrIContains',
	'assertStrMatches',
	'assertError',
	'assertErrorMsgEquals',
	'assertErrorMsgContains',
	'assertErrorMsgMatches',
	'assertIs',
	'assertNotIs',
	'wrapFunctions',
	'wrapFunctions',

	-- type assertions: assertIsXXX -> assert_is_xxx
	'assertIsNumber',
	'assertIsString',
	'assertIsTable',
	'assertIsBoolean',
	'assertIsNil',
	'assertIsTrue',
	'assertIsFalse',
	'assertIsNaN',
	'assertIsInf',
	'assertIsPlusInf',
	'assertIsMinusInf',
	'assertIsPlusZero',
	'assertIsMinusZero',
	'assertIsFunction',
	'assertIsThread',
	'assertIsUserdata',

	-- type assertions: assertIsXXX -> assertXxx
	'assertIsNumber',
	'assertIsString',
	'assertIsTable',
	'assertIsBoolean',
	'assertIsNil',
	'assertIsTrue',
	'assertIsFalse',
	'assertIsNaN',
	'assertIsInf',
	'assertIsPlusInf',
	'assertIsMinusInf',
	'assertIsPlusZero',
	'assertIsMinusZero',
	'assertIsFunction',
	'assertIsThread',
	'assertIsUserdata',

	-- type assertions: assertIsXXX -> assert_xxx (luaunit v2 compat)
	'assertIsNumber',
	'assertIsString',
	'assertIsTable',
	'assertIsBoolean',
	'assertIsNil',
	'assertIsTrue',
	'assertIsFalse',
	'assertIsNaN',
	'assertIsInf',
	'assertIsPlusInf',
	'assertIsMinusInf',
	'assertIsPlusZero',
	'assertIsMinusZero',
	'assertIsFunction',
	'assertIsThread',
	'assertIsUserdata',

	-- type assertions: assertNotIsXXX -> assert_not_is_xxx
	'assertNotIsNumber',
	'assertNotIsString',
	'assertNotIsTable',
	'assertNotIsBoolean',
	'assertNotIsNil',
	'assertNotIsTrue',
	'assertNotIsFalse',
	'assertNotIsNaN',
	'assertNotIsInf',
	'assertNotIsPlusInf',
	'assertNotIsMinusInf',
	'assertNotIsPlusZero',
	'assertNotIsMinusZero',
	'assertNotIsFunction',
	'assertNotIsThread',
	'assertNotIsUserdata',

	-- type assertions: assertNotIsXXX -> assertNotXxx (luaunit v2 compat)
	'assertNotIsNumber',
	'assertNotIsString',
	'assertNotIsTable',
	'assertNotIsBoolean',
	'assertNotIsNil',
	'assertNotIsTrue',
	'assertNotIsFalse',
	'assertNotIsNaN',
	'assertNotIsInf',
	'assertNotIsPlusInf',
	'assertNotIsMinusInf',
	'assertNotIsPlusZero',
	'assertNotIsMinusZero',
	'assertNotIsFunction',
	'assertNotIsThread',
	'assertNotIsUserdata',

	-- type assertions: assertNotIsXXX -> assert_not_xxx
	'assertNotIsNumber',
	'assertNotIsString',
	'assertNotIsTable',
	'assertNotIsBoolean',
	'assertNotIsNil',
	'assertNotIsTrue',
	'assertNotIsFalse',
	'assertNotIsNaN',
	'assertNotIsInf',
	'assertNotIsPlusInf',
	'assertNotIsMinusInf',
	'assertNotIsPlusZero',
	'assertNotIsMinusZero',
	'assertNotIsFunction',
	'assertNotIsThread',
	'assertNotIsUserdata',

	-- all assertions with Coroutine duplicate Thread assertions
	'assertIsThread',
	'assertIsThread',
	'assertIsThread',
	'assertIsThread',
	'assertNotIsThread',
	'assertNotIsThread',
	'assertNotIsThread',
	'assertNotIsThread',
}

local _AFT_list_of_funcs = {
	-- AF Binder generic assertions
	{ 'assertVerb',      'assertVerbStatusSuccess' },
	{ 'assertVerb',      'assertVerbResponseEquals' },
	{ 'assertVerb',      'assertVerbCb' },
	{ 'assertVerbError', 'assertVerbStatusError' },
	{ 'assertVerbError', 'assertVerbResponseEqualsError' },
	{ 'assertVerbError', 'assertVerbCbError' },
	{ 'testVerb',      'testVerbStatusSuccess' },
	{ 'testVerb',      'testVerbResponseEquals' },
	{ 'testVerb',      'testVerbCb' },
	{ 'testVerbError', 'testVerbStatusError' },
	{ 'testVerbError', 'testVerbResponseEqualsError' },
	{ 'testVerbError', 'testVerbCbError' },
}

-- Create all aliases in M
for _, v in pairs( luaunit_list_of_funcs ) do
	local funcname = v
	_AFT[funcname] = lu[funcname]
end

-- Create all aliases in M
for _, v in pairs( _AFT_list_of_funcs ) do
	local funcname, alias = v[1], v[2]
	_AFT[alias] = _AFT[funcname]
end

function _launch_test(context, args)
	_AFT.context = context
	for _,f in pairs(args.files) do
		dofile('var/'..f)
	end
	lu.LuaUnit:runSuiteByInstances(_AFT.tests_list)
end
