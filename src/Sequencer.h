//
//  Sequencer.h
//  PSEQ
//
//  Created by Serkan Sokmen on 13/06/14.
//
//

#pragma once

#include "ofMain.h"
#include "SequencerTrack.h"


using namespace std;


class Sequencer {
    
    ofRectangle         boundingBox;
    
    float               stepButtonWidth;
    float               stepButtonHeight;
    int                 columns;
    int                 rows;
    
    float               aTimer, diffTime;
    int                 bpm;
    int                 currentStep;
    
public:
    
    void setup(const ofRectangle rect, int columns, int rows);
    void update(int step);
    void draw();
    void clear();
    
    const ofRectangle   &getBoundingBox() { return boundingBox; };
    void                setStep(int val)  { currentStep = val; };
    int                 getStep()         { return currentStep; };
    
    void setPattern(int pattern[]);
    
    vector<SequencerTrack>  tracks;
    vector<ofPoint>         blobCenters;
};
