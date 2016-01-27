class CreateLints < ActiveRecord::Migration
  def change
    create_table :lints do |t|
      t.string :description

      t.timestamps null: false
    end
  end
end
