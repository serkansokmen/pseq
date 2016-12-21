//
//  TrackCell.cpp
//  PSEQ
//
//  Created by Serkan Sokmen on 13/06/14.
//
//

#include "TrackCell.h"


//--------------------------------------------------------------
void TrackCell::setup(const ofRectangle &bb, int s, const ofColor &c){
    
    float padding = 4.0f;
    
    step = s;
    
    hue = c.getHue();
    saturation = c.getSaturation();
    brightness = 255;
    
    state = cellOff;
    color.set(hue, saturation, brightness);
    
    boundingBox.set(bb);
    outerBox.setFromCenter(boundingBox.getCenter(),
                           boundingBox.getWidth() - padding*.2,
                           boundingBox.getHeight() - padding*.2);
    innerBox.setFromCenter(boundingBox.getCenter(),
                           boundingBox.getWidth() - padding,
                           boundingBox.getHeight() - padding);
}

//--------------------------------------------------------------
void TrackCell::update(){
    color.set(hue, saturation, brightness);
}

//--------------------------------------------------------------
void TrackCell::draw(){
    
    switch (state) {
        case cellOff:
            ofPushStyle();
            ofSetColor(color, 255);
            ofNoFill();
            ofDrawRectangle(innerBox);
            ofPopStyle();
            break;
        case cellActive:
            ofPushStyle();
            ofSetColor(color, alpha);
            ofDrawRectangle(innerBox);
            ofPopStyle();
            break;
        case cellOn:
            ofPushStyle();
            ofSetColor(color, alpha);
            ofDrawRectangle(innerBox);
            ofPopStyle();
            break;
            
        default:
            break;
    }
};

//--------------------------------------------------------------
void TrackCell::setState(TrackCellState s){
    
    state = s;
    
    switch (state) {
        case cellOff:
//            Tweener.addTween(alpha, 50, .2);
            alpha = 50;
            break;
        case cellActive:
//            Tweener.addTween(alpha, 150, .2);
            alpha = 150;
            break;
        case cellOn:
//            Tweener.addTween(alpha, 255, .2);
            alpha = 255;
            break;
            
        default:
            break;
    }
}

//--------------------------------------------------------------
const TrackCellState &TrackCell::getState(){
    return state;
}

//--------------------------------------------------------------
void TrackCell::setColor(ofColor c){
//    Tweener.addTween(hue, c.getHue(), .2);
//    Tweener.addTween(saturation, c.getSaturation(), .2);
    hue = c.getHue();
    saturation = c.getSaturation();
}

//--------------------------------------------------------------
ofColor &TrackCell::getColor(){
    return color;
}
