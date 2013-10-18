//
//  TableViewController.m
//  ToDoList
//
//  Created by ppanda on 10/13/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "TableViewController.h"
#import "CustomCell.h"


@interface TableViewController ()
    
- (IBAction)onTap:(id)sender;
@end



@implementation TableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        self.title = @"My To-Do List";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    editableItems = [[NSMutableArray alloc] initWithCapacity:0];
    
    UINib *customNib = [UINib nibWithNibName:@"CustomCell" bundle:nil];
    [self.tableView registerNib:customNib forCellReuseIdentifier:@"CustomCell"];
    
    // add the edit and + buttons
    self.navigationController.navigationBar.tintColor = [[UIColor alloc] initWithRed:32.0 / 255 green:14.0 / 255 blue:53.0 / 255 alpha:1.0];
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd 
                                                                                           target:self action:@selector(onAddButtonClicked)];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    [editableItems release];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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
    int editableItemsCount = [editableItems count];
    return editableItemsCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CustomCell";
    CustomCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    int editableItemsIndex = [indexPath indexAtPosition:1];
    cell.editableField.text = [editableItems objectAtIndex:editableItemsIndex];
    cell.editableField.delegate = self;
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source        
        //[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        int editableItemsIndex = [indexPath indexAtPosition:1];
        if ( ([editableItems count] == 0) || (editableItemsIndex >= [editableItems count] ) )
        {
            NSLog(@"houston we have a problem ... ");
            return;
        }
        [editableItems removeObjectAtIndex:editableItemsIndex];
        [self printArray];
        [tableView reloadData];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        NSLog (@"Insert mode");
    }   
}


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


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
    
    int editableItemsIndex = [indexPath indexAtPosition:1];
    //[editableItems replaceObjectAtIndex:editableItemsIndex withObject:MyNewObject;
    NSLog(@"didSelectRowAtIndexPath %d ", editableItemsIndex );
}



#pragma mark - UI Text Field delegate

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    return true;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:TRUE]; 
    return true;
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self onEditingDone:textField];
}



#pragma mark - methods

-(int)onEditingDone:(UITextField *)textField
{
    // get the index of textfield that we edited
    NSIndexPath *indexPath = [self.tableView indexPathForCell:(CustomCell*)[[textField superview] superview]];
    int editableItemsIndex = [indexPath indexAtPosition:1];
    // sanity check to make sure still there
    int editableItemsCount = [editableItems count];
    if ( (editableItemsCount==0) || (editableItemsIndex >= editableItemsCount) )
    {
        return -1;
    }
    
    // get the string from the cell and store in array
    NSString *textFieldString = textField.text;
    [editableItems replaceObjectAtIndex:editableItemsIndex withObject:textFieldString];
    [self printArray];
    return editableItemsIndex;
}


-(void)onAddButtonClicked 
{
    NSString *string = [[NSString alloc]initWithString:@""];
    [editableItems addObject:string];		//Add to end of array
    [self printArray];
    [self.tableView reloadData];
}


// Debug function to print the NSArray
-(void)printArray
{
    int editableItemCount = [editableItems count];
    NSLog( @" items in array %d ", editableItemCount );
    for ( int i=0; i< editableItemCount; i++ )
    {
        NSString *string = [editableItems objectAtIndex:i];
        NSLog(@"  At [ %d ] string is %s ", i, string.cString );
    }
}


- (IBAction)onTap:(id)sender 
{
    NSLog(@"someone's tapping me  ");
}
@end
