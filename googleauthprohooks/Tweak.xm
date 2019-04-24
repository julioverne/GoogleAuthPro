#import <dlfcn.h>
#import <objc/runtime.h>
#import <notify.h>
#import <substrate.h>
#import <prefs.h>

#define NSLog(...)

static BOOL Enabled;
static BOOL alphabeticallyEnabled;
static BOOL alphabeticallyShowSection;
static BOOL searchEnabled;
static BOOL compactStyleEnabled;
static BOOL safariURLEnabled;
static int codeFontSize;

@interface NSUserDefaults ()
- (id)objectForKey:(NSString *)key inDomain:(NSString *)domain;
- (void)setObject:(id)value forKey:(NSString *)key inDomain:(NSString *)domain;
@end

@interface GoogleAuthProController : PSListController
@end



@implementation GoogleAuthProController
- (id)specifiers {
	if (!_specifiers) {
		NSMutableArray* specifiers = [NSMutableArray array];
		PSSpecifier* spec;
		
		spec = [PSSpecifier emptyGroupSpecifier];
        [specifiers addObject:spec];
		spec = [PSSpecifier emptyGroupSpecifier];
        [specifiers addObject:spec];
		spec = [PSSpecifier emptyGroupSpecifier];
        [specifiers addObject:spec];
		
		spec = [PSSpecifier preferenceSpecifierNamed:@"Enabled"
                                                  target:self
											         set:@selector(setPreferenceValue:specifier:)
											         get:@selector(readPreferenceValue:)
                                                  detail:Nil
											        cell:PSSwitchCell
											        edit:Nil];
		[spec setProperty:@"Enabled" forKey:@"key"];
		[spec setProperty:@YES forKey:@"default"];
        [specifiers addObject:spec];
		
		
		spec = [PSSpecifier preferenceSpecifierNamed:@"Style"
		                                      target:self
											  set:Nil
											  get:Nil
                                              detail:Nil
											  cell:PSGroupCell
											  edit:Nil];
		[spec setProperty:@"Style" forKey:@"label"];
        [specifiers addObject:spec];
		spec = [PSSpecifier preferenceSpecifierNamed:@"Code Font Size"
                                              target:self
											  set:@selector(setPreferenceValue:specifier:)
											  get:@selector(readPreferenceValue:)
                                              detail:PSListItemsController.class
											  cell:PSLinkListCell
											  edit:Nil];
		[spec setProperty:@"codeFontSize" forKey:@"key"];
		[spec setProperty:@(0) forKey:@"default"];
		NSMutableArray* valuesSize = [NSMutableArray array];
		NSMutableArray* nameSize = [NSMutableArray array];
		for(int i = 0; i < 100; i++) {
			[valuesSize addObject:@(i)];
			if(i==0) {
				[nameSize addObject:@"Default"];
			} else {
				[nameSize addObject:[@(i) stringValue]];
			}
		}
		[spec setValues:valuesSize titles:nameSize];
		[specifiers addObject:spec];
		spec = [PSSpecifier preferenceSpecifierNamed:@"Compact Style"
                                                  target:self
											         set:@selector(setPreferenceValue:specifier:)
											         get:@selector(readPreferenceValue:)
                                                  detail:Nil
											        cell:PSSwitchCell
											        edit:Nil];
		[spec setProperty:@"compactStyleEnabled" forKey:@"key"];
		[spec setProperty:@NO forKey:@"default"];
        [specifiers addObject:spec];
		
		spec = [PSSpecifier preferenceSpecifierNamed:@"Search"
		                                      target:self
											  set:Nil
											  get:Nil
                                              detail:Nil
											  cell:PSGroupCell
											  edit:Nil];
		[spec setProperty:@"Search" forKey:@"label"];
        [specifiers addObject:spec];
		spec = [PSSpecifier preferenceSpecifierNamed:@"Enabled"
                                                  target:self
											         set:@selector(setPreferenceValue:specifier:)
											         get:@selector(readPreferenceValue:)
                                                  detail:Nil
											        cell:PSSwitchCell
											        edit:Nil];
		[spec setProperty:@"searchEnabled" forKey:@"key"];
		[spec setProperty:@YES forKey:@"default"];
        [specifiers addObject:spec];		
		
		spec = [PSSpecifier preferenceSpecifierNamed:@"Order Alphabetically"
		                                      target:self
											  set:Nil
											  get:Nil
                                              detail:Nil
											  cell:PSGroupCell
											  edit:Nil];
		[spec setProperty:@"Order Alphabetically" forKey:@"label"];
        [specifiers addObject:spec];
		spec = [PSSpecifier preferenceSpecifierNamed:@"Enabled"
                                                  target:self
											         set:@selector(setPreferenceValue:specifier:)
											         get:@selector(readPreferenceValue:)
                                                  detail:Nil
											        cell:PSSwitchCell
											        edit:Nil];
		[spec setProperty:@"alphabeticallyEnabled" forKey:@"key"];
		[spec setProperty:@YES forKey:@"default"];
        [specifiers addObject:spec];
		spec = [PSSpecifier preferenceSpecifierNamed:@"Show Section"
                                                  target:self
											         set:@selector(setPreferenceValue:specifier:)
											         get:@selector(readPreferenceValue:)
                                                  detail:Nil
											        cell:PSSwitchCell
											        edit:Nil];
		[spec setProperty:@"alphabeticallyShowSection" forKey:@"key"];
		[spec setProperty:@YES forKey:@"default"];
        [specifiers addObject:spec];
		
		spec = [PSSpecifier preferenceSpecifierNamed:@"Safari Website Detect"
		                                      target:self
											  set:Nil
											  get:Nil
                                              detail:Nil
											  cell:PSGroupCell
											  edit:Nil];
		[spec setProperty:@"Safari Website Detect" forKey:@"label"];
		[spec setProperty:@"Auto Navigate To Current Safari Website When You Open Google Authenticator App." forKey:@"footerText"];
        [specifiers addObject:spec];
		spec = [PSSpecifier preferenceSpecifierNamed:@"Enabled"
                                                  target:self
											         set:@selector(setPreferenceValue:specifier:)
											         get:@selector(readPreferenceValue:)
                                                  detail:Nil
											        cell:PSSwitchCell
											        edit:Nil];
		[spec setProperty:@"safariURLEnabled" forKey:@"key"];
		[spec setProperty:@YES forKey:@"default"];
        [specifiers addObject:spec];
		
		spec = [PSSpecifier preferenceSpecifierNamed:@"Apply Changes"
		                                      target:self
											  set:Nil
											  get:Nil
                                              detail:Nil
											  cell:PSGroupCell
											  edit:Nil];
		[spec setProperty:@"Apply Changes" forKey:@"label"];
		[spec setProperty:@"Some Changes Requires Application Restart" forKey:@"footerText"];
        [specifiers addObject:spec];
		spec = [PSSpecifier preferenceSpecifierNamed:@"Restart App"
                                              target:self
                                                 set:NULL
                                                 get:NULL
                                              detail:Nil
                                                cell:PSLinkCell
                                                edit:Nil];
        spec->action = @selector(restart);
        [specifiers addObject:spec];
		
		
		spec = [PSSpecifier emptyGroupSpecifier];
        [specifiers addObject:spec];
		
		spec = [PSSpecifier preferenceSpecifierNamed:@"Reset Settings"
                                              target:self
                                                 set:NULL
                                                 get:NULL
                                              detail:Nil
                                                cell:PSLinkCell
                                                edit:Nil];
        spec->action = @selector(reset);
        [specifiers addObject:spec];
		spec = [PSSpecifier preferenceSpecifierNamed:@"Developer"
		                                      target:self
											  set:Nil
											  get:Nil
                                              detail:Nil
											  cell:PSGroupCell
											  edit:Nil];
		[spec setProperty:@"Developer" forKey:@"label"];
        [specifiers addObject:spec];
		spec = [PSSpecifier preferenceSpecifierNamed:@"Follow julioverne"
                                              target:self
                                                 set:NULL
                                                 get:NULL
                                              detail:Nil
                                                cell:PSLinkCell
                                                edit:Nil];
        spec->action = @selector(twitter);
		[spec setProperty:[NSNumber numberWithBool:TRUE] forKey:@"hasIcon"];
		[spec setProperty:[UIImage imageWithContentsOfFile:[[self bundle] pathForResource:@"twitter" ofType:@"png"]] forKey:@"iconImage"];
        [specifiers addObject:spec];
		spec = [PSSpecifier emptyGroupSpecifier];
        [spec setProperty:@"GoogleAuthPro © 2018" forKey:@"footerText"];
        [specifiers addObject:spec];
		_specifiers = [specifiers copy];
	}
	return _specifiers;
}
- (void)restart
{
	exit(0);
}
- (void)twitter
{
	UIApplication *app = [UIApplication sharedApplication];
	if ([app canOpenURL:[NSURL URLWithString:@"twitter://user?screen_name=ijulioverne"]]) {
		[app openURL:[NSURL URLWithString:@"twitter://user?screen_name=ijulioverne"]];
	} else if ([app canOpenURL:[NSURL URLWithString:@"tweetbot:///user_profile/ijulioverne"]]) {
		[app openURL:[NSURL URLWithString:@"tweetbot:///user_profile/ijulioverne"]];		
	} else {
		[app openURL:[NSURL URLWithString:@"https://mobile.twitter.com/ijulioverne"]];
	}
}
- (void)reset
{
	[[NSUserDefaults standardUserDefaults] removePersistentDomainForName:@"com.julioverne.googleauthpro"];
	[self reloadSpecifiers];
	notify_post("com.julioverne.googleauthpro/reloadSettings");
}
- (void)setPreferenceValue:(id)value specifier:(PSSpecifier *)specifier
{
	@autoreleasepool {
		[[NSUserDefaults standardUserDefaults] setObject:value forKey:[specifier identifier] inDomain:@"com.julioverne.googleauthpro"];
		[[NSUserDefaults standardUserDefaults] synchronize];
		notify_post("com.julioverne.googleauthpro/reloadSettings");
		[self reloadSpecifiers];
		if ([[specifier properties] objectForKey:@"PromptRespring"]) {
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:self.title message:@"An Respring is Requerid for this option." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Respring", nil];
			alert.tag = 55;
			[alert show];
		}
	}
}
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 55 && buttonIndex == 1) {
        system("killall backboardd SpringBoard");
    }
}
- (id)readPreferenceValue:(PSSpecifier*)specifier
{
	@autoreleasepool {
		return [[NSUserDefaults standardUserDefaults] objectForKey:[specifier identifier] inDomain:@"com.julioverne.googleauthpro"]?:[[specifier properties] objectForKey:@"default"];
	}
}
- (void)_returnKeyPressed:(id)arg1
{
	[super _returnKeyPressed:arg1];
	[self.view endEditing:YES];
}
- (void) loadView
{
	[super loadView];
	self.title = @"GoogleAuthPro";	
	[UISwitch appearanceWhenContainedIn:self.class, nil].onTintColor = [UIColor colorWithRed:0.09 green:0.99 blue:0.99 alpha:1.0];
}			
@end


