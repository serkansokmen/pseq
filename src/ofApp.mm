#include "ofApp.h"
#include "SettingsViewController.h"


#define camWidth    480
#define camHeight   360


SettingsViewController *settingsViewController;


//--------------------------------------------------------------
ofApp::ofApp(){
    currentTheme = new SequencerTheme();
    currentSequencer = new Sequencer();
}

//--------------------------------------------------------------
void ofApp::setup(){
    
    ofSetOrientation(OF_ORIENTATION_90_RIGHT );
    // ofSetVerticalSync(true);
    ofBackground(ofColor::black);
    ofSetFrameRate(30);
    // ofSetLogLevel(OF_LOG_NOTICE);
    
    vidGrabber.initGrabber(camWidth, camHeight, OF_PIXELS_BGRA);
	vidTexture.allocate(camWidth, camHeight, GL_RGB);
    colorImg.allocate(camWidth, camHeight);
    grayImage.allocate(camWidth, camHeight);
    processedImg.allocate(camWidth, camHeight);
	
	pix = new unsigned char[ (int)(camWidth * camHeight * 3.0) ];
    
    bLearnBackground = true;
    threshold = 80;
    
    // Setup Tweener
    Tweener.setMode(TWEENMODE_OVERRIDE);
    
    currentThemeId.addListener(this, &ofApp::currentThemeIdChanged);
    bpm.addListener(this, &ofApp::bpmChanged);
    
    // Initialize Themes
    themes.assign(2, SequencerTheme());
    ofRectangle themeRect;
    themeRect.setFromCenter(0,
                            0,
                            camWidth,
                            camHeight);
    
    themes[0].setup("themes/pack_1/sounds/",
                    224.0f,
                    themeRect,
                    "themes/pack_1/images/interface.png");
    themes[1].setup("themes/pack_2/sounds/",
                    192.0f,
                    themeRect,
                    "themes/pack_2/images/interface.png");
    
    // Initialize Sequencer
    sequencers.assign(2, Sequencer());
    sequencers[0].setup(themes[0].gridRect, columns, rows);
    sequencers[1].setup(themes[1].gridRect, columns, rows);
    
    currentThemeId = 1;
    
    // Set initial values
    totalSteps = columns;
    currentStep = 0;
    lastStep = 0;
    
    settingsViewController = [[SettingsViewController alloc]
                              initWithNibName:@"SettingsViewController" bundle:nil];
    [ofxiOSGetGLParentView() addSubview:settingsViewController.view];
    [settingsViewController.view setHidden:YES];
}

//--------------------------------------------------------------
void ofApp::update(){
    
    vidGrabber.update();
    
    unsigned char * src = vidGrabber.getPixels();
	int totalPix = vidGrabber.getWidth() * vidGrabber.getHeight() * 3;
	
	for(int k = 0; k < totalPix; k+= 3){
		pix[k  ] = src[k];
		pix[k+1] = src[k+1];
		pix[k+2] = src[k+2];
	}
    
    vidTexture.loadData(pix, vidGrabber.getWidth(), vidGrabber.getHeight(), GL_RGB);
    
    if (vidGrabber.isFrameNew()){
        
        colorImg.setFromPixels(pix, vidGrabber.getWidth(), vidGrabber.getHeight());
        processedImg = colorImg;
        
        // Convert to grayscale
        grayImage = colorImg;
        
        if (bLearnBackground) {
            grayBg = grayImage;
            bLearnBackground = false;
        }
        
        grayDiff.absDiff(grayBg, grayImage);
        grayDiff.threshold(threshold);
        
        // Find contours
        contourFinder.findContours(grayDiff, 20, camWidth*camHeight/2, 10, false);
        
        // Store objects' centers
        vector<ofxCvBlob> &blobs = contourFinder.blobs;
        int n = blobs.size();
        blobCenters.resize(n);
        for (int i=0; i<n; i++) {
            blobCenters[i] = blobs[i].centroid;
        }
        
        for (int i=0; i<sequencers.size(); i++) {
            sequencers[i].blobCenters = blobCenters;
        }
	}
    
    // Update Tweener
    Tweener.update();
    
    // Update bpm
    bpmTapper.update();
    currentStep = (int)bpmTapper.beatTime() % totalSteps;
    if (currentStep > totalSteps){
        currentStep = 0;
    }
    
    // Update sequencer
    currentSequencer->update(currentStep);
    
    // Check on/off states and play cell sound
    for (int i=0; i<currentSequencer->tracks.size(); i++) {
        SequencerTrack *track = &currentSequencer->tracks[i];
        if (track->cells[currentStep].getState() != cellOff && lastStep != currentStep){
            int j = currentStep + i * columns;
            if (themes[currentThemeId].players[j].isLoaded())
                themes[currentThemeId].players[j].play();
        }
    }
    lastStep = currentStep;
    
    sequencerFbo.begin();
    ofClear(255);
    currentSequencer->draw();
    sequencerFbo.end();
}

