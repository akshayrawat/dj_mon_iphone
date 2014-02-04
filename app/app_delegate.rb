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

  def application(application, handleOpenURL:url)
    if url && url.query
      params = url.query.split("&").map{|param| param.split("=") }.each_with_object({}){|(key, value), stack| stack[key] = value }
      if project = ProjectsStore.shared.projects.select{|project| project.djMonURL == params["url"]}.first
        @project_controller.openProject(project)
      else
        @project_controller.newProject(params)
      end
    end
  end

end