@interface AuthCodeValueView : UIView
- (UILabel*)passCodeLabel;
@end
%hook AuthCodeValueView
- (void)layoutSubviews
{
	%orig;
	if(Enabled&&codeFontSize!=0) {
		UILabel* passCodeLabel = [self passCodeLabel];
		if(passCodeLabel) {
			passCodeLabel.font = [passCodeLabel.font fontWithSize:codeFontSize];
		}
	} else if(Enabled&&compactStyleEnabled) {
		UILabel* passCodeLabel = [self passCodeLabel];
		if(passCodeLabel) {
			passCodeLabel.font = [passCodeLabel.font fontWithSize:20];
		}
	}
}
%end

@interface AuthCodeView : UIView
@property (assign) int totalHeightSize; 
@end
%hook AuthCodeView
%property(assign) int totalHeightSize;
- (void)layoutSubviews
{
	%orig;
	if(Enabled&&compactStyleEnabled) {
		self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, 50);
		
		UITextField* issuerField = MSHookIvar<UITextField*>(self, "_issuerField");
		if(issuerField) {
			issuerField.frame = CGRectMake(5, 5, self.frame.size.width, 14);
			issuerField.adjustsFontSizeToFitWidth = YES;
		}		
		
		AuthCodeValueView* valueView = MSHookIvar<AuthCodeValueView*>(self, "_valueView");
		valueView.frame = CGRectMake(5, 10*2, self.frame.size.width, 14+ (codeFontSize/3));
		
		UITextField* nameField = MSHookIvar<UITextField*>(self, "_nameField");
		if(nameField) {
			nameField.frame = CGRectMake(5, 10*3 + (codeFontSize/3), self.frame.size.width, 14);
			nameField.adjustsFontSizeToFitWidth = YES;
		}
		
		self.totalHeightSize = 5 + 14 + 14 + (14+ (codeFontSize/3));
	}
}
%end


