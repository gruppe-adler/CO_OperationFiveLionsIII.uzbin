params ["_bodybag", "_unit"];


if (_unit getVariable ["ACE_isUnconscious", false]) then {
    [_unit, _unit] call ace_medical_treatment_fnc_fullHeal;
};

if (isPlayer _unit) then {
    setPlayerRespawnTime 1;
    _unit setDamage 1;
    diag_log "minimissions: respawning player";
};

if (!alive _unit && !isPlayer _unit) then {
    forceRespawn _unit;
    diag_log "minimissions: respawning AI";
};

if (!isNull _bodybag) then {
    _bodybag setVariable ["grad_minimissions_unitName", "", true];
};
