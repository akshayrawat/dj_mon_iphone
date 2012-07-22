class DelayedJobsController < UITableViewController

  def selectedProject project
  end

  def viewDidLoad
    super
    view.dataSource = view.delegate = self
    navigationItem.title = "Failed"
    @delayedJobs = [
      { 
        id: 1,
        payload: "some payload",
        priority: 1,
        attempts: 2,
        queue: "global",
        last_error_summary: "some last error summary",
        last_error: "some last error",
        failed_at: Time.now,
        run_at: Time.now,
        created_at: Time.now,
        failed: true
      },

      {
        id: 2,
        payload: "another payload",
        priority: 1,
        attempts: 2,
        queue: "global",
        last_error_summary: "another last error summary",
        last_error: "another last error",
        failed_at: Time.now,
        run_at: Time.now,
        created_at: Time.now,
        failed: true
      },

    ]
  end

  CELL_ID = "DelayedJobsTableCell"
  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    cell = tableView.dequeueReusableCellWithIdentifier(CELL_ID) || begin
      cell = UITableViewCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier:CELL_ID)
      cell.selectionStyle = UITableViewCellSelectionStyleBlue
      cell
    end
    job = @delayedJobs[indexPath.row]
    cell.textLabel.text = "ID:#{job[:id]}, Queue:#{job[:queue]}"
    cell
  end

  def tableView(tableView, numberOfRowsInSection:section)
    @delayedJobs.size
  end

  def tableView(tableView, didSelectRowAtIndexPath:indexPath)
    @projectController ||= ProjectController.alloc.init
    @projectController.selectedProject(@projects[indexPath.row])
    self.navigationController.pushViewController(@projectController, animated: true)
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
  end

end