@interface QTMCollectionViewModel : NSObject
- (id)allIndexPaths;

- (id)collectionView:(id)arg1 cellForItemAtIndexPath:(NSIndexPath *)arg2;
@end

@interface OTPStore : NSObject
@property (nonatomic, retain) NSMutableArray* authURLs;
- (int)count;
@end

@interface ProDataSourceTableView : NSObject <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>
@property (assign,nonatomic) CodeListViewController* controller;
@property (assign,nonatomic) UITableView* aTableView;
@property (assign,nonatomic) NSMutableArray* allIndexs;
@property (assign,nonatomic) NSMutableArray* indexPathMaped;
@property (assign,nonatomic) NSMutableDictionary* mapedOrder;
@property (assign,nonatomic) NSMutableArray* sectionMapedOrder;
@property (assign,nonatomic) NSString* searchString;
@property (assign,nonatomic) UISearchBar* searchBar;
+ (id)shared;
- (void)reload;
@end

@interface CodeListViewController : UIViewController
@property (nonatomic, retain) UITableView* tableView; 
@property (nonatomic, retain) UIView* tableViewView;
@property (nonatomic, retain) ProDataSourceTableView* hereDataSource;

@property (nonatomic, retain) OTPStore* store; 

- (id)collectionView;
- (QTMCollectionViewModel *)modelFromStore;

