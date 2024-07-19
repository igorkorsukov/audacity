/*
* Audacity: A Digital Audio Editor
*/
#ifndef AU_PROJECTSCENE_TRACKTYPES_H
#define AU_PROJECTSCENE_TRACKTYPES_H

#include "qobjectdefs.h"

#include "processing/processingtypes.h"

namespace au::projectscene {
class TrackTypes
{
    Q_GADGET

public:
    //! NOTE: must be in sync with au::processing::TrackType
    enum class Type {
        UNDEFINED = 0,
        MONO,
        STEREO,
        LABEL
    };
    Q_ENUM(Type)
};

class ClipKey
{
    Q_GADGET
public:

    ClipKey() = default;
    ClipKey(const processing::ClipKey& k)
        : key(k) {}

    processing::ClipKey key;
};

class ClipTime
{
    Q_GADGET
public:

    ClipTime() = default;

    processing::secs_t clipStartTime = 0.0;
    processing::secs_t clipEndTime = 0.0;

    processing::secs_t clipVisibleStartTime = 0.0;
    processing::secs_t clipVisibleEndTime = 0.0;

    inline bool operator==(const ClipTime& other) const
    {
        return clipStartTime == other.clipStartTime
               && clipEndTime == other.clipEndTime
               && clipVisibleStartTime == other.clipVisibleStartTime
               && clipVisibleEndTime == other.clipVisibleEndTime;
    }

    inline bool operator!=(const ClipTime& other) const { return !this->operator==(other); }
};

class VerticalRulerTypes
{
    Q_GADGET
public:
    enum class Type {
        LINEAR_AMP = 0,
        LOGARITHMIC_DB,
        LINEAR_DB
    };
    Q_ENUM(Type)
};

enum class SnapType {
    Bar,

    Half,
    Quarter,
    Eighth,
    Sixteenth,
    ThirtySecond,
    SixtyFourth,
    HundredTwentyEighth,

    Seconds,
    Deciseconds,
    Centiseconds,
    Milliseconds,
    Samples,

    FilmFrames,
    NTSCFrames,
    NTSCFramesDrop,
    PALFrames,

    CDDAFrames
};
}

enum class TimelineRulerMode {
    MINUTES_AND_SECONDS = 0,
    BEATS_AND_MEASURES
};

#endif // AU_PROJECTSCENE_TRACKTYPES_H
