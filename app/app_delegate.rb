class AppDelegate

  def application(application, didFinishLaunchingWithOptions:launchOptions)
    @project_controller = ProjectsController.alloc.init
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    @window.rootViewController = UINavigationController.alloc.initWithRootViewController(@project_controller)
    @window.rootViewController.navigationBar.tintColor = UIColor.blackColor
    @window.rootViewController.wantsFullScreenLayout = true
    @window.makeKeyAndVisible
    true
  end

end
