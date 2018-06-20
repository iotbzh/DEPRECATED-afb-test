# Installation

## Pre-requisites

[Setup the pre-requisite](http://docs.automotivelinux.org/docs/devguides/en/dev/reference/host-configuration/docs/1_Prerequisites.html) then [install the Application Framework](http://docs.automotivelinux.org/docs/devguides/en/dev/reference/host-configuration/docs/2_AGL_Application_Framework.html) on your host.

You will also need to install lua-devel >= 5.3 to be able to build the project.

Fedora:

```bash
dnf install lua-devel
```

OpenSuse:

```bash
zypper install lua53-devel
```

Ubuntu (>= Xenial), Debian stable:

```bash
apt-get install liblua5.3-dev
```

## Grab source and build

Download the **afb-test** binding source code using git:

```bash
git clone --recurse-submodules https://github.com/iotbzh/afb-test
cd afb-test
mkdir build
cd build
cmake .. && make
```

## Launch the example

To launch the binding use the command-line provided at the end of the build.
This will launch the test of an Helloworld binding example. The code of the test
is available from the LUA file `conf.d/project/lua.d/helloworld.lua`.

The example will run some basics tests on API verb calls and events received.

```lua
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

_AFT.testCustom("mytest", function()
  _AFT.assertEquals(false, false)
end)
```

> **NOTE**: I suggest you to take this lua file example to make your own test
> then read the following the chapter if needed to write more complicated tests.

```bash
$ afb-daemon --name afbd-test --port=1234 --workdir=package --ldpaths=/opt/AGL/lib64/afb:lib --token= --tracereq=common --verbose
NOTICE: Can't connect supervision socket to @urn:AGL:afs:supervision:socket: Connection refused
NOTICE: [API hello] hello binding comes to live
NOTICE: [API ave] dynamic binding AVE(ave) comes to live
NOTICE: [API hi] dynamic binding AVE(hi) comes to live
NOTICE: [API salut] dynamic binding AVE(salut) comes to live
NOTICE: [API lib/test-binding.so] Controller in afbBindingVdyn
NOTICE: [API lib/test-binding.so] Controller API='test' info='Binding made to tests other bindings'
NOTICE: API monitor started
HOOK: [xreq-000001:monitor/set] BEGIN
HOOK: [xreq-000001:monitor/set] json() -> { "verbosity": "debug" }
HOOK: [xreq-000001:monitor/set] success(null, (null))
HOOK: [xreq-000001:monitor/set] END
HOOK: [xreq-000002:monitor/trace] BEGIN
HOOK: [xreq-000002:monitor/trace] json() -> { "add": { "event": "push_after" } }
HOOK: [xreq-000002:monitor/trace] subscribe(monitor/trace:1) -> 0
HOOK: [xreq-000002:monitor/trace] success(null, (null))
HOOK: [xreq-000002:monitor/trace] END
HOOK: [xreq-000003:monitor/set] BEGIN
HOOK: [xreq-000003:monitor/set] json() -> { "verbosity": "debug" }
HOOK: [xreq-000003:monitor/set] success(null, (null))
HOOK: [xreq-000003:monitor/set] END
HOOK: [xreq-000004:monitor/trace] BEGIN
HOOK: [xreq-000004:monitor/trace] json() -> { "add": { "event": "push_after" } }
HOOK: [xreq-000004:monitor/trace] subscribe(monitor/trace:1) -> 0
HOOK: [xreq-000004:monitor/trace] success(null, (null))
HOOK: [xreq-000004:monitor/trace] END
# XML output to var/jUnitResults.xml
# Started on Thu Jun 14 18:12:33 2018
# Starting test: testPingSuccess
INFO: API hello starting...
NOTICE: [API hello] hello binding starting
NOTICE: API hello started
HOOK: [xreq-000005:hello/ping] BEGIN
HOOK: [xreq-000005:hello/ping] json() -> null
HOOK: [xreq-000005:hello/ping] success("Some String", Ping Binder Daemon tag=pingSample count=1 query=null)
HOOK: [xreq-000005:hello/ping] END
# Starting test: testPingSuccess
HOOK: [xreq-000006:hello/ping] BEGIN
HOOK: [xreq-000006:hello/ping] json() -> null
HOOK: [xreq-000006:hello/ping] success("Some String", Ping Binder Daemon tag=pingSample count=2 query=null)
HOOK: [xreq-000006:hello/ping] END
# Starting test: testPingSuccess
HOOK: [xreq-000007:hello/ping] BEGIN
HOOK: [xreq-000007:hello/ping] json() -> null
HOOK: [xreq-000007:hello/ping] success("Some String", Ping Binder Daemon tag=pingSample count=3 query=null)
HOOK: [xreq-000007:hello/ping] END
#   Failure:  var//aft.lua:127: expected: "Unexpected String"
#   actual: "Some String"
# Starting test: testPingSuccess
HOOK: [xreq-000008:hello/ping] BEGIN
HOOK: [xreq-000008:hello/ping] json() -> null
HOOK: [xreq-000008:hello/ping] success("Some String", Ping Binder Daemon tag=pingSample count=4 query=null)
HOOK: [xreq-000008:hello/ping] END
# Starting test: testPingError
HOOK: [xreq-000009:hello/pingfail] BEGIN
HOOK: [xreq-000009:hello/pingfail] fail(failed, Ping Binder Daemon fails)
HOOK: [xreq-000009:hello/pingfail] END
# Starting test: testPingError
HOOK: [xreq-000010:hello/pingfail] BEGIN
HOOK: [xreq-000010:hello/pingfail] fail(failed, Ping Binder Daemon fails)
HOOK: [xreq-000010:hello/pingfail] END
#   Failure:  var//aft.lua:145: Received the not expected value: "Ping Binder Daemon fails"
# Starting test: testPingError
HOOK: [xreq-000011:hello/pingfail] BEGIN
HOOK: [xreq-000011:hello/pingfail] fail(failed, Ping Binder Daemon fails)
HOOK: [xreq-000011:hello/pingfail] END
# Starting test: testPingError
HOOK: [xreq-000012:hello/pingfail] BEGIN
HOOK: [xreq-000012:hello/pingfail] fail(failed, Ping Binder Daemon fails)
HOOK: [xreq-000012:hello/pingfail] END
# Starting test: testEventAdd
HOOK: [xreq-000013:hello/eventadd] BEGIN
HOOK: [xreq-000013:hello/eventadd] get(tag) -> { name: tag, value: event, path: (null) }
HOOK: [xreq-000013:hello/eventadd] get(name) -> { name: name, value: anEvent, path: (null) }
HOOK: [xreq-000013:hello/eventadd] success(null, (null))
HOOK: [xreq-000013:hello/eventadd] END
# Starting test: testEventSub
HOOK: [xreq-000014:hello/eventsub] BEGIN
HOOK: [xreq-000014:hello/eventsub] get(tag) -> { name: tag, value: event, path: (null) }
HOOK: [xreq-000014:hello/eventsub] subscribe(hello/anEvent:2) -> 0
HOOK: [xreq-000014:hello/eventsub] success(null, (null))
HOOK: [xreq-000014:hello/eventsub] END
# Starting test: testEventPush
HOOK: [xreq-000015:hello/eventpush] BEGIN
HOOK: [xreq-000015:hello/eventpush] get(tag) -> { name: tag, value: event, path: (null) }
HOOK: [xreq-000015:hello/eventpush] get(data) -> { name: data, value: { "another_key": 123, "key": "some data" }, path: (null) }
DEBUG: [API test] Received event=hello/anEvent, query={ "another_key": 123, "key": "some data" }
WARNING: [API test] CtlDispatchEvent: fail to find uid=hello/anEvent in action event section [/home/claneys/Workspace/Sources/IOTbzh/afb-test/app-controller-submodule/ctl-lib/ctl-event.c:46,CtrlDispatchApiEvent]
DEBUG: [API test] Received event=monitor/trace, query={ "time": "10944.010648", "tag": "trace", "type": "event", "id": 106, "event": { "id": 2, "name": "hello\/anEvent", "action": "push_after" }, "data": { "data": { "another_key": 123, "key": "some data" }, "result": 1 } }
DEBUG: [API test] Received event=monitor/trace, query={ "time": "10944.010648", "tag": "trace", "type": "event", "id": 106, "event": { "id": 2, "name": "hello\/anEvent", "action": "push_after" }, "data": { "data": { "another_key": 123, "key": "some data" }, "result": 1 } }
HOOK: [xreq-000015:hello/eventpush] success(null, (null))
HOOK: [xreq-000015:hello/eventpush] END
# Starting test: testEventAdd
HOOK: [xreq-000016:hello/eventadd] BEGIN
HOOK: [xreq-000016:hello/eventadd] get(tag) -> { name: tag, value: evt, path: (null) }
HOOK: [xreq-000016:hello/eventadd] get(name) -> { name: name, value: anotherEvent, path: (null) }
HOOK: [xreq-000016:hello/eventadd] success(null, (null))
HOOK: [xreq-000016:hello/eventadd] END
# Starting test: testEventSub
HOOK: [xreq-000017:hello/eventsub] BEGIN
HOOK: [xreq-000017:hello/eventsub] get(tag) -> { name: tag, value: evt, path: (null) }
HOOK: [xreq-000017:hello/eventsub] subscribe(hello/anotherEvent:3) -> 0
HOOK: [xreq-000017:hello/eventsub] success(null, (null))
HOOK: [xreq-000017:hello/eventsub] END
# Starting test: testEventPush
HOOK: [xreq-000018:hello/eventpush] BEGIN
HOOK: [xreq-000018:hello/eventpush] get(tag) -> { name: tag, value: evt, path: (null) }
HOOK: [xreq-000018:hello/eventpush] get(data) -> { name: data, value: { "another_key": 123.456, "key": "weird others data" }, path: (null) }
DEBUG: [API test] Received event=hello/anotherEvent, query={ "another_key": 123.456, "key": "weird others data" }
WARNING: [API test] CtlDispatchEvent: fail to find uid=hello/anotherEvent in action event section [/home/claneys/Workspace/Sources/IOTbzh/afb-test/app-controller-submodule/ctl-lib/ctl-event.c:46,CtrlDispatchApiEvent]
DEBUG: [API test] Received event=monitor/trace, query={ "time": "10944.011045", "tag": "trace", "type": "event", "id": 128, "event": { "id": 3, "name": "hello\/anotherEvent", "action": "push_after" }, "data": { "data": { "another_key": 123.456, "key": "weird others data" }, "result": 1 } }
DEBUG: [API test] Received event=monitor/trace, query={ "time": "10944.011045", "tag": "trace", "type": "event", "id": 128, "event": { "id": 3, "name": "hello\/anotherEvent", "action": "push_after" }, "data": { "data": { "another_key": 123.456, "key": "weird others data" }, "result": 1 } }
HOOK: [xreq-000018:hello/eventpush] success(null, (null))
HOOK: [xreq-000018:hello/eventpush] END
# Starting test: testEvent
# Starting test: testEventCb
# Ran 16 tests in 0.003 seconds, 14 successes, 2 failures
DEBUG: Init config done
INFO: API auth starting...
NOTICE: API auth started
INFO: API ave starting...
NOTICE: [API ave] dynamic binding AVE(ave) starting
NOTICE: API ave started
INFO: API context starting...
NOTICE: API context started
INFO: API dbus starting...
NOTICE: API dbus started
INFO: API hi starting...
NOTICE: [API hi] dynamic binding AVE(hi) starting
NOTICE: API hi started
INFO: API post starting...
NOTICE: API post started
INFO: API salut starting...
NOTICE: [API salut] dynamic binding AVE(salut) starting
NOTICE: API salut started
INFO: API test starting...
NOTICE: API test started
INFO: API tictactoe starting...
NOTICE: API tictactoe started
NOTICE: Waiting port=1234 rootdir=.
NOTICE: Browser URL= http://localhost:1234
```

## Write your own tests

### Binding configuration

In the package directory you have a file name `test-config.json` that contains
the controller binding configuration. Here, you have to change or define the
*files* key in the *args* object of the *onload* section.

Also you MUST specify which *api* you need to trace to perform your tests.
Specify which api to trace using a pattern.

Edit the JSON array to point to your tests files.

Here is an example:

```json
{
    "id": "http://iot.bzh/download/public/schema/json/ctl-schema.json#",
    "$schema": "http://iot.bzh/download/public/schema/json/ctl-schema.json#",
    "metadata": {
        "uid": "Test",
        "version": "1.0",
        "api": "test",
        "info": "Binding made to tests other bindings",
        "require": [
            "hello"
        ]
    },
    "onload": {
        "uid": "launch_all_tests",
        "info": "Launch all the tests",
        "action": "lua://AFT#_launch_test",
        "args": {
            "trace": "hello",
            "files": ["helloworld.lua"]
        }
    }
}
```

### LUA Test files

First, ensure that you put your LUA tests files in the `var` directory from the
binding root directory.

You have two differents things to take in account when you'll write your tests
using this framework: *test* and *assertions*.

*Assertions* are functions mean to test an atomic operation result.
(ie: `1+1 = 2` is an assertion)

*Test* functions represent a test (Unbelievable), they represent a set of one or
several *assertions* which are all needed to succeed to valid the test.

The framework came with several *test* and *assertion* functions to simply be
able to test verb calls and events receiving. Use the simple one as often as
possible and if you need more use the one that call a callback. Specifying a
callback let you add assertions and enrich the test.

### Reference

#### Binding Test functions

* **_AFT.testVerbStatusSuccess(testName, api, verb, args)**

    Simply test that the call of a verb successfully returns.

* **_AFT.testVerbStatusError(testName, api, verb, args)**

    The inverse than above

* **_AFT.testVerbResponseEquals(testName, api, verb, args, expectedResponse)**

    Test that the call of a verb successfully returns and that verb's response
    is equals to the *expectedResponse*.

* **_AFT.testVerbResponseEqualsError(testName, api, verb, args, expectedResponse)**

    The inverse than above

* **_AFT.testVerbCb(testName, api, verb, args, expectedResponse, callback)**

    Test that the call of a verb with a custom callback. From this callback you
    will need to make some assertions on what you need (verb JSON return object
    content mainly).

    If you doesn't need to test the response simply specify an empty LUA table.

* **_AFT.testVerbCbError(testName, api, verb, args, expectedResponse, callback)**

    Should return success on failure.

* **_AFT.testEvtReceived(testName, eventName)**

    Prior to be able to check that an event has been received, you have to
    register the event with the test framework using **_AFT.addEventToMonitor**
    function.

    Check if an event has been correctly received. An event name use the
    application framework naming scheme: **api/event_name**.

* **_AFT.testLogReceived(testName, logMsg)**

    Prior to be able to check that an event has been received, you have to
    register the event with the test framework using **_AFT.addLogToMonitor**
    function.

    Check if a log message sent by the daemon has been correctly received. A log
    message is caracterized by its *api* and the message level *error*,
    *warning*, *notice*, *info* or *debug*.

* **_AFT.testEvtNotReceived(testName, eventName)**

    Prior to be able to check that an event has been received, you have to
    register the event with the test framework using **_AFT.addEventToMonitor**
    function.

    Check if an event has been correctly received. An event name use the
    application framework naming scheme: **api/event_name**.

* **_AFT.testLogNotReceived(testName, logMsg)**

    Prior to be able to check that an event has been received, you have to
    register the event with the test framework using **_AFT.addLogToMonitor**
    function.

    Check if a log message sent by the daemon has been correctly received. A log
    message is caracterized by its *api* and the message level *error*,
    *warning*, *notice*, *info* or *debug*.

#### Binding Assert functions

* **_AFT.assertVerbStatusSuccess(api, verb, args)**

    Simply test that the call of a verb successfully returns.

* **_AFT.assertVerbStatusError(testName, api, verb, args)**

    The inverse than above

* **_AFT.assertVerbResponseEquals(api, verb, args, expectedResponse)**

    Test that the call of a verb successfully returns and that verb's response
    is equals to the *expectedResponse*.

* **_AFT.assertVerbResponseEqualsError(api, verb, args, expectedResponse)**

    The inverse than above

* **_AFT.assertVerbCb(api, verb, args, expectedResponse, callback)**

    Test that the call of a verb with a custom callback. From this callback you
    will need to make some assertions on what you need (verb JSON return object
    content mainly).

    If you doesn't need to test the response simply specify an empty LUA table.

* **_AFT.assertVerbCbError(api, verb, args, expectedResponse, callback)**

    Should return success on failure.

* **_AFT.assertEvtReceived(eventName)**

    Prior to be able to check that an event has been received, you have to
    register the event with the test framework using **_AFT.addEventToMonitor**
    function.

    Check if an event has been correctly received. An event name use the
    application framework naming scheme: **api/event_name**.

* **_AFT.assertLogReceived(testName, logMsg)**

    Prior to be able to check that an event has been received, you have to
    register the event with the test framework using **_AFT.addLogToMonitor**
    function.

    Check if a log message sent by the daemon has been correctly received. A log
    message is caracterized by its *api* and the message level *error*,
    *warning*, *notice*, *info* or *debug*.
* **_AFT.assertEvtNotReceived(eventName)**

    Prior to be able to check that an event has been received, you have to
    register the event with the test framework using **_AFT.addEventToMonitor**
    function.

    Check if an event has been correctly received. An event name use the
    application framework naming scheme: **api/event_name**.

* **_AFT.assertLogNotReceived(testName, logMsg)**

    Prior to be able to check that an event has been received, you have to
    register the event with the test framework using **_AFT.addLogToMonitor**
    function.

    Check if a log message sent by the daemon has been correctly received. A log
    message is caracterized by its *api* and the message level *error*,
    *warning*, *notice*, *info* or *debug*.

#### Test Framework functions

* **_AFT.addEventToMonitor(eventName, callback)**

    Add a binding event in the test framework to be able to assert its reception
    . You'll need to add as much as events you expect to receive. You could also
    specify a callback to test deeper that the event is as you want to. The
    callback will happens after the assertion that it has been received so you
    can work on data that the event eventually carry.

* **_AFT.addLogToMonitor(api, type, message, callback)**

    Add a message log in the test framework to be able to assert its reception.
    The behavior is the same than for the api *events* except that in addition
    it also check that the message is coming from a specified *api* and has the
    specified type *error*, *warning*, *notice*, *info* or *debug*.

* **_AFT.setJunitFile(filePath)**

    Set the *JUnit* file path. When *JUnit* is set as the output type for the
    test framework.

#### LuaUnit Assertion functions

##### General Assertions

* **assertEquals(actual, expected)**

    Assert that two values are equal.

    For tables, the comparison is a deep comparison :

  * number of elements must be the same
  * tables must contain the same keys
  * each key must contain the same values. The values are also compared recursively with deep comparison.

    LuaUnit provides other table-related assertions, see [Table assertions](http://luaunit.readthedocs.io/en/luaunit_v3_2_1/#assert-table)

* **assertNotEquals(actual, expected)**

    Assert that two values are different. The assertion fails if the two values are identical.

    It also uses table deep comparison.

* **assertAlmostEquals(actual, expected, margin)**

    Assert that two floating point numbers are almost equal.

    When comparing floating point numbers, strict equality does not work. Computer arithmetic is so that an operation that mathematically yields 1.00000000 might yield 0.999999999999 in lua . That’s why you need an almost equals comparison, where you specify the error margin.

* **assertNotAlmostEquals(actual, expected, margin)**

    Assert that two floating point numbers are not almost equal.

##### Value assertions

* **assertEvalToTrue(value)**

    Assert that a given value evals to true. Lua coercion rules are applied so that values like 0,"",1.17 succeed
    in this assertion. If provided, extra_msg is a string which will be printed along with the failure message.

* **assertEvalToFalse(Value)**

    Assert that a given value eval to *false*. Lua coercion rules are applied so that *nil* and *false* succeed in this
    assertion. If provided, extra_msg is a string which will be printed along with the failure message.

* **assertIsTrue(value)**

    Assert that a given value compares to true. Lua coercion rules are applied so that values like 0, "", 1.17 all compare to true.

* **assertIsFalse(value)**

    Assert that a given value compares to false. Lua coercion rules are applied so that only nil and false all compare to false.

* **assertIsNil(value)**

    Assert that a given value is nil .

* **assertNotIsNil(value)**

    Assert that a given value is not *nil* . Lua coercion rules are applied
    so that values like ``0``, ``""``, ``false`` all validate the assertion.
    If provided, *extra_msg* is a string which will be printed along with the failure message.

* **assertIs(actual, expected)**

    Assert that two variables are identical. For string, numbers, boolean and for nil, this gives the same result as assertEquals() . For the other types, identity means that the two variables refer to the same object.

    Example :

    `s1='toto'
    s2='to'..'to'
    t1={1,2}
    t2={1,2}
    luaunit.assertIs(s1,s1) -- ok
    luaunit.assertIs(s1,s2) -- ok
    luaunit.assertIs(t1,t1) -- ok
    luaunit.assertIs(t1,t2) -- fail`

* **assertNotIs(actual, expected)**

    Assert that two variables are not identical, in the sense that they do not refer to the same value. See assertIs() for more details.

##### Scientific assertions

>**Note**
>If you need to deal with value minus zero, be very careful because Lua versions are inconsistent on how they treat the >syntax -0 : it creates either a plus zero or a minus zero . Multiplying or dividing 0 by -1 also yields inconsistent >results. The reliable way to create the -0 value is : minusZero = -1 / (1/0)

* **assertIsNaN(value)**
    Assert that a given number is a *NaN* (Not a Number), according to the definition of IEEE-754_ .
    If provided, *extra_msg* is a string which will be printed along with the failure message.

* **assertIsPlusInf(value)**

    Assert that a given number is *plus infinity*, according to the definition of IEEE-754_ .
    If provided, *extra_msg* is a string which will be printed along with the failure message.

* **assertIsMinusInf(value)**

    Assert that a given number is *minus infinity*, according to the definition of IEEE-754_ .
    If provided, *extra_msg* is a string which will be printed along with the failure message.

* **assertIsInf(value)**

    Assert that a given number is *infinity* (either positive or negative), according to the definition of IEEE-754_ .
    If provided, *extra_msg* is a string which will be printed along with the failure message.

* **assertIsPlusZero(value)**

    Assert that a given number is *+0*, according to the definition of IEEE-754_ . The
    verification is done by dividing by the provided number and verifying that it yields
    *infinity* . If provided, *extra_msg* is a string which will be printed along with the failure message.

    Be careful when dealing with *+0* and *-0*, see note above

* **assertIsMinusZero(value)**

    Assert that a given number is *-0*, according to the definition of IEEE-754_ . The
    verification is done by dividing by the provided number and verifying that it yields
    *minus infinity* . If provided, *extra_msg* is a string which will be printed along with the failure message.

    Be careful when dealing with *+0* and *-0*

##### String assertions

Assertions related to string and patterns.

* **assertStrContains(str, sub[, useRe])**

    Assert that a string contains the given substring or pattern.

    By default, substring is searched in the string. If useRe is provided and is true, sub is treated as a pattern which is searched inside the string str .

* **assertStrIContains(str, sub)**

    Assert that a string contains the given substring, irrespective of the case.

    Not that unlike assertStrcontains(), you can not search for a pattern.

* **assertNotStrContains(str, sub, useRe)**

    Assert that a string does not contain a given substring or pattern.

    By default, substring is searched in the string. If useRe is provided and is true, sub is treated as a pattern which is searched inside the string str .

* **assertNotStrIContains(str, sub)**

    Assert that a string does not contain the given substring, irrespective of the case.

    Not that unlike assertNotStrcontains(), you can not search for a pattern.

* **assertStrMatches(str, pattern[, start[, final]])**

    Assert that a string matches the full pattern pattern.

    If start and final are not provided or are nil, the pattern must match the full string, from start to end. The functions allows to specify the expected start and end position of the pattern in the string.

##### Error assertions

Error related assertions, to verify error generation and error messages.

* **assertError(func, ...)**

    Assert that calling functions func with the arguments yields an error. If the function does not yield an error, the assertion fails.

    Note that the error message itself is not checked, which means that this function does not distinguish between the legitimate error that you expect and another error that might be triggered by mistake.

    The next functions provide a better approach to error testing, by checking explicitly the error message content.

>**Note**
>When testing LuaUnit, switching from assertError() to assertErrorMsgEquals() revealed quite a few bugs!

* **assertErrorMsgEquals(expectedMsg, func, ...)**

    Assert that calling function func will generate exactly the given error message. If the function does not yield an error, or if the error message is not identical, the assertion fails.

    Be careful when using this function that error messages usually contain the file name and line number information of where the error was generated. This is usually inconvenient. To ignore the filename and line number information, you can either use a pattern with assertErrorMsgMatches() or simply check for the message containt with assertErrorMsgContains() .

* **assertErrorMsgContains(partialMsg, func, ...)**

    Assert that calling function func will generate an error message containing partialMsg . If the function does not yield an error, or if the expected message is not contained in the error message, the assertion fails.

* **assertErrorMsgMatches(expectedPattern, func, ...)**

    Assert that calling function func will generate an error message matching expectedPattern . If the function does not yield an error, or if the error message does not match the provided patternm the assertion fails.

    Note that matching is done from the start to the end of the error message. Be sure to escape magic all magic characters with % (like -+.?\*) .

##### Type assertions

The following functions all perform type checking on their argument. If the received value is not of the right type, the failure message will contain the expected type, the received type and the received value to help you identify better the problem.

* **assertIsNumber(value)**

    Assert that the argument is a number (integer or float)

* **assertIsString(value)**

    Assert that the argument is a string.

* **assertIsTable(value)**

    Assert that the argument is a table.

* **assertIsBoolean(value)**

    Assert that the argument is a boolean.

* **assertIsFunction(value)**

    Assert that the argument is a function.

* **assertIsUserdata(value)**

    Assert that the argument is a userdata.

* **assertIsThread(value)**

    Assert that the argument is a coroutine (an object with type thread ).

* **assertNotIsThread(value)**

    Assert that the argument is a not coroutine (an object with type thread ).

##### Table assertions

* **assertItemsEquals(actual, expected)**

    Assert that two tables contain the same items, irrespective of their keys.

    This function is practical for example if you want to compare two lists but where items are not in the same order:

    `luaunit.assertItemsEquals( {1,2,3}, {3,2,1} ) -- assertion succeeds`

    The comparison is not recursive on the items: if any of the items are tables, they are compared using table equality (like as in assertEquals() ), where the key matters.

    `luaunit.assertItemsEquals( {1,{2,3},4}, {4,{3,2,},1} ) -- assertion fails because {2,3} ~= {3,2}`






