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

> **CAUTION** : It must stay a JSON array, don't change the type

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

* **_AFT.testEvtReceived(testName, eventName, timeout)**

    Prior to be able to check that an event has been received, you have to
    register the event with the test framework using **_AFT.addEventToMonitor**
    function.

    Check if an event has been correctly received. An event name use the
    application framework naming scheme: **api/event_name**.

    The timeout argument is in seconds and could be omitted if you doesn't need
    to wait to receive the event.

> **NOTE**: about now this timeout arguments simply wait a number of seconds
> instead of interrupt as soon as the event has been received.

* **_AFT.testLogReceived(testName, logMsg, timeout)**

    Prior to be able to check that an event has been received, you have to
    register the event with the test framework using **_AFT.addLogToMonitor**
    function.

    Check if a log message sent by the daemon has been correctly received. A log
    message is caracterized by its *api* and the message level *error*,
    *warning*, *notice*, *info* or *debug*.

    The timeout argument is in seconds and could be omitted if you doesn't need
    to wait to receive the event.

> **NOTE**: about now this timeout arguments simply wait a number of seconds
> instead of interrupt as soon as the event has been received.

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

    The timeout argument is in seconds and could be omitted if you doesn't need
    to wait to receive the event.

> **NOTE**: about now this timeout arguments simply wait a number of seconds
> instead of interrupt as soon as the event has been received.

* **_AFT.assertLogReceived(testName, logMsg, timeout)**

    Prior to be able to check that an event has been received, you have to
    register the event with the test framework using **_AFT.addLogToMonitor**
    function.

    Check if a log message sent by the daemon has been correctly received. A log
    message is caracterized by its *api* and the message level *error*,
    *warning*, *notice*, *info* or *debug*.

    The timeout argument is in seconds and could be omitted if you doesn't need
    to wait to receive the event.

> **NOTE**: about now this timeout arguments simply wait a number of seconds
> instead of interrupt as soon as the event has been received.

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
