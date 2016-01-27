class CreateChecks < ActiveRecord::Migration
  def change
    create_table :checks do |t|
      t.string :github_user
      t.string :repo
      t.string :sha
      t.boolean :passed
      t.references :lint, index: true, foreign_key: true
      t.references :review, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
