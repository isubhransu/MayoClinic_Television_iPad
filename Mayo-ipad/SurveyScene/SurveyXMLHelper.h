//
//  SurveyPageXMLHelper.h
//  Mayo-ipad
//
//  Created by Subhransu Mishra on 11/15/14.
//  Copyright (c) 2014 Subhransu Mishra. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SurveyXMLHelper : NSObject <NSXMLParserDelegate>
- (NSMutableArray *) getLoadedQuestionOptionsList;
-(id)init;
@end
