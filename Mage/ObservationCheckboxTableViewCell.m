//
//  ObservationCheckboxTableViewCell.m
//  MAGE
//
//

#import "ObservationCheckboxTableViewCell.h"

@implementation ObservationCheckboxTableViewCell

- (void) populateCellWithFormField: (id) field andObservation: (Observation *) observation {
    id value = [observation.properties objectForKey:(NSString *)[field objectForKey:@"name"]];
    
    if (value != nil) {
        [self.checkboxSwitch setOn:[value boolValue]];
        [self.delegate observationField:self.fieldDefinition valueChangedTo:value reloadCell:NO];
    }
    
    [self.keyLabel setText:[field objectForKey:@"title"]];
    [self.requiredIndicator setHidden: ![[field objectForKey: @"required"] boolValue]];
    
    [self.checkboxSwitch addTarget:self action:@selector(switchValueChanged:) forControlEvents:UIControlEventValueChanged];
}

- (void) switchValueChanged:(UISwitch *) theSwitch {
    [self.delegate observationField:self.fieldDefinition valueChangedTo:[NSNumber numberWithBool:theSwitch.on] reloadCell:NO];
}

- (CGFloat) getCellHeightForValue: (id) value {
    return self.bounds.size.height;
}

- (void) selectRow {
    [self.checkboxSwitch setOn:!self.checkboxSwitch.isOn];
}

@end
