module InQueueHelper
  def self.extended(klass)
    klass.instance_eval do
      self.queue_name = nil
      chain :in do |queue_name|
        self.queue_name = queue_name
      end
    end
  end

  private

  attr_accessor :queue_name

  def queue(actual)
    if @queue_name
      ResqueSpec.queue_by_name(@queue_name)
    else
      ResqueSpec.queue_for(actual)
    end
  end

end