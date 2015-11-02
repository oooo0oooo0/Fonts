//
//  RootViewController.m
//
//
//  Created by 张光发 on 15/10/25.
//
//

#import "RootViewController.h"
#import "FavoritesList.h"
#import "FontListViewController.h"

@interface RootViewController ()
//存放所有系统字体系列的名字
@property (copy, nonatomic) NSArray* familyNames;
//字体大小
@property (assign, nonatomic) CGFloat cellPointSize;
//收藏夹实例
@property (strong, nonatomic) FavoritesList* favoritesList;
@end

@implementation RootViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    //获取系统中所有字体系列的名称，并排序
    self.familyNames = [[UIFont familyNames] sortedArrayUsingSelector:@selector(compare:)];
    //获取系统标题处使用的字体
    UIFont* preferredTableViewFont = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    self.cellPointSize = preferredTableViewFont.pointSize;
    self.favoritesList = [FavoritesList sharedFavoritesList];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.tableView reloadData];
}

//TODO: 获取指定位置的字体
- (UIFont*)fontForDisplayAtIndexPath:(NSIndexPath*)indexPath
{
    //如果是系统字体列表
    if (indexPath.section == 0) {
        //获取字体系列名
        NSString* familyName = self.familyNames[indexPath.row];
        //该系列中的第一种字体的名字
        NSString* fontName = [[UIFont fontNamesForFamilyName:familyName] firstObject];
        return [UIFont fontWithName:fontName size:self.cellPointSize];
    }
    else {
        return nil;
    }
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    if ([self.favoritesList.favorites count] > 0) {
        return 2;
    }
    else {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return [self.familyNames count];
    }
    else {
        return 1;
    }
}

- (NSString*)tableView:(UITableView*)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"所有的字体";
    }
    else {
        return @"我收藏的字体";
    }
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    static NSString* FamilyNameCell = @"FamilyName";
    static NSString* FavoritesCell = @"Favorites";
    UITableViewCell* cell = nil;
    if (indexPath.section == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:FamilyNameCell];
        //显示字体系列的名称
        cell.textLabel.text = self.familyNames[indexPath.row];
        //cell.textLabel.text = @"帅哥张光发✨";//这是绝对的，所以没效果😂
        //设置字体
        cell.textLabel.font = [self fontForDisplayAtIndexPath:indexPath];
        //详情内容使用正常字体显示字体系列名称
        cell.detailTextLabel.text = self.familyNames[indexPath.row];
    }
    else {
        //收藏夹显示普通cell
        cell = [tableView dequeueReusableCellWithIdentifier:FavoritesCell forIndexPath:indexPath];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    if (indexPath.section == 0) {
        //获取当前行的字体
        UIFont* font = [self fontForDisplayAtIndexPath:indexPath];
        //返回一个合适的高度
        return 25 + font.ascender - font.descender;
    }
    else {
        return tableView.rowHeight;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue*)segue sender:(id)sender
{
    NSIndexPath* indexPath = [self.tableView indexPathForCell:sender];
    FontListViewController* listVC = segue.destinationViewController;
    if (indexPath.section == 0) {
        NSString* familyName = self.familyNames[indexPath.row];
        listVC.fontNames = [[UIFont fontNamesForFamilyName:familyName] sortedArrayUsingSelector:@selector(compare:)];
        listVC.navigationItem.title = familyName;
        listVC.showsFavorites = NO;
    }
    else {
        listVC.fontNames = self.favoritesList.favorites;
        listVC.navigationItem.title = @"Favorites";
        listVC.showsFavorites = YES;
    }
}
@end
