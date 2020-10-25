class CreateAssemblies < ActiveRecord::Migration[5.1]
  def change
    create_table :assemblies do |t|
      t.string :line
      t.belongs_to :car
      t.binary :status

      t.timestamps
    end
  end
end
