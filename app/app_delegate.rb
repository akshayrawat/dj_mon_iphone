class AppDelegate

  def application(application, didFinishLaunchingWithOptions:launchOptions)
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    @window.rootViewController = UINavigationController.alloc.initWithRootViewController(ProjectsController.alloc.init)
    @window.rootViewController.navigationBar.tintColor = UIColor.colorWithRed(0.227, green:0.302, blue:0.502, alpha:1)
    @window.rootViewController.wantsFullScreenLayout = true
    @window.makeKeyAndVisible
    true
  end

end
