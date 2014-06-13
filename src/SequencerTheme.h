//
//  SequencerTheme.h
//  BodySequencer
//
//  Created by Serkan Sokmen on 17.09.2013.
//
//

#pragma once


#include "ofMain.h"


class SequencerTheme {
    
public:
    
    void setup(string soundPath, float bpm, const ofRectangle &rect, string bgPath);
    
    string      soundPath;
    float       bpm;
    ofRectangle gridRect;
    ofImage     background;
    
    vector<ofSoundPlayer> players;
};
