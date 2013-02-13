module ScheduleQueueHelper
  def self.extended(klass)
    klass.instance_eval do
      self.queue_name = nil
      chain :queue do |queue_name|
        self.queue_name = queue_name
      end
    end
  end

  private

  attr_accessor :queue_name

  def schedule_queue_for(actual)
    if @queue_name
      ResqueSpec.queue_by_name(@queue_name)
    else
      ResqueSpec.schedule_for(actual)
    end
  end
end