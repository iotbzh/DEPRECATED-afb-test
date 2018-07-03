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

#include <mapis.h>
#include <ctl-plugin.h>

struct mapisHandleT {
	AFB_ApiT mainApiHandle;
	CtlSectionT *section;
	json_object *mapiJ;
	json_object *verbsJ;
	json_object *eventsJ;
};

static int LoadOneMapi(void *data, AFB_ApiT apiHandle)
{
	struct mapisHandleT *mapisHandle = (struct mapisHandleT*)data;

	if(PluginConfig(apiHandle, mapisHandle->section, mapisHandle->mapiJ)) {
		AFB_ApiError(apiHandle, "Problem loading the plugin as an API for %s, see log message above", json_object_get_string(mapisHandle->mapiJ));
		return -1;
	}

	// declare the verbs for this API
	if(! ActionConfig(apiHandle, mapisHandle->verbsJ, 1)) {
		AFB_ApiError(apiHandle, "Problems at verbs creations for %s", json_object_get_string(mapisHandle->mapiJ));
		return -1;
	}
	// declare an event event manager for this API;
	afb_dynapi_on_event(apiHandle, CtrlDispatchApiEvent);

	return 0;
}

static void OneMapiConfig(void *data, json_object *mapiJ) {
	const char *uid = NULL, *info = NULL;

	struct mapisHandleT *mapisHandle = (struct mapisHandleT*)data;

	if(mapiJ) {
		if(wrap_json_unpack(mapiJ, "{ss,s?s,s?s,so,s?o,so !}",
					"uid", &uid,
					"info", &info,
					"spath", NULL,
					"libs", NULL,
					"lua", NULL,
					"verbs", &mapisHandle->verbsJ,
					"eventsJ", &mapisHandle->eventsJ)) {
		AFB_ApiError(mapisHandle->mainApiHandle, "Wrong mapis specification, missing uid|[info]|[spath]|libs|[lua]|verbs");
		return;
		}

		json_object_get(mapisHandle->verbsJ);
		json_object_get(mapisHandle->eventsJ);
		json_object_object_del(mapiJ, "verbs");
		json_object_object_del(mapiJ, "events");
		mapisHandle->mapiJ = mapiJ;

		if (afb_dynapi_new_api(mapisHandle->mainApiHandle, uid, info, 1, LoadOneMapi, (void*)mapisHandle)) {
			AFB_ApiError(mapisHandle->mainApiHandle, "Error creating new api: %s", uid);
			return;
		}
	}
}

int MapiConfig(AFB_ApiT apiHandle, CtlSectionT *section, json_object *mapisJ) {
	struct mapisHandleT mapisHandle = {
		.mainApiHandle = apiHandle,
		.section = section,
		.mapiJ = NULL,
		.verbsJ = NULL
	};
	wrap_json_optarray_for_all(mapisJ, OneMapiConfig, (void*)&mapisHandle);

	return 0;
}
