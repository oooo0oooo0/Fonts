//
//  FontListViewController.h
//  
//
//  Created by 张光发 on 15/10/26.
//
//

#import <UIKit/UIKit.h>

@interface FontListViewController : UITableViewController
@property(copy,nonatomic)NSArray *fontNames;
@property(assign,nonatomic) BOOL showsFavorites;
@end
