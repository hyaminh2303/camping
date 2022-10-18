class MoveTagsDataToTagsJaOnCampsitePlans < ActiveRecord::Migration[6.1]
  def change
    CampsitePlan.class_eval do
      acts_as_taggable_on :tags
    end

    CampsitePlan.all.each do |c|
      c.tags_ja_list.add(c.tag_list)
      c.save(validate: false)
    end
  end
end
