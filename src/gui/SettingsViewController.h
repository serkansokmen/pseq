//
//  SettingsViewController.h
//  PSEQ
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
- (IBAction)done:(id)sender;
- (IBAction)switchTheme:(UISegmentedControl *)sender;
- (IBAction)clearBackground:(id)sender;
- (IBAction)togglePlay:(UISwitch *)sender;
- (IBAction)setColumns:(UIStepper *)sender;
- (IBAction)setRows:(UIStepper *)sender;

@end
