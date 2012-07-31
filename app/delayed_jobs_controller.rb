class DelayedJobsController < UITableViewController

  def selectedStatus(status, forProject:project)
    @project, @status = project, status
  end

  def viewDidLoad
    super
    view.dataSource = view.delegate = self
  end

  def viewWillAppear(animated)
    super
    navigationItem.title = "#{@status.capitalize} Jobs"

    @request = APIRequest.new("#{@project.djMonURL}/dj_reports/#{@status}", @project.username, @project.password)
    @request.execute

    @request.onSuccess do |data|
      @project.delayedJobs = data.group_by {|d|d[:queue]}
      tableView.reloadData
    end

    @request.onFailure do
      alertView = UIAlertView.alloc.initWithTitle("API Request failed", message:"API Request failed", delegate:nil, cancelButtonTitle:"Ok", otherButtonTitles:nil)
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
    queue = @project.delayedJobs.keys[indexPath.section]
    job = @project.delayedJobs[queue][indexPath.row]
    cell.textLabel.text = "#{job[:created_at]} "
    cell.detailTextLabel.text = "ID:#{job[:id]} Priority:#{job[:priority]} Attempts:#{job[:attempts]}"
    cell
  end

  def tableView(tableView, numberOfRowsInSection:section)
    queue = @project.delayedJobs.keys[section]
    @project.delayedJobs[queue].size
  end

  def numberOfSectionsInTableView(tableView)
    @project.delayedJobs.size
  end

  def tableView(tableView, titleForHeaderInSection:section)
    @project.delayedJobs.keys[section]
  end

  def tableView(tableView, didSelectRowAtIndexPath:indexPath)
    @delayedJobController ||= DelayedJobController.alloc.initWithStyle(UITableViewStyleGrouped)

    queue = @project.delayedJobs.keys[indexPath.section]
    job = @project.delayedJobs[queue][indexPath.row]

    @delayedJobController.selectedDelayedJob(job)
    self.navigationController.pushViewController(@delayedJobController, animated: true)
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
  end

end
