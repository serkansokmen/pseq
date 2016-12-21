//
//  Sequencer.cpp
//  PSEQ
//
//  Created by Serkan Sokmen on 13/06/14.
//
//

#include "Sequencer.h"

//--------------------------------------------------------------
void Sequencer::setup(const ofRectangle rect, int columnCount, int rowCount){
    
    diffTime = 0;
    
    columns = columnCount;
    rows = rowCount;
    
    // Dimensions
    boundingBox.set(rect);
    
    currentStep = 0;
    stepButtonWidth = boundingBox.getWidth() / columns;
    stepButtonHeight = boundingBox.getHeight() / rows;
    
    // Clear and re-assign tracks
    tracks.clear();
    tracks.assign(rows, SequencerTrack());
    
    // Create tracks
    for (int i = 0; i < rows; i++) {
        
        float val = ofMap(i, 0, rows, 0.0f, 255.0f);
        
        tracks[i].setup(i,
                        ofRectangle(boundingBox.getX(),
                                    stepButtonHeight * i,
                                    boundingBox.getWidth(),
                                    stepButtonHeight),
                        columns,
                        ofColor(val, 255, 255));
    }
    
    blobCenters.clear();
};

//--------------------------------------------------------------
void Sequencer::update(int step){
    
    currentStep = step;
    
    for (int trackIndex=0; trackIndex<tracks.size(); trackIndex++){

        tracks[trackIndex].update(step);
        
        for (int cellIndex=0; cellIndex<tracks[trackIndex].cells.size(); cellIndex++){
            
            TrackCell &cell = tracks[trackIndex].cells[cellIndex];
            
            cell.update();
            cell.setState(cellOff);
            
            for(int blobIndex=0; blobIndex<blobCenters.size(); blobIndex++){
                
                if (cell.boundingBox.inside(blobCenters[blobIndex])){
                    if (step == cell.step){
                        cell.setState(cellOn);
                    } else {
                        cell.setState(cellActive);
                    }
                }
            }
        }
    }
};

//--------------------------------------------------------------
void Sequencer::draw(){
    
    ofPushMatrix();
    ofPushStyle();
    
    // Draw scrubber
    ofRectangle scrubberRect(currentStep * stepButtonWidth, 0, stepButtonWidth, stepButtonHeight * rows);
    ofRectangle scrubberRectTop(currentStep * stepButtonWidth, -24, stepButtonWidth, 20);
    ofRectangle scrubberRectBottom(currentStep * stepButtonWidth, stepButtonHeight * rows + 4, stepButtonWidth, 20);
    
    ofNoFill();
    ofSetColor(ofColor::greenYellow, 200);
    ofDrawRectangle(scrubberRectTop);
    ofDrawRectangle(scrubberRectBottom);
    
    ofFill();
    ofSetColor(ofColor::greenYellow, 100);
    ofDrawRectangle(scrubberRect);
    
    ofPopStyle();
    ofPopMatrix();
    
    // Draw tracks
    for (int i=0; i<tracks.size(); i++){
        tracks[i].draw();
    }
};

//--------------------------------------------------------------
void Sequencer::clear(){
    tracks.clear();
    blobCenters.clear();
}

//--------------------------------------------------------------
void Sequencer::setPattern(int pattern[]){
    
    for (int j=0; j<columns; j++) {
        for (int i=0; i<rows; i++){
            if (pattern[i + j * rows] == 0){
                tracks[j].cells[i].setState(cellOff);
            } else {
                tracks[j].cells[i].setState(cellActive);
            }
        }
    }
    
}

