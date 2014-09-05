#import "CommentViewController.h"
#import "DataLoader.h"
#import "UIViewController+LoaderCategory.h"
#import "CommentHeaderView.h"
#import "Photo.h"
#import "CommentTableViewCell.h"

#define CREATE_COMMENT @"create"

const CGFloat standartHeaderCommentViewHeight = 244;

@interface CommentViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
{
    DataLoader * dataLoader;
    NSString * photoID;
}
@property (strong, nonatomic) NSArray * commentList;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewHeightConstr;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewVerticalConstr;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstr;
@property (strong, nonatomic) UITextField *activeTextField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet CommentHeaderView *commentHeaderView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
- (void)createComment:(id)sender;
- (IBAction)actBack:(UIButton *)sender;
@end

@implementation CommentViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil forImageID:(NSString *)photo_id
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        photoID = photo_id;
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
    //self.commentList = [[NSArray alloc]initWithObjects:@"com 1", @"com 2", @"com 3", @"com 4", @"com 5", @"com 6", @"com 7", @"com 8", @"com 9", @"com 10", @"com 11", @"com 12", CREATE_COMMENT, nil];
    //self.commentList = [[NSArray alloc]initWithArray:[dataLoader getCommentsWithPhotoID:photoID]];
    //[dataLoader createComment:@"first comment" withPhoto:photoID];
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
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //return self.commentList.count;
    return 5;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = (CommentTableViewCell*) [tableView dequeueReusableCellWithIdentifier:@"CommentTableViewCell" forIndexPath:indexPath];
    return cell;
}


/*
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * str = [self.commentList objectAtIndex:indexPath.row];
    if ([str isEqualToString:CREATE_COMMENT]) {
        UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CreateCommentCell" forIndexPath:indexPath];
        [((CreateCommentCell *)cell).btnSend addTarget:self action:@selector(createComment:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CommentCell" forIndexPath:indexPath];
    ((CommentCell *)cell).lbComment.text = str;
    return cell;
}*/

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
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark Keabord methods

-(void) registerForKeyboardNotifications{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
}

-(void) keyboardWasShown: (NSNotification*) notification{
    NSDictionary * info = [notification userInfo];
    CGSize keyboardSize = [self.view convertRect:[[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue] fromView:self.view.window].size;
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize.height + self.bottomView.frame.size.height, 0.0);
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
    UIEdgeInsets edgeInsets = UIEdgeInsetsZero;
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
