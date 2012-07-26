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

    @request = APIRequest.new("#{@project.djMonURL}/dj_reports/dj_counts", @project.username, @project.password)
    @request.execute

    @request.onSuccess do |data|
      @project.delayedJobCounts = data
      tableView.reloadData
    end

    @request.onFailure do
      alertView = UIAlertView.alloc.initWithTitle("API Request failed", message:"API Request failed", delegate:nil, cancelButtonTitle:"Ok", otherButtonTitles:nil)
      alertView.show
    end
  end

  CELL_ID = "ProjectTableCell"
  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    cell = tableView.dequeueReusableCellWithIdentifier(CELL_ID) || begin
      UITableViewCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier:CELL_ID).tap do |cell|
        cell.selectionStyle = UITableViewCellSelectionStyleBlue
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator
      end
    end
    cell.textLabel.text = "#{@project.delayedJobCounts.keys[indexPath.row].capitalize} #{@project.delayedJobCounts.values[indexPath.row]}"
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
