//
//  SettingsViewController.h
//  PaperSequencer
//
//  Created by Serkan Sökmen on 13/06/14.
//
//

#import <UIKit/UIKit.h>

#include "ofApp.h"


@interface SettingsViewController : UIViewController {
    ofApp *myApp;
}

- (IBAction)setBPM:(id)sender;
- (IBAction)setThreshold:(id)sender;
- (IBAction)done:(id)sender;
- (IBAction)switchTheme:(UISegmentedControl *)sender;
- (IBAction)clearBackground:(id)sender;

@end
