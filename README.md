# PMSideMenuView

##  

![Screen1](https://github.com/peromasamune/PMSideMenuView/blob/master/screens/screen1.png?raw=true)

Objective-C based popular side menu view.  

- Support pan gesture open/close menu
- Random generate background gradient
- Customizable sidemenu cells

# How to use

##

- Import hader file.

```objective-c
#import "PMSideMenuViewController.h"
```

 - Create object and set to window
 
 ```objective-c
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    PMSideMenuViewController *sideMenuViewController = [PMSideMenuViewController sharedController];
    sideMenuViewController.delegate = self;
    sideMenuViewController.currentSideMenuIndex = 1;
    self.window.rootViewController = sideMenuViewController;
}
```

- Implement delegate methods

```objective-c
-(NSInteger)PMSideMenuNumberOfSideMenuListItems;
-(PMSideMenuListItem *)PMSideMenuListItemAtIndex:(NSInteger)index;
-(UIViewController *)PMSideMenuViewController:(PMSideMenuViewController *)viewController transitonViewControllerWhenSelectedItemAtIndex:(NSInteger)index;
```

__Examples__

```objective-c
-(NSInteger)PMSideMenuNumberOfSideMenuListItems{
    return 4;
}

-(PMSideMenuListItem *)PMSideMenuListItemAtIndex:(NSInteger)index{
    if (index == 0) {
        PMSideMenuListItem *item = [PMSideMenuListItem itemWithTitle:@"PMSideMenuView" image:@"icon"];
        item.type = PMSideMenuListItemTypeCircleImage;
        item.cellHeight = 200;
        return item;
    }

    if (index == 1) {
        return [[PMSideMenuListItem alloc] initWithTitle:@"Menu 1" image:@"menu"];
    }
    if (index == 2) {
        return [[PMSideMenuListItem alloc] initWithTitle:@"Menu 2" image:@"menu"];
    }
    if (index == 3) {
        return [[PMSideMenuListItem alloc] initWithTitle:@"Menu 3" image:@"menu"];
    }

    return nil;
}

-(UIViewController *)PMSideMenuViewController:(PMSideMenuViewController *)viewController transitonViewControllerWhenSelectedItemAtIndex:(NSInteger)index{

    if (index == 0) {
        return nil;
    }

    ViewController *itemViewController = [ViewController new];
    itemViewController.title = [NSString stringWithFormat:@"Menu %ld",(long)index];

    return itemViewController;
}
```

##License
Copyright &copy; 2015 Peromasamune  
Distributed under the [MIT License][mit].
[MIT]: http://www.opensource.org/licenses/mit-license.php 