//
//  SurveyViewController.m
//  Mayo-ipad
//
//  Created by Ashraf Gaffar on 11/11/14.
//  Copyright (c) 2014 rishabh srivastava. All rights reserved.

#import "SurveyViewController.h"
#import "QuestionAndOptions.h"
#import "RadioButton.h"
#import "CheckBox.h"
#import "SurveyXMLHelper.h"

@interface SurveyViewController ()
@property NSMutableArray *pickerViewsArray;
@property (weak, nonatomic) IBOutlet UITextView *remarks;
@property (weak, nonatomic) IBOutlet UIButton *submitSurvey;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation SurveyViewController
@synthesize dict;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"mayobg.png"]]];
    //self.view.backgroundColor = [UIColor clearColor];
    self.questionsOptionsList = [[NSMutableArray alloc] init];
    self.pickerViewsArray = [[NSMutableArray alloc] init];
//    [self loadQuestionsAndOptionsFromFile];
    SurveyXMLHelper *helper = [[SurveyXMLHelper alloc]init];
    self.questionsOptionsList = [helper getLoadedQuestionOptionsList];

    [self createPickerViews];
}

- (void)createPickerViews

{
    for(int x = 0; x < [self.questionsOptionsList count]; x++) //number of picker views
    {

        QuestionAndOptions *item = [self.questionsOptionsList objectAtIndex:x];
        
        if(item.objective){
            RadioButton *radioGroup =[[RadioButton alloc]
                                    initWithFrame:CGRectMake(0, 60, 1000, 75)
                                    andOptions:item.options andColumns:4];
            [self.pickerViewsArray addObject:radioGroup];
        } else{
            CheckBox *checkBoxGroup =[[CheckBox alloc]
                              initWithFrame:CGRectMake(0, 60, 1000, 75)
                              andOptions:item.options andColumns:4];
            [self.pickerViewsArray addObject:checkBoxGroup];
        }
        

    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [self.questionsOptionsList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"questionCell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"questionCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSLog(@"inside cell == nil");
    }
    QuestionAndOptions *item = [self.questionsOptionsList objectAtIndex:indexPath.row];

    for(UIView *view in cell.contentView.subviews){
        if ([view isKindOfClass:[UIView class]]) {
            [view removeFromSuperview];
        }
    }
    // Configure the cell...
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 1000, 75)];
    label.text = item.question;
    [cell.contentView addSubview:label];
    cell.backgroundColor = [UIColor clearColor];

    [cell.contentView addSubview:(UIPickerView*)[self.pickerViewsArray objectAtIndex:indexPath.row]];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 130.0f; //just some arbitrary value, change it to suit your needs.
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


- (IBAction)SubmitButtonClicked:(id)sender {
    BOOL allAnswered = true;
    NSMutableArray *surveyQustions = [[NSMutableArray alloc] init];
    NSMutableArray *surveyAnswers = [[NSMutableArray alloc] init];
    for( int i = 0; i< self.pickerViewsArray.count; i++){
        UIView *view = [self.pickerViewsArray objectAtIndex:i];
        if ([view isKindOfClass:[RadioButton class]]) {
            int selectedIndex = ((RadioButton *)view).currentIndex;
            if(selectedIndex == -1){
                allAnswered=false;
                break;

            }
            QuestionAndOptions *currentQues = [self.questionsOptionsList objectAtIndex:i];
            [surveyAnswers addObject: [currentQues.options objectAtIndex:selectedIndex]];
            [surveyQustions addObject: currentQues.question];
             }
        
        if ([view isKindOfClass:[CheckBox class]]) {
            NSMutableArray *selectedOptions = ((CheckBox *)view).selectedOptions;
            QuestionAndOptions *currentQues = [self.questionsOptionsList objectAtIndex:i];
            
            NSString *ans =@"";
            for( int i =0; i<[selectedOptions count]; i++){
                ans= [ans stringByAppendingString:[currentQues.options objectAtIndex:i]];
                ans= [ans stringByAppendingString:@","];
            }
            [surveyAnswers addObject: ans];
            [surveyQustions addObject: currentQues.question];
        }

        
    }
    if (allAnswered) {
        [surveyAnswers addObject: self.remarks.text];
        [surveyQustions addObject: @"remarks"];
        self.dict = [NSDictionary dictionaryWithObjects:surveyAnswers forKeys:surveyQustions];
        [[NSUserDefaults standardUserDefaults] setValue:self.dict forKey:@"dict"];
        [[NSUserDefaults standardUserDefaults] setValue:surveyQustions forKey:@"surveyQuestions"];
        [self performSegueWithIdentifier:@"review_segue" sender:self];
    }
    else{
        [[[UIAlertView alloc] initWithTitle:@"Sorry"
                                    message:@"Please answer all the questions to continue"
                                   delegate: nil
                          cancelButtonTitle:@"Cancel"
                          otherButtonTitles:nil
          ] show];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"review_segue"]) {
        SurveyViewController *destViewController = segue.destinationViewController;
    }
}

@end