//--------------------------------------------------------------
void ofApp::draw(){
    
	ofBackground(ofColor::black);
    
    // Draw background
    currentTheme->background.draw(0, 0, ofGetWidth(), ofGetHeight());
    
    ofPushMatrix();
    ofTranslate((ofGetWidth()-camWidth*drawResizeFactor)/2, (ofGetHeight()-camHeight*drawResizeFactor)/2);
    ofTranslate(115, 0);
    ofScale(drawResizeFactor, drawResizeFactor);
    if (settingsViewController.view.hidden) {
        ofSetColor(255, 50);
        grayImage.draw(0, 0, camWidth, camHeight);
        ofSetColor(200, 100);
        grayDiff.draw(0, 0, camWidth, camHeight);
    } else {
        // processedImg.draw(0, 0, camWidth, camHeight);
        ofSetColor(255, 50);
        grayImage.draw(0, 0, camWidth, camHeight);
        ofSetColor(200, 100);
        grayDiff.draw(0, 0, camWidth, camHeight);
    }
    ofSetColor(255, 255);
    contourFinder.draw(0, 0, camWidth, camHeight);
    
    // Draw sequencer
    sequencerFbo.draw(0, 0);
    ofPopMatrix();
}

//--------------------------------------------------------------
void ofApp::exit(){
    
    currentThemeId.removeListener(this, &ofApp::currentThemeIdChanged);
    bpm.removeListener(this, &ofApp::bpmChanged);
    
    //    ofxRemoveTSPSListeners(this);
    themes.clear();
    
    currentTheme = 0;
    currentSequencer = 0;
    
    delete currentTheme;
    delete currentSequencer;
}

//--------------------------------------------------------------
void ofApp::touchDown(ofTouchEventArgs & touch){

}

//--------------------------------------------------------------
void ofApp::touchMoved(ofTouchEventArgs & touch){

}

//--------------------------------------------------------------
void ofApp::touchUp(ofTouchEventArgs & touch){

}

//--------------------------------------------------------------
void ofApp::touchDoubleTap(ofTouchEventArgs & touch){
    
    if( settingsViewController.view.hidden ){
		settingsViewController.view.hidden = NO;
        
        NSTimeInterval animationDuration = 200;
        CGRect newFrameSize = CGRectMake(0, 0, ofGetWidth()/2, ofGetHeight()/2);
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:animationDuration];
        settingsViewController.view.frame = newFrameSize;
        [UIView commitAnimations];
        
	}
    bLearnBackground = true;
    
}

//--------------------------------------------------------------
void ofApp::touchCancelled(ofTouchEventArgs & touch){
    
}

//--------------------------------------------------------------
void ofApp::lostFocus(){

}

//--------------------------------------------------------------
void ofApp::gotFocus(){

    bLearnBackground = true;
    
}

//--------------------------------------------------------------
void ofApp::gotMemoryWarning(){

}

//--------------------------------------------------------------
void ofApp::deviceOrientationChanged(int newOrientation){
    bLearnBackground = true;
}


#pragma mark - ofParameter Event Listeners

//--------------------------------------------------------------
void ofApp::currentThemeIdChanged(int &newThemeId){
    
    currentTheme = &themes[newThemeId];
    currentSequencer = &sequencers[newThemeId];
    
    // Allocate draw FBO
    sequencerFbo.allocate(currentTheme->gridRect.getWidth(), currentTheme->gridRect.getHeight());
    sequencerFbo.begin();
    ofClear(0, 0, 0, 0);
    sequencerFbo.end();
    
    bpmTapper.setBpm(currentTheme->bpm);
}

//--------------------------------------------------------------
void ofApp::bpmChanged(float &newBpm){
    bpmTapper.setBpm(newBpm);
}