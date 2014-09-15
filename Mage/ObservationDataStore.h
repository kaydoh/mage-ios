//
//  ObservationDataStore.h
//  MAGE
//
//  Created by Dan Barela on 9/12/14.
//  Copyright (c) 2014 National Geospatial Intelligence Agency. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Observation.h"
#import "ObservationTableViewCell.h"

@interface ObservationDataStore : NSObject <UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSFetchedResultsController *observationResultsController;
@property (strong, nonatomic) NSDictionary *form;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSString *variantField;

- (Observation *) observationAtIndexPath: (NSIndexPath *)indexPath;
- (ObservationTableViewCell *) cellForObservationAtIndex: (NSIndexPath *) indexPath inTableView: (UITableView *) tableView;
- (void) startFetchControllerWithManagedObjectContext: (NSManagedObjectContext *) managedObjectContext;

@end
