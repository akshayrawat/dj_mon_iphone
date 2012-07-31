class DelayedJobController < UITableViewController

  def selectedDelayedJob(delayedJob)
    @delayedJob = %w(queue id payload priority created_at run_at failed_at last_error attempts).inject({}) do |job, attribute|
      job[attribute] = delayedJob[attribute]
      job
    end
  end

  def viewDidLoad
    super
    view.dataSource = view.delegate = self
    @cellsWithMoreInfo ||= %w(payload last_error)
  end

  def viewWillAppear(animated)
    super
    navigationItem.title = "##{@delayedJob['id']}"
    tableView.reloadData
  end

  CELL_ID = "DelayedJobTableCell"
  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    row = @delayedJob.keys[indexPath.row]

    cell = tableView.dequeueReusableCellWithIdentifier(CELL_ID) || begin
      cell = UITableViewCell.alloc.initWithStyle(UITableViewCellStyleValue1, reuseIdentifier:CELL_ID)
      cell
    end

    cell.textLabel.text = row.to_s.gsub('_', ' ').capitalize

    if @cellsWithMoreInfo.include?(row)
      cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator
      cell.selectionStyle = UITableViewCellSelectionStyleGray
    else
      cell.selectionStyle = UITableViewCellSelectionStyleNone
      cell.detailTextLabel.text = @delayedJob.values[indexPath.row].to_s
    end
    cell
  end

  def tableView(tableView, numberOfRowsInSection:section)
    @delayedJob.size
  end

  def tableView(tableView, didSelectRowAtIndexPath:indexPath)
    row = @delayedJob.keys[indexPath.row]
    if @cellsWithMoreInfo.include?(row)
      @payloadController ||= PayloadController.alloc.initWithStyle(UITableViewStyleGrouped)

      @payloadController.selectedDelayedJob(@delayedJob)
      self.navigationController.pushViewController(@payloadController, animated: true)
      tableView.deselectRowAtIndexPath(indexPath, animated: true)
    end
  end

end
