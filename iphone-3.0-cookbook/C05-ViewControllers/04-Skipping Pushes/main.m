/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 3.0 Edition
 BSD License, Use at your own risk
 */

#import <UIKit/UIKit.h>

#define COOKBOOK_PURPLE_COLOR	[UIColor colorWithRed:0.20392f green:0.19607f blue:0.61176f alpha:1.0f]
#define BARBUTTON(TITLE, SELECTOR) 	[[[UIBarButtonItem alloc] initWithTitle:TITLE style:UIBarButtonItemStylePlain target:self action:SELECTOR] autorelease]

@interface TestBedViewController : UIViewController
{
	int depth;
}
@end

@implementation TestBedViewController
- (id) initWithDepth: (int) theDepth
{
	self = [super init];
	if (self) depth = theDepth;
	return self;
}

- (void) doPush: (id) nc
{
	// With the stack back at view 1, push on view #depth+1
	[nc pushViewController:[[TestBedViewController alloc] initWithDepth:depth+1] animated:YES];	
}

- (void) push
{
	if (depth < 2) 
	{
		[self.navigationController pushViewController:[[TestBedViewController alloc] initWithDepth:depth+1] animated:YES];
		return;
	}
	
	// Push from current view to view #depth+1, showing the animation
	[self.navigationController pushViewController:[[TestBedViewController alloc] initWithDepth:depth+1] animated:YES];
	
	// Get ready to push from view #1 to view #depth+1
    [self performSelector:@selector(doPush:) withObject:self.navigationController afterDelay:0.05f];

	// Pop off view #depth+1 and then view #depth
	[[self.navigationController topViewController] autorelease];
	[self.navigationController popViewControllerAnimated:NO];
	[[self.navigationController topViewController] autorelease];
	[self.navigationController popViewControllerAnimated:NO];
	
}

- (void) loadView
{
	self.view = [[[NSBundle mainBundle] loadNibNamed:@"mainview" owner:self options:nil] lastObject];
	self.navigationController.navigationBar.tintColor = COOKBOOK_PURPLE_COLOR;
	NSString *valueString = [NSString stringWithFormat:@"%d", depth];
	NSString *nextString = [NSString stringWithFormat:@"Push %d", depth + 1];
	
	// set the title
	if (depth > 1)
		self.title = [@"Level " stringByAppendingString:valueString];
	else
		self.title = @"Root Level";
	
	// Set the main label
	((UILabel *)[self.view viewWithTag:101]).text = valueString;
	
	// Add the "next" bar button item
	if (depth < 3) self.navigationItem.rightBarButtonItem = BARBUTTON(nextString, @selector(push));
}
@end

@interface TestBedAppDelegate : NSObject <UIApplicationDelegate>
@end

@implementation TestBedAppDelegate
- (void)applicationDidFinishLaunching:(UIApplication *)application {	
	UIWindow *window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:[[TestBedViewController alloc] initWithDepth:1]];
	[window addSubview:nav.view];
	[window makeKeyAndVisible];
}
@end

int main(int argc, char *argv[])
{
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	int retVal = UIApplicationMain(argc, argv, nil, @"TestBedAppDelegate");
	[pool release];
	return retVal;
}
