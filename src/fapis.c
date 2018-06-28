/*
 * Copyright (C) 2016 "IoT.bzh"
 *
 * Author Romain Forlot <romain@iot.bzh>
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#include <fapis.h>

static int LoadOneFapi(void *data, AFB_ApiT apiHandle)
{
	CtlActionT *actions = NULL;
	json_object* verbsJ = (json_object*) data;

	actions = ActionConfig(apiHandle, verbsJ, 1);

	return 0;
}

static void OneFapiConfig(void  *data, json_object *fapiJ) {
	const char *uid = NULL, *info = NULL, *spath = NULL;
	json_object *verbsJ = NULL, *filesJ = NULL, *luaJ = NULL;

	AFB_ApiT apiHandle = (AFB_ApiT)data;

	if(wrap_json_unpack(fapiJ, "{ss,s?s,s?s,so,s?o,so !}",
					"uid", &uid,
					"info", &info,
					"spath", &spath,
					"libs", &filesJ,
					"lua", &luaJ,
					"verbs", &verbsJ)) {
		AFB_ApiError(apiHandle, "Wrong fapis specification, missing uid|[info]|[spath]|libs|[lua]|verbs");
		return;
	}

	if (afb_dynapi_new_api(apiHandle, uid, info, 1, LoadOneFapi, )) {
		AFB_ApiError(apiHandle, "Error creating new api: %s", uid);
		return;
	}
}

int FapisConfig(AFB_ApiT apiHandle, CtlSectionT *section, json_object *fapisJ) {
	if(! PluginConfig(apiHandle, section, fapisJ))
		wrap_json_optarray_for_all(fapisJ, OneFapiConfig, (void*)apiHandle);
}
