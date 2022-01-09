params ["_crate"];

clearItemCargoGlobal _crate;
clearBackpackCargoGlobal _crate;
clearWeaponCargoGlobal _crate;
clearMagazineCargoGlobal _crate;


_crate addMagazineCargoGlobal ["rhs_mag_30Rnd_556x45_M855A1_Stanag_Ranger_Tracer_Red", 100];
_crate addMagazineCargoGlobal ["rhsusf_200Rnd_556x45_soft_pouch", 100];

_crate addWeaponCargoGlobal ["rhs_weap_rpg75", 4];

_crate addMagazineCargoGlobal ["1Rnd_SmokeRed_Grenade_shell", 10];
_crate addMagazineCargoGlobal ["1Rnd_SmokeGreen_Grenade_shell", 10];
_crate addMagazineCargoGlobal ["1Rnd_SmokeBlue_Grenade_shell", 10];

_crate addMagazineCargoGlobal ["HandGrenade", 10];
_crate addMagazineCargoGlobal ["SmokeShell", 10];


_crate addBackpackCargoGlobal ["UK3CB_B_B_Radio_Backpack", 10];
