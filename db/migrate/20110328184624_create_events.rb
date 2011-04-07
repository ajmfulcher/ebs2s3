class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.datetime :started
      t.string :status
      t.text :message
      t.references :job

      t.timestamps
    end
  end

  def self.down
    drop_table :events
  end
end
