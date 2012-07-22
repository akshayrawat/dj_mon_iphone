class ProjectsController < UITableViewController

  def viewDidLoad
    super
    view.dataSource = view.delegate = self
    navigationItem.title = "Projects"
    @projects = 5.times.collect {|i| "Project #{i}"}
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
    @delayedJobsController ||= DelayedJobsController.alloc.init
    @delayedJobsController.selectedProject(@projects[indexPath.row])
    self.navigationController.pushViewController(@delayedJobsController, animated: true)
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
  end

end
