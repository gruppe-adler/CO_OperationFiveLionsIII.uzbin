if (!hasInterface) exitWith {};

["GRAD_electricFence_sparkSmall", {
    params ["_position"];
    
    if (!isGameFocused || isGamePaused) exitWith {}; // stop multi firing

    [_position] execVM "user\switch\sparkLocal.sqf";

}] call CBA_fnc_addEventHandler;
