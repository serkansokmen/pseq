#pragma once

#include "ofMain.h"
#include "ofxiOS.h"
#include "ofxiOSExtras.h"
#include "ofxOpenCv.h"
#include "ofxXmlSettings.h"
#include "MSABPMTapper.h"

#include "SequencerTheme.h"
#include "Sequencer.h"


using namespace msa;


#define camWidth    480
#define camHeight   360


class ofApp : public ofxiOSApp {
	
    ofRectangle themeRect;
    
    float       drawResizeFactor = 1.68f;
    
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
    void columnsChanged(int &newColumns);
    void rowsChanged(int &newRows);
    
    void saveSettings();
    
    ofVideoGrabber  vidGrabber;
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
    ofParameter<int>        columns;
    ofParameter<int>        rows;
    ofxXmlSettings          settingsXml;
    
    ofParameter<int>        currentThemeId;
    SequencerTheme          *currentTheme;
    vector<SequencerTheme>  themes;
    
    int 		threshold;
    bool		bLearnBackground = true;
    bool        bDebugMode;
    bool        bPlay = true;
};
