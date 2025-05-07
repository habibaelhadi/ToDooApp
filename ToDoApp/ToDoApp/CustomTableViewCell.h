//
//  CustomTableViewCell.h
//  ToDoApp
//
//  Created by Habiba Elhadi on 06/05/2025.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CustomTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *toDoView;
@property (weak, nonatomic) IBOutlet UILabel *toDoLabel;
@property (weak, nonatomic) IBOutlet UIView *inProgView;
@property (weak, nonatomic) IBOutlet UILabel *inProgLabel;
@property (weak, nonatomic) IBOutlet UIView *doneView;
@property (weak, nonatomic) IBOutlet UILabel *doneLabel;
@end

NS_ASSUME_NONNULL_END