- (void)RefreshPro;
@end

@interface UIView ()
@property (assign,nonatomic) UIEdgeInsets contentInset;
- (AuthCodeView*)objectContentView;
@end



@implementation ProDataSourceTableView
@synthesize mapedOrder, controller, aTableView, allIndexs, indexPathMaped, sectionMapedOrder, searchString, searchBar;
- (id)init
{
	self = [super init];
	allIndexs = [[NSMutableArray alloc] init];
	indexPathMaped = [[NSMutableArray alloc] init];
	mapedOrder = [[NSMutableDictionary alloc] init];
	return self;
}
+ (id)shared
{
	static ProDataSourceTableView* ProDataSourceTableViewC;
	if(!ProDataSourceTableViewC) {
		ProDataSourceTableViewC = [[[self class] alloc] init];
	}
	return ProDataSourceTableViewC;
}
- (NSMutableArray*)mutArrayForLetter:(NSString*)letter
{
	NSMutableArray* mutArrLetter = mapedOrder[letter];
	if(!mutArrLetter) {
		mutArrLetter = [[NSMutableArray alloc] init];
		mapedOrder[letter] = mutArrLetter;
	}
	return mutArrLetter;
}
- (void)searchBar:(UISearchBar *)aSearchBar textDidChange:(id)arg2
{
	searchString = arg2;
	[searchBar setShowsCancelButton:YES animated:YES];
	[self reload];
}
- (void)searchBarTextDidBeginEditing:(UISearchBar *)aSearchBar
{
	searchString = searchBar.text;
	[searchBar setShowsCancelButton:YES animated:YES];
	[self reload];
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)aSearchBar
{
	searchBar.text = @"";
	searchString = nil;
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
	[self reload];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)aSearchBar
{
    [searchBar resignFirstResponder];
	[searchBar setShowsCancelButton:YES animated:YES];
	[self reload];
}
- (void)reload
{
	mapedOrder = [[NSMutableDictionary alloc] init];
	NSArray* allIdxPaths = [[controller modelFromStore] allIndexPaths];
	
	for(NSIndexPath* indexPath in allIdxPaths) {
		NSString* letter = nil;
		UIView* cellView = [[controller modelFromStore] collectionView:[controller collectionView] cellForItemAtIndexPath:indexPath];
		UILabel* issuerField = MSHookIvar<UILabel*>([cellView objectContentView], "_issuerField");
		NSString* textIssuer = issuerField.text;
		UILabel* nameField = MSHookIvar<UILabel*>([cellView objectContentView], "_nameField");
		NSString* textName = nameField.text;
		if(alphabeticallyEnabled) {
			if(textIssuer&&textIssuer.length>0) {
				letter = [[textIssuer substringToIndex:1] uppercaseString];
			}
			if(!letter) {
				if(textName&&textName.length>0) {
					letter = [[textName substringToIndex:1] uppercaseString];
				}
			}
		}
		if(searchString) {
			NSArray* textKeys = [[searchString lowercaseString] componentsSeparatedByString:@" "];
			if([textKeys count] > 0) {
				int foundCount = 0;
				for(NSString* textSerchNow in textKeys) {
					if(textSerchNow.length == 0) {
						foundCount++;
					}
					if(textName&&textName.length>0&&[[textName lowercaseString] rangeOfString:textSerchNow].location != NSNotFound) {
						foundCount++;
					}
					if(textIssuer&&textIssuer.length>0&&[[textIssuer lowercaseString] rangeOfString:textSerchNow].location != NSNotFound) {
						foundCount++;
					}
				}
				if(foundCount >= [textKeys count]) {
					[[self mutArrayForLetter:letter?:@"#"] addObject:indexPath];
					continue;
				}
			} else {
				if(textName&&textName.length>0&&[[textName lowercaseString] rangeOfString:[searchString lowercaseString]].location != NSNotFound) {
					[[self mutArrayForLetter:letter?:@"#"] addObject:indexPath];
					continue;
				}
				if(textIssuer&&textIssuer.length>0&&[[textIssuer lowercaseString] rangeOfString:[searchString lowercaseString]].location != NSNotFound) {
					[[self mutArrayForLetter:letter?:@"#"] addObject:indexPath];
					continue;
				}
			}
			continue;
		}
		[[self mutArrayForLetter:letter?:@"#"] addObject:indexPath];
	}
	
	NSMutableArray* titlesSec = [[mapedOrder allKeys] mutableCopy];
	[titlesSec sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
	sectionMapedOrder = titlesSec;
	[aTableView reloadData];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell* cell = nil;
	NSString* cellIdentfier = [NSString stringWithFormat:@"cellPro-%@", /*[NSDate date]*/indexPath];
	cell = [tableView dequeueReusableCellWithIdentifier:cellIdentfier];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentfier];
    }
	
	for(UIView* vNow in cell.contentView.subviews) {
		[vNow removeFromSuperview];
	}
	
	
	NSMutableArray* rowOrder = mapedOrder[sectionMapedOrder[indexPath.section]];
	
	UIView* cellView = [[controller modelFromStore] collectionView:[controller collectionView] cellForItemAtIndexPath:rowOrder[indexPath.row]];
	[cellView layoutSubviews];
	
	[[cellView objectContentView] setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
	[cell.contentView setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
	
	[cellView objectContentView].frame = cell.bounds;
	
	[cell.contentView addSubview:[cellView objectContentView]];
	
	return cell;
}
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	return nil;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	if(alphabeticallyEnabled && alphabeticallyShowSection) {
		return sectionMapedOrder[section];
	}
	return nil;
}
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
	return nil;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	NSMutableArray* rowOrder = mapedOrder[sectionMapedOrder[section]];
	return [rowOrder count];
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
	@try {
		
	} @catch (NSException * e) {
	}
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath 
{
	return NO;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [sectionMapedOrder count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSMutableArray* rowOrder = mapedOrder[sectionMapedOrder[indexPath.section]];
	if(compactStyleEnabled) {
		UIView* cellView = [[controller modelFromStore] collectionView:[controller collectionView] cellForItemAtIndexPath:rowOrder[indexPath.row]];
		if(cellView) {
			[cellView layoutSubviews];
			[[cellView objectContentView] layoutSubviews];
			return [[cellView objectContentView] totalHeightSize];
		}
		return 50.0f;
	}
	
	
	UIView* cellView = [[controller modelFromStore] collectionView:[controller collectionView] cellForItemAtIndexPath:rowOrder[indexPath.row]];
	if(cellView) {
		[cellView layoutSubviews];
		return cellView.frame.size.height;
	}
    return 140.0f;
}
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
	if(alphabeticallyEnabled && alphabeticallyShowSection) {
		return sectionMapedOrder;
	}
	return nil;
}
@end

