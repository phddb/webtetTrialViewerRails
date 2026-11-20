class CreateTrials < ActiveRecord::Migration[7.2]
  def change
    create_table :trials do |t|
      t.uuid :uuid, null: false
      t.datetime :start_time
      t.decimal :score, precision: 10, scale: 6
      t.string :cookie
      t.float :audio_file_hash
      t.jsonb :raw, null: false, default: {}

      t.timestamps
    end

    add_index :trials, :uuid, unique: true
    add_index :trials, :start_time
  end
end
