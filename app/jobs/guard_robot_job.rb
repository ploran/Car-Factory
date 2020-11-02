class GuardRobotJob < ApplicationJob
  queue_as :default

  def perform(*args)
    #notify_defects
    update_store
    self.class.set(wait: 30.minutes).perform_later()
  end

  def update_store
    logger.info "Car´s movements from Warehouse to Store"
    assembly_lines = Assembly.lines("Warehouse", 0) #Cars with stage completed
    assembly_lines.each { |assembly_line|
      unless assembly_line.car.has_defects?
        assembly_line.line = Assembly.line(4) #Store
        assembly_line.status = 0
        assembly_line.save
      end
    }
    logger.info "Car's movements from Warehouse to Store "
  end

  def notify_defects
    SLACK_NOTIFIER.ping("Hello Slack", username: "Guard Robot")
  end
end
