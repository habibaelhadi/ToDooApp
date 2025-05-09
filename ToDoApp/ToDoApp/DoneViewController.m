//
//  DoneViewController.m
//  ToDoApp
//
//  Created by Habiba Elhadi on 06/05/2025.
//

#import "DoneViewController.h"
#import "DetailsViewController.h"
#import "CustomTableViewCell.h"
#import "Task.h"

@interface DoneViewController ()
@property (weak, nonatomic) IBOutlet UITableView *table;
@property NSMutableArray *low;
@property NSMutableArray *medium;
@property NSMutableArray *high;
@property NSMutableArray *all;
@property Task *task;
@property NSUserDefaults *defaults;
@property BOOL isSorted;
@end

@implementation DoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _defaults = [NSUserDefaults standardUserDefaults];
    _isSorted = NO;
    [self updateArrays];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTasks) name:@"TaskUpdated" object:nil];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [self reloadTasks];
}

- (void)reloadTasks {
    [self updateArrays];
    NSError *error = nil;
        NSSet *allowedClasses = [NSSet setWithObjects:[NSArray class], [Task class], nil];

        NSData *savedLow = [_defaults objectForKey:@"lowDone"];
        NSData *savedMed = [_defaults objectForKey:@"medDone"];
        NSData *savedHigh = [_defaults objectForKey:@"highDone"];

        _low = savedLow ? (NSMutableArray *)[NSKeyedUnarchiver unarchivedObjectOfClasses:allowedClasses fromData:savedLow error:&error] : [NSMutableArray new];
        _medium = savedMed ? (NSMutableArray *)[NSKeyedUnarchiver unarchivedObjectOfClasses:allowedClasses fromData:savedMed error:&error] : [NSMutableArray new];
        _high = savedHigh ? (NSMutableArray *)[NSKeyedUnarchiver unarchivedObjectOfClasses:allowedClasses fromData:savedHigh error:&error] : [NSMutableArray new];
    
    [_all addObjectsFromArray:_low];
    [_all addObjectsFromArray:_medium];
    [_all addObjectsFromArray:_high];

    [self.table reloadData];
}

-  (void)updateArrays {
    _all = [NSMutableArray new];
    _low = [NSMutableArray new];
    _medium = [NSMutableArray new];
    _high= [NSMutableArray new];
}

