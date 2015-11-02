//
//  FontInfoViewController.m
//
//
//  Created by 张光发 on 15/10/27.
//
//

#import "FontInfoViewController.h"
#import "FavoritesList.h"

@interface FontInfoViewController ()
@property (weak, nonatomic) IBOutlet UILabel* fontSampleLabel;
@property (weak, nonatomic) IBOutlet UISlider* fontSizeSlider;
@property (weak, nonatomic) IBOutlet UILabel* fontSizeLabel;
@property (weak, nonatomic) IBOutlet UISwitch* favoriteSwitch;

@end

@implementation FontInfoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.fontSampleLabel.font = self.font;
    self.fontSampleLabel.text = @"AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz0123456789";
    self.fontSizeSlider.value = self.font.pointSize;
    self.fontSizeLabel.text = [NSString stringWithFormat:@"%0.f", self.font.pointSize];
    self.favoriteSwitch.on = self.favorite;
}
- (IBAction)sliderFontSize:(UISlider*)sender
{
    float newSize = roundf(sender.value);
    self.fontSizeLabel.text = [NSString stringWithFormat:@"%0.f", newSize];
    self.fontSampleLabel.font = [self.font fontWithSize:newSize];
}

- (IBAction)toggleFavorite:(UISwitch*)sender
{
    FavoritesList* favoritesList = [FavoritesList sharedFavoritesList];
    if (sender.on) {
        [favoritesList addFavorite:self.font.fontName];
    }
    else {
        [favoritesList removeFavorite:self.font.fontName];
    }
}

@end
