//
//  RadiusViewController.m
//  BackendProject
//
//  Created by Marcos Vilela on 26/03/13.
//  Copyright (c) 2013 Marcos Vilela. All rights reserved.
//

#import "RadiusViewController.h"

@interface RadiusViewController ()

@end

@implementation RadiusViewController


- (void)viewDidLoad
{
    [super viewDidLoad];

    //to-do
    //implementar chamada do serviço que retornará as distancias em km ou miles
    
//    [Car retrieverCarTypes:^(NSArray *carTypes, NSError *error) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            if (!error) {
//                self.carTypeArray = carTypes;
//                [self.tableView reloadData];
//            }else{
//                
//                [Helper showErrorMEUser:[[error userInfo] objectForKey:@"error"]];
//            }
//            
//        });
//        
//    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancelPressed:(id)sender {
    [[self delegate] radiusViewControllerHasDone:self];
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
    return [self.radiusArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    
//    cell.textLabel.text = [(Car*)[self.carTypeArray objectAtIndex:indexPath.row] description];
    
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

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Car *car = [self.carTypeArray objectAtIndex:indexPath.row];
    //[[self delegate] carTypeSelected:car AtViewController:self];
}

@end