%hook CodeListViewController
%property (nonatomic, retain) id tableViewView;
%property (nonatomic, retain) id tableView;
%property (nonatomic, retain) id hereDataSource;
%new
- (void)RefreshPro
{
	[self.hereDataSource reload];
	self.tableViewView.hidden = !Enabled;
}
- (void)collectionViewWillBeginEditing:(id)arg1
{
	if(self.tableViewView) {
		self.tableViewView.hidden = YES;
	}
	%orig;
}
- (void)collectionViewWillEndEditing:(id)arg1
{
	%orig;
	if(self.tableViewView) {
		self.tableViewView.hidden = NO;
		[self RefreshPro];
	}
}
- (void)reloadModel
{
	%orig;
	[self RefreshPro];
}
- (void)viewWillAppear:(BOOL)arg1
{
	%orig;
	[self RefreshPro];
}
- (void)viewDidLoad
{
	%orig;
	
	self.tableViewView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    [self.tableViewView setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
	
    self.tableView = [[UITableView alloc] initWithFrame:[self.tableViewView bounds] style:UITableViewStylePlain];
    [self.tableView setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
	
	self.hereDataSource = [ProDataSourceTableView shared];
	self.hereDataSource.controller = self;
	self.hereDataSource.aTableView = self.tableView;
	
    [self.tableView setDataSource:self.hereDataSource];
    [self.tableView setDelegate:self.hereDataSource];
	
    [self.tableViewView addSubview:self.tableView];
	
	self.hereDataSource.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.tableViewView.bounds.size.width, 44)];
	self.hereDataSource.searchBar.delegate = self.hereDataSource;
	if(searchEnabled) {
		[self.tableView setTableHeaderView:self.hereDataSource.searchBar];
	}
	[self.view addSubview:self.tableViewView];
	
	UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
	[refreshControl addTarget:self action:@selector(refreshViewPro:) forControlEvents:UIControlEventValueChanged];
	[self.tableView addSubview:refreshControl];
	
	[self RefreshPro];
}
%new
- (void)refreshViewPro:(UIRefreshControl *)refresh
{
	[self RefreshPro];
	[refresh endRefreshing];
}

