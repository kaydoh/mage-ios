//
//  ObservationDatePickerTableViewCell.m
//  Mage
//
//

#import "ObservationDatePickerTableViewCell.h"
#import "NSDate+iso8601.h"
#import "NSDate+display.h"

@interface ObservationDatePickerTableViewCell ()
@property (strong, nonatomic) UIDatePicker *datePicker;
@property (strong, nonatomic) NSDate *date;
@end

@implementation ObservationDatePickerTableViewCell

- (void) populateCellWithFormField: (id) field andObservation: (Observation *) observation {
    self.date = nil;
    NSString *timestamp = [observation.properties objectForKey:(NSString *)[field objectForKey:@"name"]];
    if ([timestamp length] > 0) {
        self.date = [NSDate dateFromIso8601String:timestamp];
    } else {
        self.date = [[NSDate alloc] init];
        [self.delegate observationField:field valueChangedTo:[self.date iso8601String] reloadCell:NO];
    }
    
    self.datePicker = [[UIDatePicker alloc] init];
    if (![NSDate isDisplayGMT]) {
        self.datePicker.timeZone = [NSTimeZone localTimeZone];
    } else {
        self.datePicker.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    }
    self.datePicker.date = self.date;
    [self.textField setText:[_datePicker.date formattedDisplayDate]];
    [self.keyLabel setText:[field objectForKey:@"title"]];
    UIBarButtonItem *doneBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonPressed)];
    UIBarButtonItem *cancelBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonPressed)];
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UILabel *timeZoneLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    timeZoneLabel.text = [self.datePicker.timeZone name];
    [timeZoneLabel sizeToFit];
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    toolbar.items = [NSArray arrayWithObjects:cancelBarButton, flexSpace, [[UIBarButtonItem alloc] initWithCustomView:timeZoneLabel], flexSpace, doneBarButton, nil];
    self.textField.inputView = self.datePicker;
    self.textField.inputAccessoryView = toolbar;
    [self.textField setDelegate:self];
    [self.requiredIndicator setHidden: ![[field objectForKey: @"required"] boolValue]];
}

- (BOOL) isEmpty {
    return [self.textField.text length] == 0;
}

- (void) selectRow {
    [self.textField becomeFirstResponder];
}

- (void) cancelButtonPressed {
    self.datePicker.date = self.date;
    [self.textField resignFirstResponder];
}

- (void) doneButtonPressed {
    [self.textField resignFirstResponder];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    NSString *newValue = [self.datePicker.date formattedDisplayDate];
    if (![self.datePicker.date isEqualToDate:self.date]) {
        self.textField.text = newValue;
        if (self.delegate && [self.delegate respondsToSelector:@selector(observationField:valueChangedTo:reloadCell:)]) {
            [self.delegate observationField:self.fieldDefinition valueChangedTo:[self.datePicker.date iso8601String] reloadCell:NO];
        }
    }
}

- (void) setValid:(BOOL) valid {
    [super setValid:valid];
    
    if (valid) {
        self.textField.layer.borderColor = nil;
    } else {
        self.textField.layer.cornerRadius = 4.0f;
        self.textField.layer.masksToBounds = YES;
        self.textField.layer.borderColor = [[UIColor redColor] CGColor];
        self.textField.layer.borderWidth = 1.0f;
    }
};



@end
