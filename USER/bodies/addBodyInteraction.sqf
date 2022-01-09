params ["_body", ["_offset", [0,0,0]]];

private _displayName = "Put into bodybag";
private _action = ["grad_minimissions_respawnAction", _displayName, "\A3\ui_f\data\igui\cfg\actions\heal_ca.paa", {
    
    private _position = getPos _target;
    private _dir = getDir _target;
    hideObjectGlobal _target;

    private _bodyBagNew = createVehicle ["Land_Bodybag_01_black_F", [0,0,0], [], 0, "NONE"];
    
    [{ 
            params ["_target"];
            deleteVehicle _target;
    }, [_target], 3] call CBA_fnc_waitAndExecute;

    [_bodyBagNew, 0.1] call ace_cargo_fnc_setSize;
    [_bodyBagNew, true, [0, -0.2, 1.6], 90] remoteExec ["grad_minimissions_fnc_bodyBagSetCarryable", 0, true];
    
    {
            [_x, _bodyBagNew] remoteExecCall ["disableCollisionWith", 0, _x];
            [_x, _bodyBagNew] remoteExecCall ["disableCollisionWith", 0, _bodyBagNew];
    } forEach playableUnits + switchableUnits;

    _bodyBagNew setDir _dir;
    _position set [2,0];
    _bodyBagNew setPos _position;

}, {true}, nil, nil, _offset] call ace_interact_menu_fnc_createAction;
[_body, 0, [], _action] call ace_interact_menu_fnc_addActionToObject;