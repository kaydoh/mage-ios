//
//  PeopleViewController.m
//  Mage
//
//

#import "LocationTableViewController.h"
#import "Location.h"
#import "MeViewController.h"
#import <Event.h>
#import "MageSessionManager.h"
#import "TimeFilter.h"
#import "Filter.h"
#import "UINavigationItem+Subtitle.h"

@implementation LocationTableViewController

- (void) viewDidLoad {
    [super viewDidLoad];
    
    // bug in ios smashes the refresh text into the
    // spinner.  This is the only work around I have found
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.refreshControl beginRefreshing];
        [self.refreshControl endRefreshing];
    });
    
    self.refreshControl.backgroundColor = [UIColor colorWithWhite:.9 alpha:.5];
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 88;
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.locationDataStore startFetchController];
    [self setNavBarTitle];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults addObserver:self
               forKeyPath:kTimeFilterKey
                  options:NSKeyValueObservingOptionNew
                  context:NULL];
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObserver:self forKeyPath:kTimeFilterKey];
}

- (void) setNavBarTitle {
    NSString *timeFilterString = [Filter getFilterString];
    [self.navigationItem setTitle:[Event getCurrentEventInContext:[NSManagedObjectContext MR_defaultContext]].name subtitle:[timeFilterString isEqualToString:@"All"] ? nil : timeFilterString];
}

- (void) prepareForSegue:(UIStoryboardSegue *) segue sender:(id) sender {
    if ([[segue identifier] isEqualToString:@"DisplayPersonSegue"]) {
        MeViewController *destination = (MeViewController *)[segue destinationViewController];
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
		Location *location = [self.locationDataStore locationAtIndexPath:indexPath];
		[destination setUser:location.user];
    }
}

- (IBAction)refreshPeople:(UIRefreshControl *)sender {
    [self.refreshControl beginRefreshing];
    
    NSURLSessionDataTask *userFetchTask = [Location operationToPullLocationsWithSuccess:^{
        [self.refreshControl endRefreshing];
    } failure:^(NSError* error) {
        [self.refreshControl endRefreshing];
    }];
    
    [[MageSessionManager manager] addTask:userFetchTask];
}

- (void) observeValueForKeyPath:(NSString *)keyPath
                       ofObject:(id)object
                         change:(NSDictionary *)change
                        context:(void *)context {
    
    if ([keyPath isEqualToString:kTimeFilterKey]) {
        [self.locationDataStore startFetchController];
        [self setNavBarTitle];
    }
}


@end
