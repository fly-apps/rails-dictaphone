class CreateClips < ActiveRecord::Migration[7.1]
  def change
    create_table :clips do |t|
      t.string :name
      t.text :text

      t.timestamps
    end
  end
end
