//
//  DetailsViewController.m
//  ToDoApp
//
//  Created by Habiba Elhadi on 06/05/2025.
//

#import "DetailsViewController.h"
#import "EditViewController.h"

@interface DetailsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *taskTitle;
@property (weak, nonatomic) IBOutlet UITextView *taskDesc;
@property (weak, nonatomic) IBOutlet UISegmentedControl *taskPriority;
@property (weak, nonatomic) IBOutlet UILabel *taskDate;
@property (weak, nonatomic) IBOutlet UISegmentedControl *taskStatus;
@property NSMutableArray *lowToDo;
@property NSMutableArray *lowInProgress;
@property NSMutableArray *lowDone;
@property NSMutableArray *mediumToDo;
@property NSMutableArray *mediumInProgress;
@property NSMutableArray *mediumDone;
@property NSMutableArray *highToDo;
@property NSMutableArray *highInProgress;
@property NSMutableArray *highDone;
@property NSUserDefaults *defaults;
@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _defaults = [NSUserDefaults standardUserDefaults];
    _lowDone = [NSMutableArray new];
    _lowToDo = [NSMutableArray new];
    _lowInProgress = [NSMutableArray new];
    _mediumInProgress = [NSMutableArray new];
    _mediumToDo = [NSMutableArray new];
    _mediumDone = [NSMutableArray new];
    _highInProgress = [NSMutableArray new];
    _highToDo = [NSMutableArray new];
    _highDone = [NSMutableArray new];
    _taskTitle.text = _task.name;
    _taskDesc.text = _task.desc;
    _taskPriority.enabled = NO;
    _taskPriority.selectedSegmentIndex = _task.priority;
    _taskDate.text = _task.date;
    _taskStatus.enabled = NO;
    _taskStatus.selectedSegmentIndex = _task.status;
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

- (IBAction)editTask:(id)sender {
    if(_task.status == 2){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Alert" message:@"Task is already done" preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
    }else{
        EditViewController *edit = [self.storyboard instantiateViewControllerWithIdentifier:@"edit"];
        edit.task = self.task;
        edit.ref = self;
        [self presentViewController:edit animated:YES completion:nil];
    }
}

- (void)editTask:(Task *)task withPriority:(int)priority andStatus:(int)status {
    
    NSError *error = nil;
    NSSet *allowedClasses = [NSSet setWithObjects:[NSArray class], [Task class], nil];

    NSArray *priorityKeys = @[@"low", @"med", @"high"];
    NSArray *statusKeys = @[@"ToDo", @"InProg", @"Done"];

    NSString *oldKey = [NSString stringWithFormat:@"%@%@", priorityKeys[self.task.priority], statusKeys[self.task.status]];
    NSString *newKey = [NSString stringWithFormat:@"%@%@", priorityKeys[priority], statusKeys[status]];
    
    self.task = task;
    [self updateUI:task];

    
    // Load old array and remove task
    NSMutableArray *oldArray = [NSMutableArray new];
    NSData *savedOld = [_defaults objectForKey:oldKey];
    if (savedOld) {
        oldArray = (NSMutableArray *)[NSKeyedUnarchiver unarchivedObjectOfClasses:allowedClasses fromData:savedOld error:&error];
    }

    // Remove the task from the old array
    for (int i = 0; i < oldArray.count; i++) {
        Task *t = oldArray[i];
        if ([t.taskId isEqual:task.taskId]) {
            [oldArray removeObjectAtIndex:i];
            break;
        }
    }

    NSData *archOld = [NSKeyedArchiver archivedDataWithRootObject:oldArray requiringSecureCoding:YES error:&error];
    if (!error) {
        [_defaults setObject:archOld forKey:oldKey];
    }

    // Load new array and insert task
    NSMutableArray *newArray = [NSMutableArray new];
    NSData *savedNew = [_defaults objectForKey:newKey];
    if (savedNew) {
        newArray = (NSMutableArray *)[NSKeyedUnarchiver unarchivedObjectOfClasses:allowedClasses fromData:savedNew error:&error];
    }

    [newArray addObject:task];

    NSData *archNew = [NSKeyedArchiver archivedDataWithRootObject:newArray requiringSecureCoding:YES error:&error];
    if (!error) {
        [_defaults setObject:archNew forKey:newKey];
    }

    // Notify main view to reload
    if(task.priority == 0){
        [[NSNotificationCenter defaultCenter] postNotificationName:@"TaskUpdated" object:nil];
    }else if(task.priority == 1){
        [[NSNotificationCenter defaultCenter] postNotificationName:@"TaskUpdatedInProg" object:nil];
    }
}




- (void)updateInternalArraysForKey:(NSString *)key withArray:(NSMutableArray *)array {
    if ([key isEqualToString:@"lowToDo"]) _lowToDo = array;
    else if ([key isEqualToString:@"lowInProg"]) _lowInProgress = array;
    else if ([key isEqualToString:@"lowDone"]) _lowDone = array;
    else if ([key isEqualToString:@"medToDo"]) _mediumToDo = array;
    else if ([key isEqualToString:@"medInProg"]) _mediumInProgress = array;
    else if ([key isEqualToString:@"medDone"]) _mediumDone = array;
    else if ([key isEqualToString:@"highToDo"]) _highToDo = array;
    else if ([key isEqualToString:@"highInProg"]) _highInProgress = array;
    else if ([key isEqualToString:@"highDone"]) _highDone = array;
}

//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    [self updateUI];
//}

- (void)updateUI :(Task *)t{
    _taskTitle.text = t.name;
    _taskDesc.text = t.desc;
    _taskPriority.selectedSegmentIndex = t.priority;
    _taskDate.text = t.date;
    _taskStatus.selectedSegmentIndex = t.status;
    _task.taskId = t.taskId;
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
