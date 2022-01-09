params ["_switch"];


// local on every client
_switch addAction
[
    "Turn On",
    {
        params ["_target", "_caller", "_actionId", "_arguments"];

        _target setVariable ['switchUsable', false, true];

        _target animateSource ["Power_1", 1];
        _target animateSource ["Power_2", 1];
        _target animateSource ["SwitchLight", 0];
        _target animateSource ["SwitchPosition", 1];
    },
    nil,
    1.5,
    true,
    true,
    "",
    "_target getVariable ['switchUsable', true];",
    10,
    false,
    "",
    ""
];

// server loops sparks
if (isServer) then {
    

    [{
        params ["_args", "_handle"];
        _args params ["_switch"];

        if (!(_target getVariable ['switchUsable', true])) exitWith {
            [_handle] call CBA_fnc_removePerFrameHandler;
        };

        ["GRAD_electricFence_sparkSmall", [position sparkWire]] call CBA_fnc_globalEvent;

    }, 1, [_switch]] call CBA_fnc_addPerFramehandler;
};