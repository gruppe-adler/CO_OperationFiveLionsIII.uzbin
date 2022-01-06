["ace_cardiacArrest", {
    params ["_unit", "_active"];

    if (_unit != ACE_player) exitWith {};

    if (_active) then {

        if (random 2 > 1) then { 
            private _bodybag = ACE_player getVariable ["grad_bodybag_object", objNull];
            [_bodybag, ACE_player] call grad_minimissions_fnc_respawnPlayer;
        };
    };
}] call CBA_fnc_addEventHandler;


/*

["ace_unconscious", {
    params ["_unit", "_unconscious"];

    if (_unit != ACE_player) exitWith {};
    if (!_unconscious) exitWith {}; // apply only for entering uncon state
    
    // wait 100ms to override vanilla ace changes
    [{

        [] call grad_ace_medical_feedback_fnc_enterEffect;

    }, [], 0.1] call CBA_fnc_waitAndExecute;
    
}] call CBA_fnc_addEventHandler;

*/


// enable spectator during cardiac arrest
/*
["ace_cardiacArrest", {
    params ["_unit", "_active"];

    if (_unit != ACE_player) exitWith {};

    if (_active) then {

        grad_cardiacArrest = true;

        ace_common_OldIsCamera = true; // magic - disables ace medical feedback effects

        ACE_player setVariable ["tf_voiceVolume", 0, true];
        ACE_player setVariable ["tf_globalVolume", 0];

        #define VOLUME_SPECTATOR 1
        private _volume = missionNamespace getVariable ["ACE_hearing_unconsciousnessVolume", VOLUME_SPECTATOR];
        ["medical_feedback", _volume, true] call ace_common_fnc_setHearingCapability;

        ["Initialize", [player, [playerside], false, true, true, true, true, true, true, true]] call BIS_fnc_EGSpectator;

        [{
            ace_common_OldIsCamera = true;
            ["unconscious", false] call ace_common_fnc_setDisableUserInputStatus; // allow controls
        }, [], 0.1] call CBA_fnc_waitAndExecute;

        [{
            alive ACE_player || !grad_cardiacArrest
        },{
            ["Terminate"] call BIS_fnc_EGSpectator;
            ace_common_OldIsCamera = false; // magic - enables ace medical feedback effects
        }] call CBA_fnc_waitUntilAndExecute;
    } else {
        grad_cardiacArrest = false;
    };

}] call CBA_fnc_addEventHandler;
*/

grad_ace_medical_feedback_fnc_enterEffect = {
    #define MUTED_LEVEL 0.5
    #define VOICE_LEVEL 0.5
    // Vanilla Game
    2 fadeSound MUTED_LEVEL;

    // TFAR
    ACE_player setVariable ["tf_voiceVolume", VOICE_LEVEL, true];
    ACE_player setVariable ["tf_globalVolume", MUTED_LEVEL];
    ACE_player setVariable ["tf_unable_to_use_radio", true];

    // ACRE2
    if (!isNil "acre_api_fnc_setGlobalVolume") then { [MUTED_LEVEL^0.33] call acre_api_fnc_setGlobalVolume; };
    ACE_player setVariable ["acre_sys_core_isDisabled", true, true];


     // Greatly reduce player's hearing ability while unconscious (affects radio addons)
    #define VOLUME_UNCONSCIOUS 0.5
    private _volume = missionNamespace getVariable ["ACE_hearing_unconsciousnessVolume", VOLUME_UNCONSCIOUS];
    ["medical_feedback", _volume, _unconscious] call ace_common_fnc_setHearingCapability;


    // [_unconscious, 1] call ace_medical_feedback_fnc_effectUnconscious;
    // this needs to run every frame sadly, as ace resets everything if ace_common_OldIsCamera is true
    [grad_ace_medical_feedback_fnc_handleEffects, 0, false] call CBA_fnc_addPerFrameHandler;

    [{
        ["unconscious", false] call ace_common_fnc_setDisableUserInputStatus; // allow controls
    }, [], 0.1] call CBA_fnc_waitAndExecute;
};


// ripped from ace3/baermitumlaut
grad_ace_medical_feedback_fnc_handleEffects = {

    params [["_manualUpdate", false]];

    #include "\z\ace\addons\medical_feedback\script_component.hpp"
    #include "\A3\Functions_F_Exp_A\EGSpectatorCommonDefines.inc"

    if (missionNamespace getVariable VAR_INITIALIZED) exitWith {
        [_thisEventhandler] call CBA_fnc_removePerFrameHandler;
    };

    // - Current state info -------------------------------------------------------
    private _bleedingStrength = GET_BLOOD_LOSS(ACE_player);
    private _bloodVolume      = GET_BLOOD_VOLUME(ACE_player);
    private _unconscious      = true;
    private _heartRate        = GET_HEART_RATE(ACE_player);
    private _pain             = GET_PAIN_PERCEIVED(ACE_player);

    if ((!ace_medical_feedback_heartBeatEffectRunning) && {_heartRate != 0} && {(_heartRate > 160) || {_heartRate < 60}}) then {
        TRACE_1("Starting heart beat effect",_heartRate);
        ace_medical_feedback_heartBeatEffectRunning = true;
        [] call ace_medical_feedback_fnc_effectHeartBeat;
    };

    // - Visual effects -----------------------------------------------------------
    // disable black screen
    // [_unconscious, 2] call ace_medical_feedback_fnc_effectUnconscious;
    [
        true,
        linearConversion [BLOOD_VOLUME_CLASS_2_HEMORRHAGE, BLOOD_VOLUME_CLASS_4_HEMORRHAGE, _bloodVolume, 0, 1, true]
    ] call ace_medical_feedback_fnc_effectBloodVolume;
    [
        true,
        ceil linearConversion [
            BLOOD_VOLUME_CLASS_2_HEMORRHAGE, BLOOD_VOLUME_CLASS_4_HEMORRHAGE,
            _bloodVolume,
            ICON_BLOODVOLUME_IDX_MIN, ICON_BLOODVOLUME_IDX_MAX, true
        ]
    ] call ace_medical_feedback_fnc_effectBloodVolumeIcon;

    [!_unconscious, _pain] call ace_medical_feedback_fnc_effectPain;
    [!_unconscious, _bleedingStrength, _manualUpdate] call ace_medical_feedback_fnc_effectBleeding;

    // - Tourniquets, fractures and splints indication ---------------------------------------
    if (GVAR(enableHUDIndicators)) then {
        [] call ace_medical_feedback_fnc_handleHUDIndicators;
    };

};
