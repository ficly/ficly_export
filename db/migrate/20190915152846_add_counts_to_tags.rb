class AddCountsToTags < ActiveRecord::Migration[5.2]
  def change
    change_table :tags do |t|
      t.integer :stories_count, default: 0
      t.integer :challenges_count, default: 0
    end
  end
end
