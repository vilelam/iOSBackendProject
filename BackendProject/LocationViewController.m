//
//  TaxiStandAddressViewController.m
//  BackendProject
//
//  Created by Marcos Vilela on 06/04/13.
//  Copyright (c) 2013 Marcos Vilela. All rights reserved.
//

#import "LocationViewController.h"

@interface LocationViewController ()

@end

@implementation LocationViewController{
    BOOL searchingLocation;
    BOOL locationNotFound;
}
    

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.bookmark = [[NSMutableArray alloc] initWithObjects:@"rua gabriel santos 151", @"rua major lopes 55", nil];
    self.zeroLocations = [[NSArray alloc] initWithObjects:@"", nil];
    self.searchedLocations = self.zeroLocations;

}   

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)cancelPressed:(id)sender {
    [self.delegate locationViewControllerCancelled:self];
}


#pragma mark - tableView Delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
    
        [self.delegate locationSelected:[self.searchedLocations objectAtIndex:indexPath.row] atViewControler:self];
        
    }else{
        
        //to-do
        //implementar retorno de bookmarked address
        
    }
    
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    static NSString *inventoryTableIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:inventoryTableIdentifier];
    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:inventoryTableIdentifier];
    }
    
    if (tableView  == self.searchDisplayController.searchResultsTableView) {
    
        if (searchingLocation) {
            cell = [self.mainTableView dequeueReusableCellWithIdentifier:@"SearchingCell"];
            UIActivityIndicatorView *activityIndicatorView = (UIActivityIndicatorView*)[cell viewWithTag:100];
            [activityIndicatorView startAnimating];
        }
        else if (locationNotFound){
            cell = [self.mainTableView dequeueReusableCellWithIdentifier:@"LocationNotFound"];
        }
        else{
            cell = [self.mainTableView dequeueReusableCellWithIdentifier:@"Cell"];
            
            id temp = [self.searchedLocations objectAtIndex:indexPath.row];
            
            if ([temp isKindOfClass:[Location class]]) {
                Location *location = temp;
                cell.textLabel.text = location.locationName;
                cell.detailTextLabel.text = location.politicalName;
            }else{
                cell.textLabel.text = @"";
                cell.detailTextLabel.text = @"";
            }
        }
    }
    else{
        cell.textLabel.text = [self.bookmark objectAtIndex:indexPath.row];
    }
    
    return cell;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        
        return self.searchedLocations.count;
        
    }
    else{
        return self.bookmark.count;
    }
    
    
}




#pragma mark - searchBarMethods

- (BOOL) searchDisplayController: (UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString{
    return YES;
}


- (void) searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    searchingLocation = YES;
    locationNotFound = NO;
    
    self.searchedLocations = self.zeroLocations;
    [self.searchDisplayController.searchResultsTableView reloadData];
    
    [Location searchLocations:searchBar.text completionHandler:^(NSError *error, NSArray *locations) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!error) {
                if (locations.count > 0) {
                    self.searchedLocations = locations;
                    searchingLocation = NO;
                    [self.searchDisplayController.searchResultsTableView reloadData];
                }else{
                    locationNotFound = YES;
                    searchingLocation = NO;
                    [self.searchDisplayController.searchResultsTableView reloadData];
                }
                
            }else{
                [Helper showErrorMEUserWithError:error];
            }
            
        });
    }];
}

- (void) searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    searchingLocation = NO;
    locationNotFound = NO;
    self.searchedLocations = self.zeroLocations;
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    locationNotFound = NO;
}

@end
