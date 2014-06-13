#include "ofMain.h"
#include "ofApp.h"

int main(){
    
    ofAppiOSWindow * iOSWindow = new ofAppiOSWindow();
    iOSWindow->enableRetina();
    iOSWindow->enableHardwareOrientation();
    iOSWindow->enableOrientationAnimation();
    iOSWindow->enableRendererES2();
    ofSetupOpenGL(iOSWindow, 480, 320, OF_FULLSCREEN);
    ofRunApp(new ofApp());
}
