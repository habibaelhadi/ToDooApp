//
//  DetailsViewController.h
//  ToDoApp
//
//  Created by Habiba Elhadi on 06/05/2025.
//

#import "ViewController.h"
#import "Task.h"
#import "ManageTasks.h"

NS_ASSUME_NONNULL_BEGIN

@interface DetailsViewController : ViewController<ManageTasks>
@property Task *task;
@end

NS_ASSUME_NONNULL_END
