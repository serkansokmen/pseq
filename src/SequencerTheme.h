//
//  SequencerTheme.h
//  PSEQ
//
//  Created by Serkan Sokmen on 13/06/14.
//
//

#pragma once


#include "ofMain.h"


class SequencerTheme {
    
public:
    
    void setup(string soundPath, string bgPath);
    
    string      soundPath;
    ofImage     background;
    
    vector<ofSoundPlayer> players;
};
