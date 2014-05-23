//
//  InviteFriendCell.m
//  HunterPredictor
//
//  Created by Admin on 4/2/14.
//  Copyright (c) 2014 mobilesoft365. All rights reserved.
//

#import "InviteCell.h"
#import "DataLoader.h"
#import "InviteFriendViewController.h"

@interface InviteCell ()

@property (nonatomic, weak) IBOutlet UILabel * nameLabel;
@property (nonatomic, weak) IBOutlet UILabel * emailLabel;

@end

@implementation InviteCell

-(void) processCellWithName: (NSString*) _name andEmail: (NSString*) _email{
    self.nameLabel.text = _name;
    self.emailLabel.text = _email;
}

-(IBAction)inviteAction:(id)sender{
    DataLoader * loader = [DataLoader instance];
    dispatch_queue_t newQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(newQueue, ^(){
        [loader sendInvitationEmailWithEmail:self.emailLabel.text andName:self.nameLabel.text];
         dispatch_async(dispatch_get_main_queue(), ^(){
             UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"The invitation\n has been sent" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
             [alert show];
         });
    });
}

@end
