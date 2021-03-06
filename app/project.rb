class Project < NSManagedObject

  attr_accessor :delayedJobCounts, :settings, :delayedJobs

  def self.entity
    @entity ||= begin
                  NSEntityDescription.alloc.init.tap do |entity|
                    entity.name = 'Project'
                    entity.managedObjectClassName = 'Project'
                    entity.properties = 
                      [ 'name',     NSStringAttributeType,
                        'djMonURL', NSStringAttributeType,
                        'username', NSStringAttributeType,
                        'password', NSStringAttributeType ].each_slice(2).map do |name, type|
                          NSAttributeDescription.alloc.init.tap do |property|
                            property.name = name
                            property.attributeType = type
                            property.optional = false
                          end
                        end
                  end
                end
  end

  def awakeFromInsert
    @delayedJobCounts, @settings, @delayedJobs = {}, {}, Hash.new([])
  end

  def awakeFromFetch
    @delayedJobCounts, @settings, @delayedJobs = {}, {}, Hash.new([])
  end

end
