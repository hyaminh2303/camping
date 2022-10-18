class MoveAreaDataToAreaJaOnBlog < ActiveRecord::Migration[6.1]
  def change
    Blog.class_eval do
      acts_as_taggable_on :areas
    end

    Blog.all.each do |c|
      c.areas_ja_list.add(c.area_list)
      c.save(validate: false)
    end
  end
end
