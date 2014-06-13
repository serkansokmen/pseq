//
//  TrackCell.h
//  PSEQ
//
//  Created by Serkan Sokmen on 13/06/14.
//
//

#pragma once

#include "ofMain.h"
#include "ofxTweener.h"


enum TrackCellState {
    cellOff,
    cellActive,
    cellOn,
};


class TrackCell {
    
    ofRectangle     outerBox;
    ofRectangle     innerBox;
    ofPlanePrimitive    plane;
    
    TrackCellState  state;
    float           hue, saturation, brightness;
    ofColor         color;
    float           alpha;
    
public:
    
    void setup(const ofRectangle &boundingBox, int step, const ofColor &color);
    void update();
    void draw();
    
    void setState(TrackCellState s);
    const TrackCellState &getState();
    
    void    setColor(ofColor c);
    ofColor &getColor();
    
    ofRectangle     boundingBox;
    int             step;
};
