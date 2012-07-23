class ProjectsController < UITableViewController

  def viewDidLoad
    super
    view.dataSource = view.delegate = self
    navigationItem.title = "Projects"
    navigationItem.leftBarButtonItem = editButtonItem
    navigationItem.rightBarButtonItem = UIBarButtonItem.alloc.initWithBarButtonSystemItem(UIBarButtonSystemItemAdd, target:self, action: 'addProject')
  end

  def viewWillAppear(animated)
    super
    @projects ||= 5.times.collect {|i| "Project #{i}"}
  end

  CELL_ID = "ProjectsTableCell"
  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    cell = tableView.dequeueReusableCellWithIdentifier(CELL_ID) || begin
    cell = UITableViewCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier:CELL_ID)
    cell.selectionStyle = UITableViewCellSelectionStyleBlue
    cell
    end
    cell.textLabel.text = @projects[indexPath.row]
    cell
  end

  def tableView(tableView, numberOfRowsInSection:section)
    @projects.size
  end

  def tableView(tableView, didSelectRowAtIndexPath:indexPath)
    @projectController ||= ProjectController.alloc.init
    @projectController.selectedProject(@projects[indexPath.row])
    self.navigationController.pushViewController(@projectController, animated: true)
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
  end

  def tableView(tableView, editingStyleForRowAtIndexPath:indexPath)
    UITableViewCellEditingStyleDelete
  end

  def tableView(tableView, commitEditingStyle:editingStyle, forRowAtIndexPath:indexPath)
    @projects.delete_at indexPath.row
    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation:UITableViewRowAnimationFade)
  end

  def addProject
    @projects << "Project #{Time.now}"
    view.reloadData
  end

end
