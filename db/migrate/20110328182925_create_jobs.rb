class CreateJobs < ActiveRecord::Migration
  def self.up
    create_table :jobs do |t|
      t.string :name
      t.text :description
      t.string :ebsvol
      t.string :cronline
      t.integer :copies

      t.timestamps
    end
  end

  def self.down
    drop_table :jobs
  end
end
