//
//  SurveyViewController.h
//  Mayo-ipad
//
//  Created by Subhransu Mishra on 11/11/14.
//  Copyright (c) 2014 Subhransu Mishra. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SurveyViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource>
@property NSMutableArray *questionsOptionsList;

@property NSDictionary *dict;
@end
