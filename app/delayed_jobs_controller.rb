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
      @project.delayedJobs = data
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
      cell = UITableViewCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier:CELL_ID)
      cell.selectionStyle = UITableViewCellSelectionStyleBlue
      cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator
      cell
    end
    job = @project.delayedJobs[indexPath.row]
    cell.textLabel.text = "ID:#{job[:id]}, Queue:#{job[:queue]}"
    cell
  end

  def tableView(tableView, numberOfRowsInSection:section)
    @project.delayedJobs.size
  end

end
