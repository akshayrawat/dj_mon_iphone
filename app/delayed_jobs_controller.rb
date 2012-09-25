class DelayedJobsController < UITableViewController

  def selectedStatus(status, forProject:project)
    @project, @status = project, status
  end

  def viewDidLoad
    super
    if defined? UIRefreshControl
      self.refreshControl = UIRefreshControl.new
      refreshControl.addTarget(self, action:'refresh:', forControlEvents:UIControlEventValueChanged)
    end
    view.dataSource = view.delegate = self
  end

  def viewWillAppear(animated)
    super
    tableView.reloadData

    navigationItem.title = "#{@status.capitalize} Jobs"

    loadData
  end

  def refresh(sender)
    refreshControl.beginRefreshing if defined? UIRefreshControl
    loadData
  end

  def loadData
    @request = APIRequest.new("#{@project.djMonURL}/dj_reports/#{@status}", @project.username, @project.password)
    @request.execute

    @request.onSuccess do |data|
      @project.delayedJobs[@status] = data.group_by { |d| d[:queue] }
      refreshControl.endRefreshing if defined? UIRefreshControl
      tableView.reloadData
    end

    @request.onFailure do
      alertView = UIAlertView.alloc.initWithTitle("API Request failed", message:"API Request failed", delegate:nil, cancelButtonTitle:"Ok", otherButtonTitles:nil)
      refreshControl.endRefreshing if defined? UIRefreshControl
      alertView.show
    end
  end

  CELL_ID = "DelayedJobsTableCell"
  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    cell = tableView.dequeueReusableCellWithIdentifier(CELL_ID) || begin
      cell = UITableViewCell.alloc.initWithStyle(UITableViewCellStyleSubtitle, reuseIdentifier:CELL_ID)
      cell.selectionStyle = UITableViewCellSelectionStyleGray
      cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator
      cell
    end

    queue = @project.delayedJobs[@status].keys[indexPath.section]
    job = @project.delayedJobs[@status][queue][indexPath.row]
    cell.textLabel.text = "#{job[:created_at]} "
    cell.detailTextLabel.text = "ID:#{job[:id]} Priority:#{job[:priority]} Attempts:#{job[:attempts]}"
    cell
  end

  def tableView(tableView, numberOfRowsInSection:section)
    queue = @project.delayedJobs[@status].keys[section]
    @project.delayedJobs[@status][queue].size
  end

  def numberOfSectionsInTableView(tableView)
    @project.delayedJobs[@status].size
  end

  def tableView(tableView, titleForHeaderInSection:section)
    @project.delayedJobs[@status].keys[section]
  end

  def tableView(tableView, didSelectRowAtIndexPath:indexPath)
    @delayedJobController ||= DelayedJobController.alloc.initWithStyle(UITableViewStyleGrouped)

    queue = @project.delayedJobs[@status].keys[indexPath.section]
    job = @project.delayedJobs[@status][queue][indexPath.row]

    @delayedJobController.selectedDelayedJob(job)
    self.navigationController.pushViewController(@delayedJobController, animated: true)
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
  end

end
