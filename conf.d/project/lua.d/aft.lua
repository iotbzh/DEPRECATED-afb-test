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

local AFT = {
	context = _ctx
}

--[[
  Events listener and assertion function to test correctness of received
  event data.
]]

_events_cb = {}

function _evt_catcher_ (source, action, evt)
  -- local table_end = table_length(_events) + 1
  -- _events[event.event] = event.data
  if _events_cb[evt.event] ~= nil then
    _events_cb[evt.event](evt)
  end
end

function AFT.assertEvtReceived(event)
	lu.execOneFunction(nil,nil,nil, function()
		assertIsString(event, "Event parameter must be a string")
		assertTrue(true)
	end)
end

--[[
  Assert Wrapping function meant to tests API Verbs calls
]]

local function assertVerbCallParameters(src, api, verb, args)
	AFT.assertIsUserdata(src, "Source must be an opaque userdata pointer which will be passed to the binder")
	AFT.assertIsString(api, "API and Verb must be string")
	AFT.assertIsString(verb, "API and Verb must be string")
	AFT.assertIsTable(args, "Arguments must use LUA Table (event empty)")
end

function AFT.assertVerb(api, verb, args, cb)
	lu.LuaUnit:runSuiteByInstances({{"assertVerb", function()
		assertVerbCallParameters(AFT.context, api, verb, args)
		local err,responseJ = AFB:servsync(AFT.context, api, verb, args)
		lu.assertFalse(err)
		lu.assertStrContains(responseJ.request.status, "success", nil, nil, "Call for API/Verb failed.")

		if type(cb) == 'function' then
			cb(responseJ)
		elseif type(cb) == 'table' then
			assertTrue(table_eq(responseJ, cb))
		elseif not type(cb) == nil then
			assertTrue(false, "Wrong parameter passed to assertion. Last parameter should be function, table representing a JSON object or nil")
		end
	end}} )
end

function AFT.assertVerbError(api, verb, args, cb)
	lu.execOneFunction(nil,nil,nil, function()
		assertVerbCallParameters(AFT.context, api, verb, args)
		local err,responseJ = AFB:servsync(AFT.context, api, verb, args)
		lu.assertFalse(err)
		lu.assertNotStrContains(responseJ.request.status, "success", nil, nil, "Call for API/Verb succeed but it shouldn't.")

		if type(cb) == 'function' then
			cb(responseJ)
		elseif type(cb) == 'table' then
			assertFalse(table_eq(responseJ, cb))
		elseif not type(cb) == nil then
			assertFalse(true, "Wrong parameter passed to assertion. Last parameter should be function, table representing a JSON object or nil")
		end
	end)
end

--[[
	Make all assertions accessible using AFT and declare some convenients
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

local aft_list_of_funcs = {
	-- AF Binder generic assertions
	{ 'assertVerb',      'assertVerbStatusSuccess' },
	{ 'assertVerb',      'assertVerbResponseEquals' },
	{ 'assertVerb',      'assertVerbResponseContains' },
	{ 'assertVerb',      'assertVerbCb' },
	{ 'assertVerbError', 'assertVerbStatusError' },
	{ 'assertVerbError', 'assertVerbResponseEqualsError' },
	{ 'assertVerbError', 'assertVerbResponseContainsError' },
	{ 'assertVerbError', 'assertVerbCbError' },
}

-- Create all aliases in M
for _, v in pairs( luaunit_list_of_funcs ) do
	local funcname = v
	AFT[funcname] = lu[funcname]
end

-- Create all aliases in M
for _, v in pairs( aft_list_of_funcs ) do
	local funcname, alias = v[1], v[2]
	AFT[alias] = AFT[funcname]
end

function _launch_test(context, args)
	_ctx = context
	for _,f in pairs(args.files) do
		print('******** Do file: var/'.. f)
		dofile('var/'..f)
	end
end

return AFT
