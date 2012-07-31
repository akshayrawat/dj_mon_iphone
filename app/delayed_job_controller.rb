class DelayedJobController < UITableViewController

  def selectedDelayedJob(delayedJob)
    @delayedJob = {
      queue:      delayedJob['queue'],
      id:         delayedJob['id'],
      payload:    '',
      priority:   delayedJob['priority'],
      created_at: delayedJob['created_at'],
      run_at:     delayedJob['run_at'],
      failed_at:  delayedJob['failed_at'],
      last_error: '',
      attempts:   delayedJob['attempts']
    }
  end

  def viewDidLoad
    super
    view.dataSource = view.delegate = self
    @cellsWithMoreInfo ||= { payload: :payload, last_error: :last_error_summary }
  end

  def viewWillAppear(animated)
    super
    navigationItem.title = "##{@delayedJob[:id]}"
  end

  CELL_ID = "DelayedJobTableCell"
  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    row = @delayedJob.keys[indexPath.row]

    cell = tableView.dequeueReusableCellWithIdentifier(CELL_ID) || begin
      cell = UITableViewCell.alloc.initWithStyle(UITableViewCellStyleValue1, reuseIdentifier:CELL_ID)
      cell.selectionStyle = UITableViewCellSelectionStyleNone
      cell
    end
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator if @cellsWithMoreInfo.include?(row)
    cell.textLabel.text = row.to_s.gsub('_', ' ').capitalize
    cell.detailTextLabel.text = @delayedJob.values[indexPath.row].to_s
    cell
  end

  def tableView(tableView, numberOfRowsInSection:section)
    @delayedJob.size
  end

end
