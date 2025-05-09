//
//  AddTaskViewController.m
//  ToDoApp
//
//  Created by Habiba Elhadi on 06/05/2025.
//

#import "AddTaskViewController.h"

@interface AddTaskViewController ()
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextView *desc;
@property (weak, nonatomic) IBOutlet UISegmentedControl *priority;
@property (weak, nonatomic) IBOutlet UIDatePicker *date;

@end

@implementation AddTaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.date.minimumDate = [NSDate date];
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
       [self.view addGestureRecognizer:panGesture];
    // Do any additional setup after loading the view.
}

- (void)handlePanGesture:(UIPanGestureRecognizer *)gesture {
    CGPoint translation = [gesture translationInView:self.view];
    
    if (translation.y > 100 && gesture.state == UIGestureRecognizerStateEnded) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (IBAction)saveTask:(id)sender {
    NSString *trimmedName = [self.name.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *trimmedDesc= [self.desc.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
    if([trimmedName isEqual:@""] || [trimmedDesc isEqual:@""]){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Alert" message:@"Empty feilds" preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                self.name.text = @"";
                self.desc.text = @"";
            }];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
    }else{
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        NSString *taskId = [[NSUUID UUID] UUIDString];
        Task *task = [[Task alloc] initWithName:_name.text desc:_desc.text priority:(int)_priority.selectedSegmentIndex status:0 date:[dateFormatter stringFromDate:_date.date] taskId:taskId];
        [_ref insertTask:task withPriority:(int)_priority.selectedSegmentIndex];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
