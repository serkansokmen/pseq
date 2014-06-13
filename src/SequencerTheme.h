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
    
    void setup(string soundPath, const ofRectangle &rect, string bgPath);
    
    string      soundPath;
    ofRectangle gridRect;
    ofImage     background;
    
    vector<ofSoundPlayer> players;
};
