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
    _name.text = _task.name;
    _taskDesc.text = _task.desc;
    _taskPriority.selectedSegmentIndex = _task.priority;
    _taskState.selectedSegmentIndex = _task.status;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    _taskDate.date = [formatter dateFromString:_task.date];
    // Do any additional setup after loading the view.
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
        _task.name = _name.text;
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        _task.date = [formatter stringFromDate: _taskDate.date];
        _task.desc = _taskDesc.text;
        _task.status = (int)_taskState.selectedSegmentIndex;
        _task.priority = (int)_taskPriority.selectedSegmentIndex;
        [_ref editTask:_task withPriority:_task.priority andStatus:_task.status];
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
