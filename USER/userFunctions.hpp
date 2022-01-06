/*
*   Hier können eigene Funktionen eingebunden werden.
*   Ist in CfgFunctions included.
*/

class GRAD_USER {
    tag = "grad_user";
    class customCam {
        file = "USER\customCam";
        class animateTexture {};
        class showIntro {};
    };

    class medicHacks {
        file = "USER\medicHacks";
        class medicEventhandler { postinit = 1; };
    };
};
