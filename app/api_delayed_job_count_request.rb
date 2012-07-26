class APIDelayedJobCountRequest

  def initialize project
    @project = project
  end

  def execute &successHandler
    @successHandler = successHandler
  end


end
