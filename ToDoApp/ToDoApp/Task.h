//
//  Task.h
//  ToDoApp
//
//  Created by Habiba Elhadi on 06/05/2025.
//
#import <Foundation/Foundation.h>
#ifndef Task_h
#define Task_h

@interface Task : NSObject<NSCoding,NSSecureCoding>
@property NSString *name;
@property NSString *desc;
@property int priority;
@property int status;
@property NSString *date;
@property NSString *taskId;
-(instancetype)initWithName:(NSString *)n desc:(NSString *)d priority:(int)p status:(int)s date:(NSString *)date taskId:(NSString *)i;
-(void)encodeWithCoder:(NSCoder*)encoder;
@end

#endif /* Task_h */
