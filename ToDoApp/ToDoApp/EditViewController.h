//
//  EditViewController.h
//  ToDoApp
//
//  Created by Habiba Elhadi on 07/05/2025.
//

#import "ViewController.h"
#import "Task.h"
#import "ManageTasks.h"

NS_ASSUME_NONNULL_BEGIN

@interface EditViewController : ViewController
@property Task *task;
@property id<ManageTasks> ref;
@end

NS_ASSUME_NONNULL_END
