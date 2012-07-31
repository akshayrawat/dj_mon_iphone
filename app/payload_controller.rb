class PayloadController < UITableViewController

  def selectedDelayedJob(delayedJob)
    @delayedJob = delayedJob
  end

  def viewDidLoad
    super
    view.dataSource = view.delegate = self
  end

  def viewWillAppear(animated)
    super
    navigationItem.title = "##{@delayedJob['id']}"
    tableView.reloadData
  end

  CELL_ID = "PayloadTableCell"
  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    cell = tableView.dequeueReusableCellWithIdentifier(CELL_ID) || begin
      cell = UITableViewCell.alloc.initWithStyle(UITableViewCellStyleSubtitle, reuseIdentifier:CELL_ID)
      cell.selectionStyle = UITableViewCellSelectionStyleNone
      cell
    end

    textView = UITextView.alloc.initWithFrame([[5, 5], [280, 145]])
    textView.editable = false
    textView.text = indexPath.section == 0 ? @delayedJob['payload'] : @delayedJob['last_error']
    cell.contentView.addSubview(textView)
    cell
  end

  def tableView(tableView, heightForRowAtIndexPath:indexPath)
    155
  end

  def tableView(tableView, numberOfRowsInSection:section)
    1
  end

  def numberOfSectionsInTableView(tableView)
    2
  end

  def tableView(tableView, titleForHeaderInSection:section)
    section == 0 ? "Payload" : "Last error"
  end

end
