//
//  FavoritesList.h
//  
//
//  Created by 张光发 on 15/10/26.
//
//

#import <Foundation/Foundation.h>

@interface FavoritesList : NSObject
+ (instancetype)sharedFavoritesList;

- (NSArray *)favorites;

- (void)addFavorite:(id)item;
- (void)removeFavorite:(id)item;

- (void)moveItemAtIndex:(NSInteger)from toIndex:(NSInteger)to;
@end
