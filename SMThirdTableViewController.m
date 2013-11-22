//
//  SMFourthTableViewController.m
//  Drag
//
//  Created by Michael Morris on 11/21/13.
//  Copyright (c) 2013 Michael Morris. All rights reserved.
//

#import "SMThirdTableViewController.h"
#import "SMSlideGestureRecognizer.h"

@interface SMThirdTableViewController ()
@property (strong, nonatomic) NSArray* model;
@end

@implementation SMThirdTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	_model = @[@{@"title":@"first", @"subtitle":@"first subtitle"},
			   @{@"title":@"second", @"subtitle":@"second subtitle"},
			   @{@"title":@"third", @"subtitle":@"third subtitle"},
			   @{@"title":@"fourth", @"subtitle":@"fourth subtitle"},
			   @{@"title":@"fifth", @"subtitle":@"fifth subtitle"},
			   @{@"title":@"sixth", @"subtitle":@"sixth subtitle"},
			   @{@"title":@"seventh", @"subtitle":@"seventh subtitle"},
			   @{@"title":@"eighth", @"subtitle":@"eighth subtitle"},
			   @{@"title":@"ninth", @"subtitle":@"ninth subtitle"},
			   @{@"title":@"tenth", @"subtitle":@"tenth subtitle with an extra long subtitle"},
			   @{@"title":@"eleventh", @"subtitle":@"eleventh subtitle"},
			   @{@"title":@"twelveth", @"subtitle":@"twelveth subtitle"},
			   @{@"title":@"thirteenth", @"subtitle":@"thirteenth subtitle"},
			   @{@"title":@"fourteenth", @"subtitle":@"fourteenth subtitle"},
			   @{@"title":@"fifteenth", @"subtitle":@"fifteenth subtitle"},
			   @{@"title":@"sixteenth", @"subtitle":@"sixteenth subtitle"},
			   @{@"title":@"seventeenth", @"subtitle":@"seventeenth subtitle"},
			   @{@"title":@"eighteenth", @"subtitle":@"eighteenth subtitle"},
			   @{@"title":@"ninteenth", @"subtitle":@"ninteenth subtitle"},
			   @{@"title":@"twentieth", @"subtitle":@"twentieth subtitle"},
			   @{@"title":@"twentyfirst", @"subtitle":@"twentyfirst subtitle"},
			   @{@"title":@"twentysecond", @"subtitle":@"twentysecond subtitle"},
			   @{@"title":@"thentythird", @"subtitle":@"thentythird subtitle"},
			   @{@"title":@"twentyfourth", @"subtitle":@"twentyfourth subtitle"},
			   @{@"title":@"twentyfifth", @"subtitle":@"twentyfifth subtitle"},
			   @{@"title":@"twentysixth", @"subtitle":@"twentysixth subtitle"},
			   @{@"title":@"twentyseventh", @"subtitle":@"twentyseventh subtitle"},
			   @{@"title":@"twentyeighth", @"subtitle":@"twentyeighth subtitle"},
			   @{@"title":@"twentyninth", @"subtitle":@"twentyninth subtitle"},
			   @{@"title":@"thirtieth", @"subtitle":@"thirtieth subtitle"}];
	

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
- (IBAction)gestureRecognized:(id)sender {
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return _model.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"FourthTabCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSDictionary* cellData = _model[indexPath.row];
	NSString* title = cellData[@"title"];
	NSString* subtitle = cellData[@"subtitle"];
	cell.textLabel.text = title;
	cell.detailTextLabel.text = subtitle;
	
	SMSlideGestureRecognizer* recog =[[SMSlideGestureRecognizer alloc] initWithTarget:self
																			   action:@selector(accessoryButtonTouched:)];
	//	recog.slideWidth = 120.0;
	[cell.contentView addGestureRecognizer:recog];
    
    return cell;
}

-(void)accessoryButtonTouched:(SMSlideGestureRecognizer*)sender {
	if(sender.state == UIGestureRecognizerStateEnded) {
		UIView* view = sender.view;
		while(![view isKindOfClass:[UITableViewCell class]]) {
			view = view.superview;
		}
		if(view) {
			UITableViewCell* cell = (UITableViewCell*)view;
			NSIndexPath* indexPath =[self.tableView indexPathForCell:cell];
			NSInteger buttonIndex = sender.selectedButtonIndex;
			NSLog(@"accessoryButtonTouched indexPath %@  button %d", indexPath, buttonIndex);
			NSString* buttonLabel = [sender buttonLabelForIndex:buttonIndex];
			NSString* message = [NSString stringWithFormat:@"Accessory button in cell %d-%d with label %@ was touched", indexPath.section, indexPath.row, buttonLabel];
			UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Accessory Button Touched"
												message:message
											   delegate:nil
									  cancelButtonTitle:@"Ok"
									  otherButtonTitles:nil];
			[alert show];
		}
	}
}



/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