- (void)viewDidLayoutSubviews
{
	%orig;
	for(UIView* vNow in self.view.subviews) {
		if([vNow isKindOfClass:%c(QTMCollectionView)]) {
			if(self.tableView) {
				[self.tableView setContentInset:UIEdgeInsetsMake(vNow.contentInset.top, 0, 0, 0)];
			}
			break;
		}
	}
}
%end


@interface OTPSidePanelViewController : UIViewController
- (void)pushToMainNavigationWithViewController:(id)arg1;
@end

@interface GOOPlainSideViewContentView : UIView
- (UIView*)collectionView;
@end


%hook OTPSidePanelViewController
- (void)viewDidLoad
{
	%orig;
	
	UIView* viewColl = [(GOOPlainSideViewContentView*)self.view collectionView];
	
	UIView* contentBT = [UIView new];
	contentBT.frame = CGRectMake(20,280,200,23);
	contentBT.tag = 6656;
	UIButton* ButtonInstall = [UIButton buttonWithType:UIButtonTypeSystem];
	[ButtonInstall setTitle:@"GoogleAuthPro" forState:UIControlStateNormal];
	[ButtonInstall addTarget:self action:@selector(handleGoogleAuthPro) forControlEvents:UIControlEventTouchUpInside];
	
	[ButtonInstall setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	[ButtonInstall setBackgroundColor:[UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1.0]];
	[ButtonInstall setFrame:CGRectMake(0,0,200,23)];
	ButtonInstall.layer.cornerRadius = 10;
	[ButtonInstall sizeToFit];
	
	
	
	[contentBT addSubview:ButtonInstall];
	[contentBT sizeToFit];
	[contentBT setTranslatesAutoresizingMaskIntoConstraints:NO];
	[viewColl addSubview:contentBT];
	
}
%new
- (void)handleGoogleAuthPro
{
	[self pushToMainNavigationWithViewController:[[GoogleAuthProController alloc] init]];
}
%end


static void prefsChanged(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo)
{
	@autoreleasepool {
		Enabled = [[[NSUserDefaults standardUserDefaults] objectForKey:@"Enabled" inDomain:@"com.julioverne.googleauthpro"]?:@YES boolValue];
		alphabeticallyEnabled = [[[NSUserDefaults standardUserDefaults] objectForKey:@"alphabeticallyEnabled" inDomain:@"com.julioverne.googleauthpro"]?:@YES boolValue];
		alphabeticallyShowSection = [[[NSUserDefaults standardUserDefaults] objectForKey:@"alphabeticallyShowSection" inDomain:@"com.julioverne.googleauthpro"]?:@YES boolValue];
		searchEnabled = [[[NSUserDefaults standardUserDefaults] objectForKey:@"searchEnabled" inDomain:@"com.julioverne.googleauthpro"]?:@YES boolValue];
		compactStyleEnabled = [[[NSUserDefaults standardUserDefaults] objectForKey:@"compactStyleEnabled" inDomain:@"com.julioverne.googleauthpro"]?:@NO boolValue];
		safariURLEnabled = [[[NSUserDefaults standardUserDefaults] objectForKey:@"safariURLEnabled" inDomain:@"com.julioverne.googleauthpro"]?:@YES boolValue];
		codeFontSize = [[[NSUserDefaults standardUserDefaults] objectForKey:@"codeFontSize" inDomain:@"com.julioverne.googleauthpro"]?:@(0) intValue];
	}
}


%ctor
{
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, &prefsChanged, (CFStringRef)@"com.julioverne.googleauthpro/reloadSettings", NULL, 0);
	prefsChanged(NULL, NULL, NULL, NULL, NULL);
    %init;
	[[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidBecomeActiveNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
		NSString *expected = @"com.julioverne.googleauthpro.search";
		NSData *takeCMD = [[UIPasteboard generalPasteboard] dataForPasteboardType:expected];
		if(Enabled&&takeCMD && takeCMD.length>0) {
			[[UIPasteboard generalPasteboard] setData:[NSData data] forPasteboardType:expected];
			ProDataSourceTableView* shrd = [ProDataSourceTableView shared];
			if(shrd.searchBar) {
				[shrd.searchBar becomeFirstResponder];
				if(safariURLEnabled && takeCMD.length>1) {
					shrd.searchBar.text = [[NSString alloc] initWithData:takeCMD encoding:NSUTF8StringEncoding];
					[shrd searchBarTextDidBeginEditing:shrd.searchBar];
				}
			}
		}
	}];	
}