- (IBAction)soetSegments:(id)sender {
    _isSorted = !_isSorted;
    [self.table reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellDone" forIndexPath:indexPath];
    Task *task;
    if(_isSorted){
        switch (indexPath.section) {
            case 0:
                task = _low[indexPath.row];
                cell.doneView.backgroundColor = [ UIColor systemGreenColor];
                cell.doneLabel.text = task.name;
                break;
            case 1:
                task = _medium[indexPath.row];
                cell.doneView.backgroundColor = [ UIColor systemYellowColor];
                cell.doneLabel.text = task.name;
                break;
            default:
                task = _high[indexPath.row];
                cell.doneView.backgroundColor = [ UIColor systemRedColor];
                cell.doneLabel.text = task.name;
                break;
        }

    }else{
        task = _all[indexPath.row];
        switch (task.priority) {
            case 0:
                cell.doneView.backgroundColor = [ UIColor systemGreenColor];
                cell.doneLabel.text = task.name;
                break;
            case 1:
                cell.doneView.backgroundColor = [ UIColor systemYellowColor];
                cell.doneLabel.text = task.name;
                break;
            default:
                cell.doneView.backgroundColor = [ UIColor systemRedColor];
                cell.doneLabel.text = task.name;
                break;
        }
    }
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if(_isSorted){
        return 3;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(_isSorted){
        switch (section) {
            case 0:
                return  _low.count;
                break;
            case 1:
                return _medium.count;
                break;
            default:
                return _high.count;
                break;
        }
    }
    return _all.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 40)];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(16, 5, tableView.bounds.size.width - 32, 30)];
    
    if(_isSorted){
        switch (section) {
            case 0:
                label.text = [NSString stringWithFormat:@"Low"];
                label.textColor = [UIColor systemPurpleColor];
                label.font = [UIFont boldSystemFontOfSize:18];
                break;
            case 1:
                label.text = [NSString stringWithFormat:@"Medium"];
                label.textColor = [UIColor systemPurpleColor];
                label.font = [UIFont boldSystemFontOfSize:18];
                break;
            default:
                label.text = [NSString stringWithFormat:@"Hard"];
                label.textColor = [UIColor systemPurpleColor];
                label.font = [UIFont boldSystemFontOfSize:18];
                break;
        }
    }else{
        label.text = [NSString stringWithFormat:@"All Tasks"];
        label.textColor = [UIColor systemPurpleColor];
        label.font = [UIFont boldSystemFontOfSize:18];
    }
    [headerView addSubview:label];
    return headerView;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        // Delete the row from the data source
        if(_isSorted){
            switch (indexPath.section) {
                case 0:
                {
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Alert" message:@"Confirm delete" preferredStyle:UIAlertControllerStyleActionSheet];
                    UIAlertAction *action = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        NSError *error = nil;
                        [self->_low removeObjectAtIndex:indexPath.row];
                        NSData *archLow = [NSKeyedArchiver archivedDataWithRootObject:self->_low requiringSecureCoding:YES error:&error];
                        [self->_defaults setObject:archLow forKey:@"lowDone"];
                        [self reloadTasks];
                    }];
                    UIAlertAction *cancel =[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}];
                    [alert addAction:action];
                    [alert addAction:cancel];
                    [self presentViewController:alert animated:YES completion:nil];
                    break;
                }
                case 1:
                {
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Alert" message:@"Confirm delete" preferredStyle:UIAlertControllerStyleActionSheet];
                    UIAlertAction *action = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        NSError *error = nil;
                        [self->_medium removeObjectAtIndex:indexPath.row];
                        NSData *archLow = [NSKeyedArchiver archivedDataWithRootObject:self->_medium requiringSecureCoding:YES error:&error];
                        [self->_defaults setObject:archLow forKey:@"medDone"];
                        [self reloadTasks];
                    }];
                    UIAlertAction *cancel =[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}];
                    [alert addAction:action];
                    [alert addAction:cancel];
                    [self presentViewController:alert animated:YES completion:nil];
                    break;
                }
                default:
                {
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Alert" message:@"Confirm delete" preferredStyle:UIAlertControllerStyleActionSheet];
                    UIAlertAction *action = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        NSError *error = nil;
                        [self->_high removeObjectAtIndex:indexPath.row];
                        NSData *archLow = [NSKeyedArchiver archivedDataWithRootObject:self->_high requiringSecureCoding:YES error:&error];
                        [self->_defaults setObject:archLow forKey:@"highDone"];
                        [self reloadTasks];
                    }];
                    UIAlertAction *cancel =[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}];
                    [alert addAction:action];
                    [alert addAction:cancel];
                    [self presentViewController:alert animated:YES completion:nil];
                    break;
                }
            }
        }else{
                Task *task = _all[indexPath.row];
                switch (task.priority) {
                    case 0:
                        {
                            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Alert" message:@"Confirm delete" preferredStyle:UIAlertControllerStyleActionSheet];
                            UIAlertAction *action = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                NSError *error = nil;
                                [self-> _all removeObjectAtIndex:indexPath.row];
                                [self->_low removeObject:task];
                                NSData *archLow = [NSKeyedArchiver archivedDataWithRootObject:self->_low requiringSecureCoding:YES error:&error];
                                [self->_defaults setObject:archLow forKey:@"lowDone"];
                                [self reloadTasks];
                            }];
                            UIAlertAction *cancel =[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}];
                            [alert addAction:action];
                            [alert addAction:cancel];
                            [self presentViewController:alert animated:YES completion:nil];
                            break;
                            
                        }
                    case 1:
                    {
                        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Alert" message:@"Confirm delete" preferredStyle:UIAlertControllerStyleActionSheet];
                        UIAlertAction *action = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                            NSError *error = nil;
                            [self-> _all removeObjectAtIndex:indexPath.row];
                            [self->_medium removeObject:task];
                            NSData *archLow = [NSKeyedArchiver archivedDataWithRootObject:self->_medium requiringSecureCoding:YES error:&error];
                            [self->_defaults setObject:archLow forKey:@"medDone"];
                            [self reloadTasks];
                        }];
                        UIAlertAction *cancel =[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}];
                        [alert addAction:action];
                        [alert addAction:cancel];
                        [self presentViewController:alert animated:YES completion:nil];
                        break;
                    }
                    default:
                        {
                            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Alert" message:@"Confirm delete" preferredStyle:UIAlertControllerStyleActionSheet];
                            UIAlertAction *action = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                NSError *error = nil;
                                [self-> _all removeObjectAtIndex:indexPath.row];
                                [self->_high  removeObject:task];
                                NSData *archLow = [NSKeyedArchiver archivedDataWithRootObject:self->_high requiringSecureCoding:YES error:&error];
                                [self->_defaults setObject:archLow forKey:@"highDone"];
                                [self reloadTasks];
                            }];
                            UIAlertAction *cancel =[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}];
                            [alert addAction:action];
                            [alert addAction:cancel];
                            [self presentViewController:alert animated:YES completion:nil];
                            break;                        }
                }
                }
        }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DetailsViewController *details = [self.storyboard instantiateViewControllerWithIdentifier:@"details"];
    details.modalPresentationStyle = UIModalPresentationFullScreen;
    if(_isSorted){
        switch (indexPath.section) {
            case 0:
                details.task = _low[indexPath.row];
                [self presentViewController:details animated:YES completion:nil];
                break;
            case 1:
                details.task = _medium[indexPath.row];
                [self presentViewController:details animated:YES completion:nil];
                break;
            default:
                details.task = _high[indexPath.row];
                [self presentViewController:details animated:YES completion:nil];
                break;
        }
    }else{
        Task *task = _all[indexPath.row];
        switch (task.priority){
            case 0:
                details.task = _all[indexPath.row];
                [self presentViewController:details animated:YES completion:nil];
                break;
            case 1:
                details.task = _all[indexPath.row];
                [self presentViewController:details animated:YES completion:nil];
                break;
            default:
                details.task = _all[indexPath.row];
                [self presentViewController:details animated:YES completion:nil];
                break;
        }
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
