class MoveTagDataToTagJaOnBlog < ActiveRecord::Migration[6.1]
  def change
    Blog.class_eval do
      acts_as_taggable_on :tags
    end

    Blog.all.each do |c|
      c.tags_ja_list.add(c.tag_list)
      c.save(validate: false)
    end
  end

end
