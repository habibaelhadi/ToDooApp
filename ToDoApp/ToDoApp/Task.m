//
//  Task.m
//  ToDoApp
//
//  Created by Habiba Elhadi on 06/05/2025.
//

#import "Task.h"

@implementation Task

- (instancetype)initWithName:(NSString *)n desc:(NSString *)d priority:(int)p status:(int)s date:(NSString *)date taskId:(NSString *)i{
    self = [super init];
        if(self){
            _name = n;
            _desc = d;
            _priority = p;
            _status = s;
            _date = date;
            _taskId = i;
        }
        return self;
}

-(void)encodeWithCoder:(NSCoder*)encoder{
    [encoder encodeObject:_name forKey:@"name"];
    [encoder encodeObject:_desc forKey:@"desc"];
    [encoder encodeInt:_priority forKey:@"priority"];
    [encoder encodeInt:_status forKey:@"status"];
    [encoder encodeObject:_date forKey:@"date"];
    [encoder encodeObject:_taskId forKey:@"id"];
}

- (nullable instancetype)initWithCoder:(NSCoder *)coder {
    self = [super init];
    if (self) {
        _name = [coder decodeObjectOfClass:[NSString class] forKey:@"name"];
        _desc = [coder decodeObjectOfClass:[NSString class] forKey:@"desc"];
        _priority = [coder decodeIntForKey: @"priority"];
        _status = [coder decodeIntForKey:@"status"];
        _date = [coder decodeObjectOfClass:[NSString class] forKey:@"date"];
        _taskId = [coder decodeObjectOfClass:[NSString class] forKey:@"id"];
    }
    return self;
}

+(BOOL)supportsSecureCoding{
    return YES;
}


@end
