class ProjectsStore

  def self.shared
    @shared ||= begin
      store = ProjectsStore.new
      store.seed if store.projects.size.zero?
      store
    end
  end

  def projects
    @projects ||= begin
                    request = NSFetchRequest.alloc.init
                     request.entity = NSEntityDescription.entityForName('Project', inManagedObjectContext:@context)

                    errorPtr = Pointer.new(:object)
                    data = @context.executeFetchRequest(request, error:errorPtr)
                    if data.nil?
                      raise "Error fetching data: #{errorPtr[0].description}"
                    end
                    data
                  end
  end

  def newProject
    yield NSEntityDescription.insertNewObjectForEntityForName('Project', inManagedObjectContext:@context)
    save
  end

  def deleteProject project
    @context.deleteObject project
    save
  end

  def save
    errorPtr = Pointer.new(:object)
    unless @context.save(errorPtr)
      raise "Error when saving the model: #{errorPtr[0].description}"
    end
    @projects = nil
  end

  def seed
    newProject do |project|
      project.name =  "Demo Project"
      project.djMonURL = "http://dj-mon-demo.herokuapp.com/dj_mon"
      project.username = "dj_mon"
      project.password = "password"
    end
  end

  private

  def initialize
    model = NSManagedObjectModel.alloc.init
    model.entities = [ Project.entity ]
    store = NSPersistentStoreCoordinator.alloc.initWithManagedObjectModel(model)
    storeUrl = NSURL.fileURLWithPath(File.join(NSHomeDirectory(), 'Documents', 'DJMon.sqlite'))

    errorPtr = Pointer.new(:object)
    unless store.addPersistentStoreWithType(NSSQLiteStoreType, configuration:nil, URL:storeUrl, options:nil, error:errorPtr)
      raise "Can't add persistent SQLite store: #{errorPtr[0].description}"
    end

    context = NSManagedObjectContext.alloc.init
    context.persistentStoreCoordinator = store
    @context = context
  end

end
