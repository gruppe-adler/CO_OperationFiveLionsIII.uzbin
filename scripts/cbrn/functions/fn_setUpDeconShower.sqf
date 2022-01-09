params ["_shower"];

if (local _shower) then {
    _shower setVariable ["cbrn_water", 120000, true];
};

if !(hasInterface) exitWith {};

_shower setVariable ["BIN_deconshower_disableAction", true];

private _action = ["cbrn_turn_on", "Turn on","",{
    ["cbrn_turnOnShower", [_target]] call cba_fnc_globalEvent;
    _target setVariable ["cbrn_starTime", cba_missionTime];
    _target setVariable ["cbrn_on", true, true];
    private _remainingWater = _target getVariable ["cbrn_water", 120];

    private _sound_1 = "SoundSetSource_Sfx_DeconShower_Nozzle_01" createVehicle [0,0,0];
    private _sound_2 = "SoundSetSource_Sfx_DeconShower_Center_01" createVehicle [0,0,0];
    _sound_1 attachTo [_target, [0,0,0]];
    _sound_2 attachTo [_target, [0,0,0]];

    _target setVariable ["cbrn_showerSounds", [_sound_1, _sound_2], true];

    [{!(_this getVariable ["cbrn_on", false])}, {}, _target, _remainingWater, {
        ["cbrn_turnOffShower", [_this]] call cba_fnc_globalEvent;
        _this setVariable ["cbrn_water", 0, true];
        _this setVariable ["cbrn_on", false, true];
    }] call CBA_fnc_waitUntilAndExecute;
},{
    !(_target getVariable ["cbrn_on", false]) && {(_target getVariable ["cbrn_water", 120]) > 0}
},{},[], [0,0,0], 5] call ace_interact_menu_fnc_createAction;
[_shower, 0, ["ACE_MainActions"], _action] call ace_interact_menu_fnc_addActionToObject;


_action = ["cbrn_turn_off", "Turn off","",{
    ["cbrn_turnOffShower", [_target]] call cba_fnc_globalEvent;
    private _diff = cba_missionTime - (_target getVariable ["cbrn_starTime", cba_missionTime]);
    private _waterRemaining = ((_target getVariable ["cbrn_water", 120]) - _diff) max 0;
    _target setVariable ["cbrn_water", _waterRemaining, true];
    _target setVariable ["cbrn_on", false, true];
    private _sounds = _target getVariable ["cbrn_showerSounds", []];
    {
        detach _x;
        deleteVehicle _x;
    } forEach _sounds;
},{
    _target getVariable ["cbrn_on", false]
},{},[], [0,0,0], 5] call ace_interact_menu_fnc_createAction;
[_shower, 0, ["ACE_MainActions"], _action] call ace_interact_menu_fnc_addActionToObject;
