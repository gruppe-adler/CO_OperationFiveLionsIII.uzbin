params ["_args", "_idPFH"];
_args params ["_lastIteration"];
private _player = ace_player;
private _zones = _player getVariable ["cbrn_zones", []];
private _max = 0;
if (alive _player && {!(_zones isEqualTo [])}) then {
    private _zone = objNull;
    private _size = 0;
    private _threatLevel = 0;
    private _falloffArea = 0;
    private _dist = 0;
    {
        _threatLevel = _x getVariable ["cbrn_threatLevel", 0];
        if (_max < _threatLevel) then {
            _size = _x getVariable ["cbrn_size", 0];
            _dist = _player distance2D _x;
            if( _dist > _size) then {
                _falloffArea = _x getVariable ["cbrn_falloffArea", 0];
                _threatLevel = linearConversion [_size + _falloffArea, _size, _dist, 0 , _threatLevel];
            };

            _max = _max max _threatLevel;
        };
    } forEach _zones;
};
private _time = cba_missiontime;
private _delta = _time - _lastIteration;
_args set [0, _time];
[_player, _max, _delta] call cbrn_fnc_handleDamage;


// private _dir = (linearConversion [0, 4, _max - 0.05 + (random 0.1), 90, -90, true]) mod 360;

if (visibleWatch && "ChemicalDetector_01_watch_F" in assignedItems player) then {
    private _output = _max - 0.05 + (random 0.1);
    if (_output < 0.01) then {
        _output = 0.00;
    };
    private _ui = uiNamespace getVariable "RscWeaponChemicalDetector";
    private _obj = _ui displayCtrl 101;

    _obj ctrlAnimateModel ["Threat_Level_Source", _output, true];

    private _count = 1 max linearConversion [0, 1, _max, 0.5, 10, true];

    // if (_max < 1 && random 1 > 0.2) exitWith {};
    // if (_max < 2 && random 1 > 0.5) exitWith {};
    // if (_max < 3 && random 1 > 0.8) exitWith {};

    for "_i" from 1 to _count do {
        [{
            params ["_max"];
            private _soundPick = selectRandom [1,2,3,4];
            private _soundStrength = 1;
            if (_max > 1) then {
                _soundStrength = selectRandom [1,2];
            };
            if (_max > 2) then {
                _soundStrength = selectRandom [2,3];
            };
            if (_max > 3) then {
                _soundStrength = selectRandom [3,4];
            };
            
            private _string = format ["geiger_%1_%2", _soundStrength, _soundPick];
            // diag_log format ["soundstring %1", _string];
            playSound _string;
        }, [_max], ((_count/_i)*0.45) + random 0.1] call CBA_fnc_waitAndExecute;
    };
};
/*
if (_player getVariable ["cbrn_using_threat_meter", false]) then {
    if (isNull (uiNamespace getVariable ["cbrn_threatBaseCtrl", objNull])) then {
        private _display = findDisplay 46;
        if (isNull _display) exitWith {};
        private _pos = [0.5 - ((256 * pixelW) / 2),safeZoneY,256 * pixelW, 256 * pixelH];
        private _ctrl = _display ctrlCreate ["RscPicture", 753];
        _ctrl ctrlSetPosition _pos;
        _ctrl ctrlSetBackgroundColor [1,1,1,0.5];
        _ctrl ctrlSetText "scripts\cbrn\images\threatmetercolours.paa";
        _ctrl ctrlSetTextColor [1,1,1,1];
        _ctrl ctrlCommit 0;
        uiNamespace setVariable ["cbrn_threatBaseCtrl", _ctrl];

        _ctrl = _display ctrlCreate ["RscPicture", 755];
        _ctrl ctrlSetPosition [0.5 - ((256 * pixelW) / 2),safeZoneY - ((256 * pixelH) / 2),256 * pixelW, 256 * pixelH];
        _ctrl ctrlSetBackgroundColor [1,1,1,1];
        _ctrl ctrlSetText "scripts\cbrn\images\needle.paa";
        _ctrl ctrlSetTextColor [1,1,1,1];
        _ctrl ctrlCommit 0;
        uiNamespace setVariable ["cbrn_threatNeedleCtrl", _ctrl];

        _ctrl = _display ctrlCreate ["RscPicture", 755];
        _ctrl ctrlSetPosition _pos;
        _ctrl ctrlSetBackgroundColor [1,1,1,1];
        _ctrl ctrlSetText "scripts\cbrn\images\threatmeteroverlay.paa";
        _ctrl ctrlSetTextColor [1,1,1,1];
        _ctrl ctrlCommit 0;
        uiNamespace setVariable ["cbrn_threatOverlayCtrl", _ctrl];
    };
    private _needle = uiNamespace getVariable ["cbrn_threatNeedleCtrl", ctrlNull];
    private _dir = (linearConversion [0, 4, _max - 0.05 + (random 0.1), 90, -90, true]) mod 360;
    _needle ctrlSetAngle [_dir, 0.5, 0.5];

    private _count = linearConversion [0, 4, _max, 0.1, 20, true];
    for "_i" from 1 to _count do {
        [{
            params ["_max"];
            private _sound = selectRandom [1,2,3,4];
            playSound format ["geiger_%1_%2", ceil _max, _sound];
        }, [_max], ((_count/_i)*0.4) + random 0.1] call CBA_fnc_waitAndExecute;
    };

} else {
    ctrlDelete (uiNamespace getVariable ["cbrn_threatBaseCtrl", ctrlNull]);
    ctrlDelete (uiNamespace getVariable ["cbrn_threatNeedleCtrl", ctrlNull]);
    ctrlDelete (uiNamespace getVariable ["cbrn_threatOverlayCtrl", ctrlNull]);
};
*/