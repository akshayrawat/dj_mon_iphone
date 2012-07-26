class ProjectController < UITableViewController

  def selectedProject project
    @project = project
  end

  def viewDidLoad
    super
    view.dataSource = view.delegate = self
    navigationItem.title = "Delayed Jobs"
  end

  def viewWillAppear(animated)
    super
    APIDelayedJobCountRequest.new(@project).execute do
      tableView.reloadData
    end
  end

  CELL_ID = "ProjectTableCell"
  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    cell = tableView.dequeueReusableCellWithIdentifier(CELL_ID) || begin
    cell = UITableViewCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier:CELL_ID)
    cell.selectionStyle = UITableViewCellSelectionStyleBlue
    cell
    end
    cell.textLabel.text = "#{@project.delayedJobCounts.keys[indexPath.row]} #{@project.delayedJobCounts.values[indexPath.row]}"
    cell
  end

  def tableView(tableView, numberOfRowsInSection:section)
    @project.delayedJobCounts.size
  end

  def tableView(tableView, didSelectRowAtIndexPath:indexPath)
    @delayedJobsController ||= DelayedJobsController.alloc.init
    @delayedJobsController.selectedProject(@project)
    self.navigationController.pushViewController(@delayedJobsController, animated: true)
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
  end

end
