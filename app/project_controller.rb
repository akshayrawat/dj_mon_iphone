class ProjectController < UITableViewController

  def selectedProject project
    @project = project
  end

  def viewDidLoad
    super

    view.dataSource = view.delegate = self
    navigationItem.title = "Delayed Jobs"

    @projectSettings = UIBarButtonItem.alloc.initWithTitle("Settings", style:UIBarButtonItemStylePlain, target:self, action:'showSettings')
    navigationItem.rightBarButtonItem = @projectSettings
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
      UITableViewCell.alloc.initWithStyle(UITableViewCellStyleValue1, reuseIdentifier:CELL_ID).tap do |cell|
        cell.selectionStyle = UITableViewCellSelectionStyleBlue
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator
      end
    end
    cell.textLabel.text = @project.delayedJobCounts.keys[indexPath.row].to_s.capitalize
    cell.detailTextLabel.text = @project.delayedJobCounts.values[indexPath.row].to_s.capitalize
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

  def showSettings
    @projectSettingsController ||= ProjectSettingsController.alloc.initWithStyle(UITableViewStyleGrouped)
    @projectSettingsController.selectedProject(@project)
    self.navigationController.pushViewController(@projectSettingsController, animated: true)
  end

  def tableView(tableView, titleForHeaderInSection:section)
    "Delayed Jobs"
  end

end
