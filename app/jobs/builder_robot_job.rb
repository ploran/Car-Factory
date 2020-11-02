class BuilderRobotJob < ApplicationJob
  queue_as :default

  DEFECTS_STRUCTURE_OPTIONS = [
                    "Wrong assigned Wheels",
                    "Defects deteted in CHASIS",
                    "Defects detected in ENGINE"]
  DEFECTS_ELECTRONIC_OPTIONS = [
                    "Defects detected in COMPUTER",
                    "Defects detected in LASER"]
  DEFECTS_FINAL_OPTIONS = ["Wrong assigned Year"]

  def perform(*args)
    start_assembly_cars(10)
    move_cars_finished()
    clean_cars_finished()
    self.class.set(wait: 1.minutes).perform_later()
  end

  def start_assembly_cars(buffer)
    logger.info "Automatic Construction of #{buffer} cars ..."
    buffer.times { build_car() }
    update_electronic_line()
    update_final_line()
    update_basic_structure_line()
  end

  def build_car()
    car = CarFactory.build_car()
    car.car_model = CarFactory.car_model(rand(1..10))
    #Entrance to Emsamble
    Assembly.input_new_car(car)
    logger.info "Cars added to the Basic Structure Line"
  end

  def update_basic_structure_line()
    lines = Assembly.lines("Basic Structure",0) #Pending cars
    logger.info "Basic Structure Line: adding parts"
    lines.each {|line|
      line.prepare_car("CHASIS#{Time.now.strftime("%Y%m%d%H%M%S%L")}",
                       4,
                       "ENGINE#{Time.now.strftime("%Y%m%d%H%M%S%L")}",
                       2)
      prepare_car_computer(line.car_chasis)
      line.status = 1   #Cars with stage completed
      line.save
      #Errors generation
      generate_defects(CarComputer.find_by_name(line.car_chasis), DEFECTS_STRUCTURE_OPTIONS)
      }
    logger.info "Basic Structure Line: parts added correctly"
  end

  def update_electronic_line()
    logger.info "Electronic Devices Line: adding parts"
    lines = Assembly.lines("Electronic devices", 0)
    lines.each {|line|
      line.assign_electronic(CarComputer.find_by_name(line.car_chasis),
                            "LASER#{Time.now.strftime("%Y%m%d%H%M%S%L")}")
      line.status = 1
      line.save
      #Errors generation
      generate_defects(line.car_car_computer, DEFECTS_ELECTRONIC_OPTIONS)
      }
    logger.info "Electronic Devices Line: parts added correctly"
  end

  def update_final_line()
    lines = Assembly.lines("Paint & Final Details", 0)
    logger.info "Final line: adding parts"
    lines.each {|line|
      line.assign_car_prices(20000,20000,Time.now.year)
      line.status = 1
      line.save
      #Errors generation
      generate_defects(line.car_car_computer, DEFECTS_FINAL_OPTIONS)
      }
    logger.info "Final line: parts added correctly"
  end

  def move_cars_finished()
    logger.info "Car's movements between lines"
    assembly_lines = Assembly.where(status: 1) #Cars with stage completed
    assembly_lines.each { |assembly_line|
        if assembly_line.line == Assembly.line(0)
          logger.info "Car's movements from Line 1 to 2"
          assembly_line.line = Assembly.line(1)
          assembly_line.status = 0
        elsif assembly_line.line == Assembly.line(1)
          "Car's movements from Line 2 to 3"
          assembly_line.line = Assembly.line(2)
          assembly_line.status = 0
        end
        assembly_line.save
    }
    assembly_lines.update_all
    logger.info "Car's movements between lines completed"
  end

  def prepare_car_computer(chasis_serial)
    CarComputer.create(name: chasis_serial)
  end

  def generate_defects(car_computer, defect_options)
    if rand(10) == 1     #1 = with defect --10 so that the error rate is low
      logger.info "Defect detected!"
      for i in 0..rand(defect_options.size)
        car_computer.defects.create(description: defect_options[i])
        logger.info "Defect: #{defect_options[i]}"
      end
      car_computer.save
    end
  end

  def clean_cars_finished()
    logger.info "Car's movements from Final to Warehouse"
    assembly_lines = Assembly.lines("Paint & Final Details", 1) #Cars with stage completed
    assembly_lines.each { |assembly_line|
      assembly_line.line = Assembly.line(3) #Warehouse
      assembly_line.status = 0
      assembly_line.save
    }
    logger.info "Car's movements from Final to Warehouse"
  end

end
