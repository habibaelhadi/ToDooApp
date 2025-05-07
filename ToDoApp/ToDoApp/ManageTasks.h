//
//  ManageTasks.h
//  ToDoApp
//
//  Created by Habiba Elhadi on 07/05/2025.
//

#import <Foundation/Foundation.h>
#import "Task.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ManageTasks <NSObject>
@optional
-(void)insertTask:(Task *)task withPriority : (int)priority;
-(void)editTask:(Task *)task withPriority : (int)priority andStatus : (int) status;
@end

NS_ASSUME_NONNULL_END
