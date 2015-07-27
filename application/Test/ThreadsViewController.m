//
//  ThreadsViewController.m
//  Test
//
//  Created by Pavel Deminov on 15/07/15.
//  Copyright (c) 2015 Company. All rights reserved.
//

#import "ThreadsViewController.h"
#import "Person+Extended.h"

#define kThreadExitNow @"kThreadExitNow"
#define RAND_FROM_TO(min, max) (min + arc4random_uniform(max - min + 1))

#define kLabelObject @"kLabelObject"
#define kLabelValue @"kLabelValue"

@interface ThreadsViewController () <UITableViewDataSource,UITableViewDelegate> {
    IBOutlet UITableView *_tableView;
}

@property (nonatomic,strong) NSArray *personsArray;
@property (nonatomic,strong) NSMutableArray *personsArrayInTable;
@property (nonatomic,strong) NSThread *selectCellThread;

@end

#pragma mark ViewController Base Methods

@implementation ThreadsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self fillTestData];
    self.navigationItem.title = @"Threads";
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) dealloc {
    
    
}

- (void)viewWillDisappear:(BOOL)animated {
    NSArray *viewControllers = self.navigationController.viewControllers;
    if (viewControllers.count > 1 && [viewControllers objectAtIndex:viewControllers.count-2] == self) {
        // View is disappearing because a new view controller was pushed onto the stack
        //NSLog(@"New view controller was pushed");
    } else if ([viewControllers indexOfObject:self] == NSNotFound) {
        // View is disappearing because it was popped from the stack
        //NSLog(@"View controller was popped");
        
        NSMutableDictionary* threadDict = [self.selectCellThread threadDictionary];
        [threadDict setValue:[NSNumber numberWithBool:YES] forKey:kThreadExitNow];
        self.selectCellThread = nil;
        
    }
}

#pragma mark ViewController Actions

-(IBAction)switcherValueChanged:(id)sender {
    
    UISwitch *sw = sender;
    
    if (sw.isOn) {
        
        self.selectCellThread = [[NSThread alloc] initWithTarget:self selector:@selector(cellSelector) object:nil];
        NSMutableDictionary* threadDict = [self.selectCellThread threadDictionary];
        [threadDict setValue:[NSNumber numberWithBool:NO] forKey:kThreadExitNow];
        [self.selectCellThread start];
    } else {
        
        if (self.selectCellThread !=nil) {
        
            NSMutableDictionary* threadDict = [self.selectCellThread threadDictionary];
            [threadDict setValue:[NSNumber numberWithBool:YES] forKey:kThreadExitNow];
            self.selectCellThread = nil;
            
        }
        
    }
    
}

#pragma mark UITableView Delegate & DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _personsArrayInTable.count;
    
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"PersonCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    Person *person =[_personsArrayInTable objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ is from %@",person.name,person.country];
    
    return cell;
    
    
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark Private Methods

-(void) fillTestData {
    
    NSArray  *dictArray = @[
                            @{kPersonID:[NSNumber numberWithInt:0],kPersonName:@"Alex",kPersonCountry:@"Canada"},
                            @{kPersonID:[NSNumber numberWithInt:1],kPersonName:@"John",kPersonCountry:@"USA"},
                            @{kPersonID:[NSNumber numberWithInt:2],kPersonName:@"Olga",kPersonCountry:@"Russia"},
                            @{kPersonID:[NSNumber numberWithInt:3],kPersonName:@"Rada",kPersonCountry:@"France"},
                            @{kPersonID:[NSNumber numberWithInt:4],kPersonName:@"Tamoko",kPersonCountry:@"Japan"},
                            @{kPersonID:[NSNumber numberWithInt:5],kPersonName:@"Rodrigo",kPersonCountry:@"Spain"},
                            @{kPersonID:[NSNumber numberWithInt:6],kPersonName:@"Lee",kPersonCountry:@"China"},
                            @{kPersonID:[NSNumber numberWithInt:7],kPersonName:@"Mario",kPersonCountry:@"Mexico"},
                            @{kPersonID:[NSNumber numberWithInt:8],kPersonName:@"Ong",kPersonCountry:@"Thailand"},
                            @{kPersonID:[NSNumber numberWithInt:9],kPersonName:@"An",kPersonCountry:@"Vietnam"},
                            @{kPersonID:[NSNumber numberWithInt:10],kPersonName:@"Park",kPersonCountry:@"Korea"},
                            @{kPersonID:[NSNumber numberWithInt:11],kPersonName:@"Hanz",kPersonCountry:@"Germany"},
                            @{kPersonID:[NSNumber numberWithInt:12],kPersonName:@"Konchita",kPersonCountry:@"Chili"},
                            
                            ];
    
    NSMutableArray *tmpPersons = [NSMutableArray new];
    
    for (NSDictionary *dict in dictArray) {
        Person *person = [Person new];
        [person updateWithDict:dict];
        [tmpPersons addObject:person];
    }
    
    self.personsArray =tmpPersons;
    
    tmpPersons = [NSMutableArray new];
    
    for (int i=0;i<30;i++) {
        NSInteger random = RAND_FROM_TO(0, (int)(_personsArray.count-1));
        Person *person = _personsArray[random];
        [tmpPersons addObject:person];
    }
    
    self.personsArrayInTable =tmpPersons;
    
    [_tableView reloadData];
    
}

#pragma mark Thread for select cell

-(void) cellSelector {
    
    bool exitNow = NO;
    while (exitNow == NO) {
        
       // NSLog(@"%@",[NSDate date]);
        
        [NSThread detachNewThreadSelector:@selector(changeCellValues) toTarget:self withObject:nil];
        [NSThread sleepForTimeInterval: 3];
        
        NSMutableDictionary* threadDict = [[NSThread currentThread] threadDictionary];
        exitNow = [[threadDict objectForKey:kThreadExitNow] boolValue];
       //NSLog(@"%@",[threadDict objectForKey:kThreadExitNow]);
        
    }
    
    
}

#pragma mark Thread for change letters in cell

-(void) changeCellValues{
    
    NSArray *visibleCells = [_tableView visibleCells];
    NSInteger randomCell = RAND_FROM_TO(0, (int)(visibleCells.count-1));
    UITableViewCell *cell = [visibleCells objectAtIndex:randomCell];

    
    NSInteger random = RAND_FROM_TO(0, (int)(_personsArray.count-1));
    Person *person = [_personsArray objectAtIndex:random];
    _personsArrayInTable[ [_tableView indexPathForCell:cell].row ] = person;
    
    NSString *title = [NSString stringWithFormat:@"%@ is from %@",person.name,person.country];
    
    for (int i=0; i<title.length+1; i++) {
        
        NSString *cuttedTitle  =[title substringToIndex:i];
        //NSLog(@"%@",[person.name substringWithRange:range]);
        NSDictionary *params = @{kLabelObject:cell.textLabel,kLabelValue:cuttedTitle};
        [NSThread detachNewThreadSelector:@selector(changeLetterAsync:) toTarget:self withObject:params];
        
        [NSThread sleepForTimeInterval: 0.1f];
    }
    
    
    //NSLog(@"1");
}

#pragma mark Thread for  change one letter In Cell

-(void) changeLetterAsync:(NSDictionary*)params {
    
    UILabel *lbl = [params objectForKey:kLabelObject];
    lbl.text = [params objectForKey:kLabelValue];
    
}

@end
