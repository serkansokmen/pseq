#pragma once

#include "ofMain.h"
#include "ofxiOS.h"
#include "ofxiOSExtras.h"
#include "SequencerTheme.h"
#include "Sequencer.h"
#include "ofxOpenCv.h"
#include "MSABPMTapper.h"


using namespace msa;


class ofApp : public ofxiOSApp {
	
    float       drawResizeFactor = 1.5f;
    int         columns = 4;
    int         rows = 4;
    
    int         lastStep;
    int         totalSteps;
    int         currentStep;
    
public:
    
    ofApp();
    
    void setup();
    void update();
    void draw();
    void exit();
	
    void touchDown(ofTouchEventArgs & touch);
    void touchMoved(ofTouchEventArgs & touch);
    void touchUp(ofTouchEventArgs & touch);
    void touchDoubleTap(ofTouchEventArgs & touch);
    void touchCancelled(ofTouchEventArgs & touch);
    
    void lostFocus();
    void gotFocus();
    void gotMemoryWarning();
    void deviceOrientationChanged(int newOrientation);
    
    void currentThemeIdChanged(int &newThemeId);
    void bpmChanged(float &newBpm);
    
    ofVideoGrabber  vidGrabber;
    ofTexture       vidTexture;
    unsigned char   *pix;
    
    ofxCvColorImage			colorImg;
    ofxCvColorImage         processedImg;
    ofxCvGrayscaleImage 	grayImage;
    ofxCvGrayscaleImage 	grayBg;
    ofxCvGrayscaleImage 	grayDiff;
    ofxCvContourFinder      contourFinder;
    vector<ofPoint>         blobCenters;	// detected objects' centers
    
    // Sequencer
    Sequencer           *currentSequencer;
    vector<Sequencer>   sequencers;
    
    
    BPMTapper       bpmTapper;
    ofFbo           sequencerFbo;
    
    ofParameter<float>      bpm;
    
    ofParameter<int>        currentThemeId;
    SequencerTheme          *currentTheme;
    vector<SequencerTheme>  themes;
    
    int 		threshold;
    bool		bLearnBackground;
    bool        bDebugMode;
};
