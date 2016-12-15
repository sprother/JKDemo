//
//  JKSearchResultController.m
//  JKDemo
//
//  Created by jackyjiao on 12/15/16.
//  Copyright © 2016 jackyjiao. All rights reserved.
//

#import "JKSearchResultController.h"

@interface JKSearchResultController ()

@end

@implementation JKSearchResultController

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - Delegate - UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSString *searchText = [searchController.searchBar.text lowercaseString];
    JLog(@"searchText %@", searchText);
    self.view.backgroundColor = RANDOM_COLOR;
}
@end
