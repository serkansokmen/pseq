//
//  SettingsViewController.m
//  PSEQ
//
//  Created by Serkan Sökmen on 13/06/14.
//
//

#import "SettingsViewController.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    myApp = (ofApp*)ofGetAppPtr();
    
    [self.bpmSlider setValue:myApp->bpm];
    [self.thresholdSlider setValue:myApp->threshold];
    [self.themeSelector setSelectedSegmentIndex:myApp->currentThemeId];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)setBPM:(UISlider *)sender
{
    myApp->bpm = [sender value];
}

- (IBAction)setThreshold:(UISlider *)sender
{
    myApp->threshold = [sender value];
}

- (IBAction)done:(id)sender
{
    myApp->saveSettings();
    self.view.hidden = YES;
}

- (IBAction)switchTheme:(UISegmentedControl *)sender
{
    UISegmentedControl * segControl = sender;
    myApp->currentThemeId = [segControl selectedSegmentIndex];
    [self.bpmSlider setValue:myApp->bpm];
}

- (IBAction)clearBackground:(id)sender
{
    myApp->bLearnBackground = true;
}

- (IBAction)togglePlay:(UISwitch *)sender
{
    if ([sender isOn]) {
        myApp->bPlay = true;
        myApp->bpmTapper.startFresh();
    } else {
        myApp->bpmTapper.startFresh();
        myApp->bpmTapper.update();
        myApp->bPlay = false;
    }
}

- (IBAction)setColumns:(UIStepper *)sender
{
    myApp->columns = (int)[sender value];
}

- (IBAction)setRows:(UIStepper *)sender
{
    myApp->rows = (int)[sender value];
}

- (void)dealloc {
    [_bpmSlider release];
    [_themeSelector release];
    [_thresholdSlider release];
    [super dealloc];
}
@end
