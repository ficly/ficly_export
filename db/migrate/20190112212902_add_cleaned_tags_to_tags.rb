class AddCleanedTagsToTags < ActiveRecord::Migration[5.2]
  def change
    add_column :tags, :cleaned_tag, :string
  end
end
