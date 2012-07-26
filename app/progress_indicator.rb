class ProgressIndicator

  def initialize view, waitMessage
    @hudView = UIView.alloc.initWithFrame([[75, 100], [170, 170]])
    @hudView.backgroundColor = UIColor.colorWithRed(0, green:0, blue:0, alpha:0.5)
    @hudView.clipsToBounds = true;
    @hudView.layer.cornerRadius = 10.0

    @activityIndicatorView = UIActivityIndicatorView.alloc.initWithActivityIndicatorStyle(UIActivityIndicatorViewStyleWhiteLarge)
    @activityIndicatorView.frame = [[65, 40], [ @activityIndicatorView.bounds.size.width, @activityIndicatorView.bounds.size.height ]]
    @activityIndicatorView.startAnimating
    @hudView.addSubview @activityIndicatorView

    @captionLabel = UILabel.alloc.initWithFrame([[20, 115], [130, 22]])
    @captionLabel.backgroundColor = UIColor.clearColor
    @captionLabel.textColor = UIColor.whiteColor
    @captionLabel.adjustsFontSizeToFitWidth = true
    @captionLabel.textAlignment = UITextAlignmentCenter
    @captionLabel.text = waitMessage
    @hudView.addSubview @captionLabel

    @hudView.hidden = true
    view.addSubview @hudView
  end

  def show
    @hudView.hidden = false
  end

  def hide
    @hudView.hidden = true
  end

end
