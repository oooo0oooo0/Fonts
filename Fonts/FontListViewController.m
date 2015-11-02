//
//  FontListViewController.m
//
//
//  Created by 张光发 on 15/10/26.
//
//

#import "FontListViewController.h"
#import "FavoritesList.h"
#import "FontSizeViewController.h"
#import "FontInfoViewController.h"

@interface FontListViewController ()
@property (assign, nonatomic) CGFloat cellPointSize;
@end

@implementation FontListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //获取系统默认的头部字体
    UIFont* preferredTableViewFont = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    //获取文字的大小
    self.cellPointSize = preferredTableViewFont.pointSize;
    
    //导航栏右边的按钮(启用编辑)
    if (self.showsFavorites) {
        self.navigationItem.rightBarButtonItem=self.editButtonItem;
    }
}

/**
 *  获取指定位置的字体
 */
- (UIFont*)fontForDisplayAtIndexPath:(NSIndexPath*)indexPath
{
    NSString* fontName = self.fontNames[indexPath.row];
    return [UIFont fontWithName:fontName size:self.cellPointSize];
}

//界面重新加载时
- (void)viewDidAppear:(BOOL)animated
{
    //如果展示收藏字体
    if (self.showsFavorites) {
        //获取收藏字体集合
        self.fontNames = [FavoritesList sharedFavoritesList].favorites;
        //tableview重新加载数据
        [self.tableView reloadData];
    }
}
#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.fontNames count];
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    static NSString* CellIdentifier = @"FontName";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.textLabel.font = [self fontForDisplayAtIndexPath:indexPath];
    cell.textLabel.text = self.fontNames[indexPath.row];
    cell.detailTextLabel.text = self.fontNames[indexPath.row];

    return cell;
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    UIFont* font = [self fontForDisplayAtIndexPath:indexPath];
    return 25 + font.ascender - font.descender;
}

/**
 *  转场时调用的方法
 *
 *  @param segue  包含涉及controller的segue
 *  @param sender 触发者
 */
- (void)prepareForSegue:(UIStoryboardSegue*)segue sender:(id)sender
{
    //根据sender获取点击位置信息
    NSIndexPath* indexPath = [self.tableView indexPathForCell:sender];
    //根据位置信息获取font
    UIFont* font = [self fontForDisplayAtIndexPath:indexPath];
    //设置导航栏标题为字体名字
    [segue.destinationViewController navigationItem].title = font.fontName;

    NSLog(@"segue.identifier=%@",segue.identifier);
    if ([segue.identifier isEqualToString: @"showFontSizes"]) {
        FontSizeViewController* sizeVC = segue.destinationViewController;
        sizeVC.font = font;
    }
    else if([segue.identifier isEqualToString:@"showFontInfo"]) {
        FontInfoViewController* infoVC = segue.destinationViewController;
        infoVC.font = font;
        //获取并设置该字体是否收藏，用来传递给info
        infoVC.favorite=[[FavoritesList sharedFavoritesList].favorites containsObject:font.fontName];
    }
}

//设置只有展示收藏字体时才可以启用横扫删除
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.showsFavorites;
}

//实际删除方法，用户点击删除后调用
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.showsFavorites) {
        return;
    }
    if (editingStyle==UITableViewCellEditingStyleDelete) {
        NSString *favorite=self.fontNames[indexPath.row];
        [[FavoritesList sharedFavoritesList] removeFavorite:favorite];
        self.fontNames=[FavoritesList sharedFavoritesList].favorites;
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

//移动cell之后调用
-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    [[FavoritesList sharedFavoritesList] moveItemAtIndex:sourceIndexPath.row toIndex:destinationIndexPath.row];
    self.fontNames=[FavoritesList sharedFavoritesList].favorites;
}
@end
