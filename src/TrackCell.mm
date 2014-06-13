//
//  TrackCell.cpp
//  TUIOSequencer
//
//  Created by Serkan Sokmen on 31.07.2013.
//
//

#include "TrackCell.h"


//--------------------------------------------------------------
void TrackCell::setup(const ofRectangle &bb, int s, const ofColor &c){
    
    float padding = 8.0f;
    
    step = s;
    
    hue = c.getHue();
    saturation = c.getSaturation();
    brightness = 255;
    
    state = cellOff;
    color.set(hue, saturation, brightness);
    
    boundingBox.set(bb);
    outerBox.setFromCenter(boundingBox.getCenter(), boundingBox.getWidth() - padding*.2, boundingBox.getHeight() - padding*.2);
    innerBox.setFromCenter(boundingBox.getCenter(), boundingBox.getWidth() - padding, boundingBox.getHeight() - padding);
    
    // Setup plane
    float planeScale = 0.75;
    int planeWidth = bb.getWidth() * planeScale;
    int planeHeight = bb.getHeight() * planeScale;
    int planeGridSize = 10;
    int planeColums = planeWidth / planeGridSize;
    int planeRows = planeHeight / planeGridSize;
    
#ifdef USE_CELL_SHADER
#ifdef TARGET_OPENGLES
    shader.load("shadersES2/trackcell");
#else
    if(ofIsGLProgrammableRenderer()){
        shader.load("shadersGL3/trackcell");
    }else{
        shader.load("shadersGL2/trackcell");
    }
#endif
    
    plane.set(planeWidth, planeHeight, planeColums, planeRows, OF_PRIMITIVE_TRIANGLES);
#endif
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
            ofRect(innerBox);
            ofPopStyle();
            break;
        case cellActive:
            ofPushStyle();
            ofSetColor(color, alpha);
            ofRect(innerBox);
            ofPopStyle();
            break;
        case cellOn:
            ofPushStyle();
            ofSetColor(color, alpha);
            ofRect(innerBox);
            ofPopStyle();
            break;
            
        default:
            break;
    }
#ifdef USE_CELL_SHADER
    shader.begin();
    ofPushMatrix();
    ofTranslate(boundingBox.getX() + boundingBox.getWidth()*.5, boundingBox.getY() + boundingBox.getHeight()*.5);
    plane.draw();
    ofPopMatrix();
    shader.end();
#endif
};

//--------------------------------------------------------------
void TrackCell::setState(TrackCellState s){
    
    state = s;
    
    switch (state) {
        case cellOff:
            Tweener.addTween(alpha, 50, .2);
            break;
        case cellActive:
            Tweener.addTween(alpha, 150, .2);
            break;
        case cellOn:
            Tweener.addTween(alpha, 255, .2);
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
    Tweener.addTween(hue, c.getHue(), .2);
    Tweener.addTween(saturation, c.getSaturation(), .2);
}

//--------------------------------------------------------------
ofColor &TrackCell::getColor(){
    return color;
}
