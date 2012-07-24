class ProjectsStore

  def self.shared
    @shared ||= ProjectsStore.new
  end

  def projects
    @projects ||= begin
                    request = NSFetchRequest.alloc.init
                     request.entity = NSEntityDescription.entityForName('Project', inManagedObjectContext:@context)

                    errorPtr = Pointer.new(:object)
                    data = @context.executeFetchRequest(request, error:errorPtr)
                    if data.nil?
                      raise "Error when fetch data: #{errorPtr[0].description}"
                    end
                    data
                  end
  end

  def newProject
    yield NSEntityDescription.insertNewObjectForEntityForName('Project', inManagedObjectContext:@context)
    save
  end

  def save
    errorPtr = Pointer.new(:object)
    unless @context.save(errorPtr)
      raise "Error when saving the model: #{errorPtr[0].description}"
    end
    @projects = nil
  end

  private

  def initialize
    model = NSManagedObjectModel.alloc.init
    model.entities = [ Project.entity ]
    store = NSPersistentStoreCoordinator.alloc.initWithManagedObjectModel(model)
    store_url = NSURL.fileURLWithPath(File.join(NSHomeDirectory(), 'Documents', 'DJMon.sqlite'))
    error_ptr = Pointer.new(:object)

    unless store.addPersistentStoreWithType(NSSQLiteStoreType, configuration:nil, URL:store_url, options:nil, error:error_ptr)
      raise "Can't add persistent SQLite store: #{error_ptr[0].description}"
    end

    context = NSManagedObjectContext.alloc.init
    context.persistentStoreCoordinator = store
    @context = context
  end

end
