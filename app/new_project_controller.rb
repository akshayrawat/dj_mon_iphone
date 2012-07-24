class NewProjectController < UIViewController

  def viewDidLoad
    super
    view.backgroundColor = UIColor.whiteColor
    navigationItem.title = "New Project"
    @tableView = UITableView.alloc.initWithFrame(view.bounds, style:UITableViewStyleGrouped)
    @tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight

    @tableView.delegate = @tableView.dataSource = self

    @name     = buildTextFieldWithPlaceholder("Project name", keyboardType:UIKeyboardTypeAlphabet, returnKeyType:UIReturnKeyNext, isSecure:false)
    @djMonURL = buildTextFieldWithPlaceholder("URL eg: http://yourapp.com/dj_mon", keyboardType:UIKeyboardTypeURL, returnKeyType:UIReturnKeyNext, isSecure:false)
    @username = buildTextFieldWithPlaceholder("Username", keyboardType:UIKeyboardTypeAlphabet, returnKeyType:UIReturnKeyNext, isSecure:false)
    @password = buildTextFieldWithPlaceholder("Password", keyboardType:UIKeyboardTypeAlphabet, returnKeyType:UIReturnKeyDone, isSecure:true)

    self.view.addSubview @tableView
  end

  def tableView(tableView, numberOfRowsInSection:section)
    4
  end

  CELL_ID = "NewProjectTableCell"
  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    tableView.dequeueReusableCellWithIdentifier(CELL_ID) || begin
    UITableViewCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier:CELL_ID).tap do |cell|
      cell.accessoryType = UITableViewCellAccessoryNone
      cell.selectionStyle = UITableViewCellSelectionStyleNone

      cell.addSubview @name     if indexPath.row == 0
      cell.addSubview @djMonURL if indexPath.row == 1
      cell.addSubview @username if indexPath.row == 2
      cell.addSubview @password if indexPath.row == 3
    end
    end
  end

  def textFieldShouldReturn(textField)
    changeFirstResponderTo(@djMonURL, from:@name) if textField == @name
    changeFirstResponderTo(@username, from:@djMonURL) if textField == @djMonURL
    changeFirstResponderTo(@password, from:@username) if textField == @username
    if textField == @password
      ProjectsStore.shared.newProject do |project|
        project.name = @name.text
        project.djMonURL = @djMonURL.text
        project.username = @username.text
        project.password = @password.text
      end
     navigationController.popViewControllerAnimated(true)
    end
    false
  end

  def textFieldShouldEndEditing(textField)
    !textField.text.strip.empty?
  end

  def tableView(tableView, titleForHeaderInSection:section)
    "DJ Mon Credentials"
  end

  def tableView(tableView, titleForFooterInSection:section)
    "The URL must be the complete path to DJ Mon, eg: http://yourapp.com/dj_mon"
  end

  def shouldAutorotateToInterfaceOrientation(interfaceOrientation)
    true
  end

  private

  def changeFirstResponderTo(to, from:from)
    from.resignFirstResponder
    to.becomeFirstResponder
  end

  def buildTextFieldWithPlaceholder(placeholder, keyboardType:keyboardType, returnKeyType:returnKeyType, isSecure:isSecure)
    UITextField.alloc.initWithFrame([[20, 10], [275, 30]]).tap do |field|
      field.placeholder = placeholder
      field.keyboardType = keyboardType
      field.returnKeyType = returnKeyType
      field.secureTextEntry = isSecure
      field.autocorrectionType = UITextAutocorrectionTypeNo
      field.autocapitalizationType = UITextAutocapitalizationTypeNone
      field.textAlignment = UITextAlignmentLeft
      field.clearButtonMode = UITextFieldViewModeNever
      field.enabled = true
      field.delegate = self
    end
  end

end
