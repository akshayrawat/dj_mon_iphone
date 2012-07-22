class ProjectsController < UITableViewController

  def viewDidLoad
    super
    view.dataSource = self
    navigationItem.title = "Projects"
  end

  def numberOfSectionsInTableView(tableView)
    1
  end

  CELL_ID = "projects"
  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    cell = tableView.dequeueReusableCellWithIdentifier(CELL_ID) || begin
      cell = UITableViewCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier:CELL_ID)
      cell.selectionStyle = UITableViewCellSelectionStyleBlue
      cell
    end
    cell.textLabel.text = "My Project"
    cell
  end

  def tableView(tableView, numberOfRowsInSection:section)
    4
  end

end
