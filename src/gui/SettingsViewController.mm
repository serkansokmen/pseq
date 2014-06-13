//
//  SettingsViewController.m
//  PaperSequencer
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)setBPM:(id)sender
{
    UISlider * slider = sender;
    myApp->bpmTapper.setBpm([slider value]);
}

- (IBAction)setThreshold:(id)sender
{
    UISlider * slider = sender;
    myApp->threshold = [slider value];
}

- (IBAction)done:(id)sender
{
    self.view.hidden = YES;
}

- (IBAction)switchTheme:(UISegmentedControl *)sender
{
    UISegmentedControl * segControl = sender;
    myApp->currentThemeId = [segControl selectedSegmentIndex];
}

- (IBAction)clearBackground:(id)sender
{
    myApp->bLearnBackground = true;
}

@end
