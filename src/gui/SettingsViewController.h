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

@property (retain, nonatomic) IBOutlet UISegmentedControl *themeSelector;
@property (retain, nonatomic) IBOutlet UISlider *bpmSlider;
@property (retain, nonatomic) IBOutlet UISlider *thresholdSlider;

- (IBAction)setBPM:(UISlider *)sender;
- (IBAction)setThreshold:(UISlider *)sender;
- (IBAction)done:(UIButton *)sender;
- (IBAction)switchTheme:(UISegmentedControl *)sender;
- (IBAction)clearBackground:(UIButton *)sender;
- (IBAction)togglePlay:(UISwitch *)sender;

@end
