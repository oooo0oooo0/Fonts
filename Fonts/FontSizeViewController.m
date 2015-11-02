//
//  FontSizeViewController.m
//
//
//  Created by 张光发 on 15/10/26.
//
//

#import "FontSizeViewController.h"

@interface FontSizeViewController ()

@end

@implementation FontSizeViewController

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.pointSizes count];
}

//返回一个包含字体大小的nsarray
- (NSArray*)pointSizes
{
    static NSArray* pointSizes = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        pointSizes = @[ @9, @10, @11, @12, @13, @14, @28, @24, @36, @48, @64, @72, @96, @144 ];
    });
    return pointSizes;
}

/**
 *  根据行数获取字体
 *
 *  @param indexPath 包含组和行的位置
 *
 *  @return 字体
 */
- (UIFont*)fontForDisplayAtIndexPath:(NSIndexPath*)indexPath
{
    NSNumber* pointSize = self.pointSizes[indexPath.row];
    return [self.font fontWithSize:pointSize.floatValue];
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    static NSString* CellIdentifiter = @"FontNameAndSize";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifiter forIndexPath:indexPath];
    cell.textLabel.font = [self fontForDisplayAtIndexPath:indexPath];
    cell.textLabel.text = self.font.fontName;
    NSLog(@"self.font.fontName=%@", self.font.fontName);
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ point", self.pointSizes[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    UIFont* font = [self fontForDisplayAtIndexPath:indexPath];
    return 25 + font.ascender - font.descender;
}
@end
