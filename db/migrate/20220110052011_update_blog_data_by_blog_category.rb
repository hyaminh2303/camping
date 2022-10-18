class UpdateBlogDataByBlogCategory < ActiveRecord::Migration[6.1]
  def change
    Blog.all.each do |blog|
      blog_category = blog.blog_category

      next if blog_category.blank? || (blog.blog_type == blog_category.category_type)

      blog_category_existed = BlogCategory.with_category_type(blog.blog_type).find_by(name: blog_category.name)

      blog_category_id = if blog_category_existed.present?
        blog_category_existed.id
      else
        blog_category_dup = blog_category.dup

        blog_category_params = {
          category_type: blog.blog_type,
          icon: blog_category.icon
        }

        blog_category_dup.assign_attributes(blog_category_params)
        blog_category_dup.save

        blog_category_dup.id
      end

      blog.update(blog_category_id: blog_category_id)
    end
  end
end
