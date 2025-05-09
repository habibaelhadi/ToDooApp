//
//  EditViewController.m
//  ToDoApp
//
//  Created by Habiba Elhadi on 07/05/2025.
//

#import "EditViewController.h"

@interface EditViewController ()
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextView *taskDesc;
@property (weak, nonatomic) IBOutlet UISegmentedControl *taskPriority;
@property (weak, nonatomic) IBOutlet UIDatePicker *taskDate;
@property (weak, nonatomic) IBOutlet UISegmentedControl *taskState;

@end

@implementation EditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.taskDate.minimumDate = [NSDate date];
    _name.text = _task.name;
    _taskDesc.text = _task.desc;
    _taskPriority.selectedSegmentIndex = _task.priority;
    _taskState.selectedSegmentIndex = _task.status;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    _taskDate.date = [formatter dateFromString:_task.date];
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

- (IBAction)saveChanges:(id)sender {
    NSString *trimmedName = [self.name.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *trimmedDesc= [self.taskDesc.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
    if([trimmedName isEqual:@""] || [trimmedDesc isEqual:@""]){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Alert" message:@"Empty feilds" preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                self.name.text = @"";
                self.taskDesc.text = @"";
            }];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
    }else{
        Task *edittedTask = [Task new];
        edittedTask.name = _name.text;
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        edittedTask.date = [formatter stringFromDate: _taskDate.date];
        edittedTask.desc = _taskDesc.text;
        edittedTask.status = (int)_taskState.selectedSegmentIndex;
        edittedTask.priority = (int)_taskPriority.selectedSegmentIndex;
        edittedTask.taskId = _task.taskId;
        [_ref editTask:edittedTask withPriority:edittedTask.priority andStatus:edittedTask.status];
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
