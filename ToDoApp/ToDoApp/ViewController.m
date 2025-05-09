//
//  ViewController.m
//  ToDoApp
//
//  Created by Habiba Elhadi on 06/05/2025.
//

#import "ViewController.h"
#import "AddTaskViewController.h"
#import "DetailsViewController.h"
#import "CustomTableViewCell.h"
#import "Task.h"

@interface ViewController ()
@property DetailsViewController *details;
@property (weak, nonatomic) IBOutlet UITableView *table;
@property NSMutableArray *low;
@property NSMutableArray *medium;
@property NSMutableArray *high;
@property Task *task;
@property NSUserDefaults *defaults;
@property (weak, nonatomic) IBOutlet UISegmentedControl *filter;
@property (weak, nonatomic) IBOutlet UISearchBar *search;
@property NSMutableArray *filteredLow;
@property NSMutableArray *filteredMedium;
@property NSMutableArray *filteredHigh;
@property BOOL isSearching;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _defaults = [NSUserDefaults standardUserDefaults];
    _search.delegate = self;
    NSError *error=nil;
    
    NSData *savedLow = [_defaults objectForKey:@"lowToDo"];
    NSData *savedMed = [_defaults objectForKey:@"medToDo"];
    NSData *savedHigh = [_defaults objectForKey:@"highToDo"];
    
    NSSet *allowedClasses = [NSSet setWithObjects:[NSArray class], [Task class], nil];
    
    if (savedLow) {
        _low = (NSMutableArray*)[NSKeyedUnarchiver unarchivedObjectOfClasses:allowedClasses fromData:savedLow error:&error];
        if (error) {
            _low = [NSMutableArray new];
        }
    } else {
        _low = [NSMutableArray new];
    }
    
    if(savedMed){
        _medium = (NSMutableArray*)[NSKeyedUnarchiver unarchivedObjectOfClasses:allowedClasses fromData:savedMed error:&error];
        if (error) {
            _medium = [NSMutableArray new];
        }
    }else{
        _medium = [NSMutableArray new];
    }
    
    if(savedHigh){
        _high = (NSMutableArray*)[NSKeyedUnarchiver unarchivedObjectOfClasses:allowedClasses fromData:savedHigh error:&error];
        if (error) {
            _high = [NSMutableArray new];
        }
    }else{
        _high = [NSMutableArray new];
    }
    
    [self.table reloadData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTasks) name:@"TaskUpdated" object:nil];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [self reloadTasks];
}

- (void)reloadTasks {
    NSError *error = nil;
        NSSet *allowedClasses = [NSSet setWithObjects:[NSArray class], [Task class], nil];

        NSData *savedLow = [_defaults objectForKey:@"lowToDo"];
        NSData *savedMed = [_defaults objectForKey:@"medToDo"];
        NSData *savedHigh = [_defaults objectForKey:@"highToDo"];

        _low = savedLow ? (NSMutableArray *)[NSKeyedUnarchiver unarchivedObjectOfClasses:allowedClasses fromData:savedLow error:&error] : [NSMutableArray new];
        _medium = savedMed ? (NSMutableArray *)[NSKeyedUnarchiver unarchivedObjectOfClasses:allowedClasses fromData:savedMed error:&error] : [NSMutableArray new];
        _high = savedHigh ? (NSMutableArray *)[NSKeyedUnarchiver unarchivedObjectOfClasses:allowedClasses fromData:savedHigh error:&error] : [NSMutableArray new];

        [self.table reloadData];
}

- (IBAction)filterSection:(id)sender {
    [self.table reloadData];
}

- (IBAction)addTask:(id)sender {
    AddTaskViewController *addTask = [self.storyboard instantiateViewControllerWithIdentifier:@"addTask"];
    addTask.ref = self;
    [self presentViewController:addTask animated:YES completion:nil];
}


#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length == 0) {
        self.isSearching = NO;
        [self.table reloadData];
        return;
    }

    self.isSearching = YES;
    self.filteredLow = [NSMutableArray new];
    self.filteredMedium = [NSMutableArray new];
    self.filteredHigh = [NSMutableArray new];

    NSArray *sourceLow = _low;
    NSArray *sourceMedium = _medium;
    NSArray *sourceHigh = _high;

    for (Task *task in sourceLow) {
        if ([[task.name lowercaseString] containsString:[searchText lowercaseString]]) {
            [self.filteredLow addObject:task];
        }
    }

    for (Task *task in sourceMedium) {
        if ([[task.name lowercaseString] containsString:[searchText lowercaseString]]) {
            [self.filteredMedium addObject:task];
        }
    }

    for (Task *task in sourceHigh) {
        if ([[task.name lowercaseString] containsString:[searchText lowercaseString]]) {
            [self.filteredHigh addObject:task];
        }
    }

    [self.table reloadData];
}


- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    self.isSearching = NO;
    [self.search resignFirstResponder];
    [self.table reloadData];
}


-(void)insertTask:(Task *)task withPriority : (int)priority{
    NSError *error=nil;
        if(priority == 0){
            [_low addObject:task];
            NSData *archLow = [NSKeyedArchiver archivedDataWithRootObject:_low requiringSecureCoding:YES error:&error];
            if (error) {
                NSLog(@"Archiving error (low): %@", error.localizedDescription);
            }
            [_defaults setObject:archLow forKey:@"lowToDo"];

        } else if (priority == 1){
            [_medium addObject:task];
            NSData *archMedium = [NSKeyedArchiver archivedDataWithRootObject:_medium requiringSecureCoding:YES error:&error];
            if (error) {
                NSLog(@"Archiving error (medium): %@", error.localizedDescription);
            }
            [_defaults setObject:archMedium forKey:@"medToDo"];
        }else{
            [_high addObject:task];
            NSData *archHigh = [NSKeyedArchiver archivedDataWithRootObject:_high requiringSecureCoding:YES error:&error];
            if (error) {
                NSLog(@"Archiving error (high): %@", error.localizedDescription);
            }
            [_defaults setObject:archHigh forKey:@"highToDo"];
        }
        [_defaults synchronize];
        [self.table reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.isSearching && _filter.selectedSegmentIndex == 3) {
           return 3;
    }else if (_filter.selectedSegmentIndex == 3){
        return 3;
    }
       return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.isSearching) {
        switch (_filter.selectedSegmentIndex) {
            case 0: return self.filteredLow.count;
            case 1: return self.filteredMedium.count;
            case 2: return self.filteredHigh.count;
            case 3:
                switch (section) {
                    case 0: return self.filteredLow.count;
                    case 1: return self.filteredMedium.count;
                    case 2: return self.filteredHigh.count;
                    default: return 0;
                }
            default: return 0;
        }
    }

    // Not searching
    switch (_filter.selectedSegmentIndex) {
        case 0: return _low.count;
        case 1: return _medium.count;
        case 2: return _high.count;
        default:
            switch (section) {
                case 0: return _low.count;
                case 1: return _medium.count;
                case 2: return _high.count;
                default: return 0;
            }
    }
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    Task *task;
    if (self.isSearching) {
        if(_filter.selectedSegmentIndex == 0){
            task = self.filteredLow[indexPath.row];
        }else if(_filter.selectedSegmentIndex == 1){
            task = self.filteredMedium[indexPath.row];
        }else if (_filter.selectedSegmentIndex == 2){
            task = self.filteredHigh[indexPath.row];
        }else{
            if(indexPath.section == 0){
                task = self.filteredLow[indexPath.row];
            }else if (indexPath.section == 1){
                task = self.filteredMedium[indexPath.row];
            }else{
                task = self.filteredHigh[indexPath.row];
            }
        }
        
        // Set color based on task priority
        switch (task.priority) {
            case 0:
                cell.toDoView.backgroundColor = [UIColor systemGreenColor];
                break;
            case 1:
                cell.toDoView.backgroundColor = [UIColor systemYellowColor];
                break;
            case 2:
                cell.toDoView.backgroundColor = [UIColor systemRedColor];
                break;
            default:
                cell.toDoView.backgroundColor = [UIColor lightGrayColor];
                break;
        }
    } else {
        switch (_filter.selectedSegmentIndex) {
            case 0:
                task = _low[indexPath.row];
                cell.toDoView.backgroundColor = [UIColor systemGreenColor];
                break;
            case 1:
                task = _medium[indexPath.row];
                cell.toDoView.backgroundColor = [UIColor systemYellowColor];
                break;
            case 2:
                task = _high[indexPath.row];
                cell.toDoView.backgroundColor = [UIColor systemRedColor];
                break;
            default:
                switch (indexPath.section) {
                    case 0:
                        task = _low[indexPath.row];
                        cell.toDoView.backgroundColor = [UIColor systemGreenColor];
                        break;
                    case 1:
                        task = _medium[indexPath.row];
                        cell.toDoView.backgroundColor = [UIColor systemYellowColor];
                        break;
                    case 2:
                        task = _high[indexPath.row];
                        cell.toDoView.backgroundColor = [UIColor systemRedColor];
                        break;
                    default:
                        break;
                }
                break;
        }
    }

    cell.toDoLabel.text = task.name;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DetailsViewController *details = [self.storyboard instantiateViewControllerWithIdentifier:@"details"];
    switch (_filter.selectedSegmentIndex) {
        case 0:
            details.task = _low[indexPath.row];
            [self presentViewController:details animated:YES completion:nil];
            break;
        case 1:
            details.task = _medium[indexPath.row];
            [self presentViewController:details animated:YES completion:nil];
            break;
        case 2:
            details.task = _high[indexPath.row];
            [self presentViewController:details animated:YES completion:nil];
            break;
        default:
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
            break;
    }
   
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 40)];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(16, 5, tableView.bounds.size.width - 32, 30)];
    switch (_filter.selectedSegmentIndex) {
        case 0:
            label.text = [NSString stringWithFormat:@"Low"];
            label.textColor = [UIColor systemBlueColor];
            label.font = [UIFont boldSystemFontOfSize:18];
            break;
        case 1:
            label.text = [NSString stringWithFormat:@"Medium"];
            label.textColor = [UIColor systemBlueColor];
            label.font = [UIFont boldSystemFontOfSize:18];
            break;
        case 2:
            label.text = [NSString stringWithFormat:@"Hard"];
            label.textColor = [UIColor systemBlueColor];
            label.font = [UIFont boldSystemFontOfSize:18];
            break;
        default:
            if(section == 0){
                label.text = [NSString stringWithFormat:@"Low"];
                label.textColor = [UIColor systemBlueColor];
                label.font = [UIFont boldSystemFontOfSize:18];
                
            }else if (section == 1){
                label.text = [NSString stringWithFormat:@"Medium"];
                label.textColor = [UIColor systemBlueColor];
                label.font = [UIFont boldSystemFontOfSize:18];
            }else{
                label.text = [NSString stringWithFormat:@"Hard"];
                label.textColor = [UIColor systemBlueColor];
                label.font = [UIFont boldSystemFontOfSize:18];
            }
            break;
    }
    
    
    [headerView addSubview:label];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40.0;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSError *error = nil;
        // Delete the row from the data source
        switch (_filter.selectedSegmentIndex) {
            case 0:
            {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Alert" message:@"Confirm delete" preferredStyle:UIAlertControllerStyleActionSheet];
                UIAlertAction *action = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    NSError *error = nil;
                    [self->_low removeObjectAtIndex:indexPath.row];
                    NSData *archLow = [NSKeyedArchiver archivedDataWithRootObject:self->_low requiringSecureCoding:YES error:&error];
                    [self->_defaults setObject:archLow forKey:@"lowInToDo"];
                    [self.table reloadData];
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
                    [self->_defaults setObject:archLow forKey:@"medInToDo"];
                    [self.table reloadData];
                }];
                UIAlertAction *cancel =[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}];
                [alert addAction:action];
                [alert addAction:cancel];
                [self presentViewController:alert animated:YES completion:nil];
                break;
            }
            case 2:
            {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Alert" message:@"Confirm delete" preferredStyle:UIAlertControllerStyleActionSheet];
                UIAlertAction *action = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    NSError *error = nil;
                    [self->_high removeObjectAtIndex:indexPath.row];
                    NSData *archLow = [NSKeyedArchiver archivedDataWithRootObject:self->_high requiringSecureCoding:YES error:&error];
                    [self->_defaults setObject:archLow forKey:@"highInToDo"];
                    [self.table reloadData];
                }];
                UIAlertAction *cancel =[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}];
                [alert addAction:action];
                [alert addAction:cancel];
                [self presentViewController:alert animated:YES completion:nil];
                break;
            }
            default:
                switch (indexPath.section) {
                    case 0:
                    {
                        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Alert" message:@"Confirm delete" preferredStyle:UIAlertControllerStyleActionSheet];
                        UIAlertAction *action = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                            NSError *error = nil;
                            [self->_low removeObjectAtIndex:indexPath.row];
                            NSData *archLow = [NSKeyedArchiver archivedDataWithRootObject:self->_low requiringSecureCoding:YES error:&error];
                            [self->_defaults setObject:archLow forKey:@"lowInToDo"];
                            [self.table reloadData];
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
                            [self->_defaults setObject:archLow forKey:@"medInToDo"];
                            [self.table reloadData];
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
                            [self->_defaults setObject:archLow forKey:@"highInToDo"];
                            [self.table reloadData];
                        }];
                        UIAlertAction *cancel =[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}];
                        [alert addAction:action];
                        [alert addAction:cancel];
                        [self presentViewController:alert animated:YES completion:nil];
                        break;
                    }
                }
                break;
        }
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
}
@end
