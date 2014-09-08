#import "CommentViewController.h"
#import "DataLoader.h"
#import "UIViewController+LoaderCategory.h"
#import "CommentHeaderView.h"
#import "CommentTableViewCell.h"

#define CREATE_COMMENT @"create"

const CGFloat standartHeaderCommentViewHeight = 244;

@interface CommentViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
{
    DataLoader * dataLoader;
    Photo * _photo;
}
@property (strong, nonatomic) NSArray * commentList;

@property (weak, nonatomic) IBOutlet UITextField *messageTextField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewHeightConstr;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewVerticalConstr;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstr;
@property (strong, nonatomic) UITextField *activeTextField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet CommentHeaderView *commentHeaderView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
- (void)createComment:(id)sender;
- (IBAction)actBack:(UIButton *)sender;
- (IBAction)actSend:(id)sender;
- (void)updateComments;
@end

@implementation CommentViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil forPhoto:(Photo *)photo
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _photo = photo;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0){
        self.topViewHeightConstr.constant -= 20;
        self.topViewVerticalConstr.constant -=20;
    }
    [self AddActivityIndicator:[UIColor grayColor] forView:self.view];
    dataLoader = [DataLoader instance];
    [self.tableView registerNib:[UINib nibWithNibName:@"CommentTableViewCell" bundle:nil] forCellReuseIdentifier:@"CommentTableViewCell"];
    [self updateComments];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self registerForKeyboardNotifications];
    [self setTableHeaderView];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)setTableHeaderView
{
    if (self.photo && self.photo.description.length != 0){
        float viewHeight = [self getWidthText:self.photo.description andLabel:self.commentHeaderView.descriptionLabel];
        UIView *headerView = self.tableView.tableHeaderView;
        headerView.frame = CGRectMake(0,0,self.tableView.tableHeaderView.frame.size.width,standartHeaderCommentViewHeight + viewHeight);
        [self.tableView setTableHeaderView:headerView];
    }
    [self.commentHeaderView initWithPhoto:_photo];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.commentList.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = (CommentTableViewCell*) [tableView dequeueReusableCellWithIdentifier:@"CommentTableViewCell" forIndexPath:indexPath];
    NSDictionary * buff = [self.commentList objectAtIndex:indexPath.row];
    [((CommentTableViewCell*)cell) initWithData:buff];
    return cell;
}


- (float) getWidthText:(NSString *)str andLabel: (UILabel*)label
{
    float f = 0;
    
    if (str) {
        CGSize contentTextSize = [str sizeWithFont:label.font
                                 constrainedToSize:CGSizeMake(label.frame.size.width, MAXFLOAT)
                                     lineBreakMode:NSLineBreakByWordWrapping];
        
        f = contentTextSize.width;
        
    }
    return f;
}

- (void)createComment:(UIButton *)sender
{
    for (UIView * obj in sender.superview.subviews) {
        if ([obj isKindOfClass:[UITextView class]]) {
            NSLog(@"%@",((UITextView *)obj).text);
        }
    }
}

- (IBAction)actBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)actSend:(id)sender {
    if (self.messageTextField.text.length > 0) {
        dispatch_queue_t newQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(newQueue, ^(){
            [dataLoader createComment:self.messageTextField.text withPhoto:[_photo.photoID intValue]];
            dispatch_async(dispatch_get_main_queue(), ^(){
                
                if(!dataLoader.isCorrectRezult) {
                    NSLog(@"Error create comment");
                } else {
                    self.messageTextField.text = @"";
                    [self.messageTextField resignFirstResponder];
                    [self updateComments];
                }
            });
        });
    }
}

- (void) updateComments
{
    [self startLoader];
    dispatch_queue_t newQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(newQueue, ^(){
        self.commentList = [[NSArray alloc]initWithArray:[dataLoader getCommentsWithPhotoID:[_photo.photoID intValue]]];
    dispatch_async(dispatch_get_main_queue(), ^(){
        
        if(!dataLoader.isCorrectRezult) {
            NSLog(@"Error download comment");
            [self endLoader];
        } else {
            [self.tableView reloadData];
            [self endLoader];
        }
    });
});

}

#pragma mark Keabord methods

-(void) registerForKeyboardNotifications{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
}

-(void) keyboardWasShown: (NSNotification*) notification{
    NSDictionary * info = [notification userInfo];
    CGSize keyboardSize = [self.view convertRect:[[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue] fromView:self.view.window].size;
    //UIEdgeInsets edgeInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize.height + self.bottomView.frame.size.height, 0.0);
    /*self.tableView.contentInset = edgeInsets;
    self.tableView.scrollIndicatorInsets = edgeInsets;
    
    
    CGRect aRect = self.view.frame;
    aRect.size.height -= keyboardSize.height;*/
    
    //if (!CGRectContainsPoint(aRect, self.activeTextField.frame.origin)){
    //[self.tableView scrollRectToVisible:self.activeTextField.frame animated:YES];
    //}
    
    self.bottomConstr.constant = self.bottomView.frame.origin.y - keyboardSize.height;
    [UIView animateWithDuration:0.5 animations:^(){
        [self.view layoutIfNeeded];
    }];
}

-(void) keyboardWillBeHidden: (NSNotification*) notification{
    //UIEdgeInsets edgeInsets = UIEdgeInsetsZero;
    /*self.tableView.contentInset = edgeInsets;
    self.tableView.scrollIndicatorInsets = edgeInsets;*/
    self.bottomConstr.constant = 0;
    [UIView animateWithDuration:0.5 animations:^(){
        [self.view layoutIfNeeded];
    }];
}

-(void) textFieldDidBeginEditing:(UITextField *)textField{
    self.activeTextField = textField;
}

-(void) textFieldDidEndEditing:(UITextField *)textField{
    self.activeTextField = nil;
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    return YES;
}

@end
