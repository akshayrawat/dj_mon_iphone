class DelayedJobsController < UITableViewController

  def selectedProject project
  end

  def viewDidLoad
    super
    view.dataSource = view.delegate = self
    navigationItem.title = "Delayed Jobs"
    @delayedJobs = {
      failed: 2,
      active: 3,
      queued: 4
    }
  end

  CELL_ID = "DelayedJobsTableCell"
  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    cell = tableView.dequeueReusableCellWithIdentifier(CELL_ID) || begin
    cell = UITableViewCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier:CELL_ID)
    cell.selectionStyle = UITableViewCellSelectionStyleBlue
    cell
    end
    cell.textLabel.text = "#{@delayedJobs.keys[indexPath.row]} #{@delayedJobs.values[indexPath.row]}"
    cell
  end

  def tableView(tableView, numberOfRowsInSection:section)
    @delayedJobs.size
  end

end
