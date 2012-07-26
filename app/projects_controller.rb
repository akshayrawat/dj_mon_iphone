class ProjectsController < UITableViewController

  def viewDidLoad
    super
    view.dataSource = view.delegate = self
    navigationItem.title = "Projects"
    navigationItem.leftBarButtonItem = editButtonItem
    navigationItem.rightBarButtonItem = UIBarButtonItem.alloc.initWithBarButtonSystemItem(UIBarButtonSystemItemAdd, target:self, action: 'newProject')
  end

  def viewWillAppear(animated)
    super
    tableView.reloadData
  end

  CELL_ID = "ProjectsTableCell"
  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    cell = tableView.dequeueReusableCellWithIdentifier(CELL_ID) || begin
      UITableViewCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier:CELL_ID).tap do |cell|
        cell.selectionStyle = UITableViewCellSelectionStyleBlue
        cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton
      end
    end
    cell.textLabel.text = projects[indexPath.row].name
    cell
  end

  def tableView(tableView, numberOfRowsInSection:section)
    projects.size
  end

  def tableView(tableView, didSelectRowAtIndexPath:indexPath)
    @projectController ||= ProjectController.alloc.init
    @projectController.selectedProject(projects[indexPath.row])
    self.navigationController.pushViewController(@projectController, animated: true)
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
  end

  def tableView(tableView, editingStyleForRowAtIndexPath:indexPath)
    UITableViewCellEditingStyleDelete
  end

  def tableView(tableView, commitEditingStyle:editingStyle, forRowAtIndexPath:indexPath)
    project = projects[indexPath.row]
    ProjectsStore.shared.deleteProject(project)
    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation:UITableViewRowAnimationFade)
  end

  def newProject
    @newProjectController ||= NewProjectController.alloc.init
    self.navigationController.pushViewController(@newProjectController, animated: true)
  end

  def projects
    ProjectsStore.shared.projects
  end

end
