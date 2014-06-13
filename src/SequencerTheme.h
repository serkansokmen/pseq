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
    
    void setup(string soundPath, const ofRectangle &rect, string bgPath);
    
    string      soundPath;
    ofRectangle gridRect;
    ofImage     background;
    
    vector<ofSoundPlayer> players;
};
