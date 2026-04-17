/*
 * Audacity: A Digital Audio Editor
 */
#include "missingeffectchecker.h"

#include "framework/global/log.h"
#include "framework/global/types/uri.h"
#include "framework/global/types/val.h"

#include <set>

namespace au::effects {
void MissingEffectChecker::warnIfEffectsMissing()
{
    const auto project = globalContext()->currentTrackeditProject();
    IF_ASSERT_FAILED(project && "call expected on opened project") {
        return;
    }

    std::set<std::string> missingEffects;

    const std::vector<trackedit::TrackId> trackIds = project->trackIdList();
    for (const auto trackId : trackIds) {
        const auto effectStack = realtimeEffectService()->effectStack(trackId);
        if (!effectStack) {
            continue;
        }
        for (const auto& state : *effectStack) {
            if (!realtimeEffectService()->isAvailable(state)) {
                const auto name = realtimeEffectService()->effectName(state);
                if (name) {
                    missingEffects.insert(*name);
                }
            }
        }
    }

    if (missingEffects.empty()) {
        return;
    }

    muse::ValList names;
    names.reserve(missingEffects.size());
    for (const auto& name : missingEffects) {
        names.push_back(muse::Val(name));
    }

    muse::UriQuery query("audacity://effects/missing_plugins");
    query.addParam("missingPlugins", muse::Val(names));
    interactive()->openSync(query);
}
}
