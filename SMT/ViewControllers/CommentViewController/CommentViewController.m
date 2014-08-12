#import "CommentViewController.h"
#import "CommentCell.h"
#import "CreateCommentCell.h"
#import "DataLoader.h"
#import "UIViewController+LoaderCategory.h"

#define CREATE_COMMENT @"create"

@interface CommentViewController ()
{
    DataLoader * dataLoader;
    NSString * photoID;
}
@property (strong, nonatomic) NSArray * commentList;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewHeightConstr;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

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
    }
    // Do any additional setup after loading the view from its nib.
    [self AddActivityIndicator:[UIColor grayColor] forView:self.view];
    [self.collectionView registerNib:[UINib nibWithNibName:@"CommentCell" bundle:nil] forCellWithReuseIdentifier:@"CommentCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"CreateCommentCell" bundle:nil] forCellWithReuseIdentifier:@"CreateCommentCell"];
    dataLoader = [DataLoader instance];
    //self.commentList = [[NSArray alloc]initWithObjects:@"com 1", @"com 2", @"com 3", @"com 4", @"com 5", @"com 6", @"com 7", @"com 8", @"com 9", @"com 10", @"com 11", @"com 12", CREATE_COMMENT, nil];
    //self.commentList = [[NSArray alloc]initWithArray:[dataLoader getCommentsWithPhotoID:photoID]];
    //[dataLoader createComment:@"first comment" withPhoto:photoID];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.commentList.count;
}

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
}

- (void)createComment:(UIButton *)sender
{
    for (UIView * obj in sender.superview.subviews) {
        if ([obj isKindOfClass:[UITextView class]]) {
            NSLog(@"%@",((UITextView *)obj).text);
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)actBack:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end
