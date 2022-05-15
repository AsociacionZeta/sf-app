import StrUtils from "c/classStrUtils";

const DURATION_UNITS = {
    "Y": 8 * 60 * 365,
    "M": 8 * 60 * 30,
    "W": 8 * 60 * 7,
    "d": 8 * 60,
    "h": 60,
    "m": 1
}

export default class DateTimeUtils {

    static minutesToDurationString(minutes, skipZeroValues) {
        if (!minutes)
            return '';
        const result = []
        for (var name in DURATION_UNITS) {
            var p = Math.floor(minutes / DURATION_UNITS[name]);
            if(p === 0){
                if(!skipZeroValues)
                    result.push(p + name);
            } else {
                result.push(p + name);
            }
            minutes %= DURATION_UNITS[name]
        }
        return result.join(' ');
    }

    static durationStringToMinutes(duration) {
        if (!duration)
            return 0;
        const splits = duration.split(' ');
        const units = Object.keys(DURATION_UNITS);
        let minutes = 0;
        for(const split of splits){
            for(const unit of units){
                if(StrUtils.contains(split, unit)){
                    const value = Number(StrUtils.replace(split, unit, '').trim());
                    minutes += (value * DURATION_UNITS[unit]);
                }
            }
        }
        return minutes;
    }

}