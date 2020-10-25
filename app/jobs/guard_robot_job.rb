class GuardRobotJob < ApplicationJob
  queue_as :default

  def perform(*args)
    #notify_defects()
    update_store()
    self.class.set(wait: 15.minutes).perform_later()
  end

  def update_store()
    logger.info "Movimiento de vehiculos de Warehouse a la Tienda"
    assembly_lines = Assembly.lines("Warehouse", 0) #Vehiculos con etapa terminada
    assembly_lines.each { |assembly_line|
      unless assembly_line.car.has_defects?
        assembly_line.line = Assembly.line(4) #Tienda
        assembly_line.status = 0
        assembly_line.save
      end
    }
    logger.info "Movimiento de vehiculos de Finalizado a la Tienda "
  end
end
