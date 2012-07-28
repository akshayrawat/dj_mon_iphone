class ProjectSettingsController < UITableViewController

  def selectedProject project
    @project = project
  end

  def viewDidLoad
    super

    view.dataSource = view.delegate = self
    navigationItem.title = "Delayed Job Settings"
  end

  def viewWillAppear(animated)
    super

    @request = APIRequest.new("#{@project.djMonURL}/dj_reports/settings", @project.username, @project.password)
    @request.execute

    @request.onSuccess do |data|
      @project.settings = data
      tableView.reloadData
    end

    @request.onFailure do
      alertView = UIAlertView.alloc.initWithTitle("API Request failed", message:"API Request failed", delegate:nil, cancelButtonTitle:"Ok", otherButtonTitles:nil)
      alertView.show
    end
  end

  CELL_ID = "ProjectSettingsTableCell"
  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    cell = tableView.dequeueReusableCellWithIdentifier(CELL_ID) || begin
      UITableViewCell.alloc.initWithStyle(UITableViewCellStyleValue1, reuseIdentifier:CELL_ID)
    end

    cell.textLabel.text = @project.settings.keys[indexPath.row].gsub('_',' ').capitalize
    cell.detailTextLabel.text = @project.settings.values[indexPath.row].to_s
    cell
  end

  def tableView(tableView, numberOfRowsInSection:section)
    @project.settings.size
  end

  def tableView(tableView, titleForHeaderInSection:section)
    @project.name
  end

end
