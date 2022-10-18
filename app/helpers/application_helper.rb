module ApplicationHelper
  def js_ready_tag(script)
    raw("<script>$(function(){#{script}})</script>")
  end

  def flash_class(level)
    case level
      when "notice" then "alert alert-success"
      when "success" then "alert alert-success"
      when "error" then "alert alert-danger"
      when "alert" then "alert alert-danger"
    end
  end

  def labeled_data_paragraph label, data, options={}
    if options[:class].present?
      options[:class] += " labeled_data_paragraph"
    else
      options[:class] = "labeled_data_paragraph"
    end

    content_tag :p, options do
      if label.present?
        (content_tag :label, raw("#{label}: &nbsp")) + sanitize_content(data.to_s)
      else
        sanitize_content(data.to_s)
      end
    end
  end

  def sanitize_content field
    return field if [FalseClass, TrueClass].include?(field.class)

    if field.present?
      field
    else
      I18n.t('views.empty')
    end
  end

  def gcamp_round_price(price)
    price&.round
  end

  def gcamp_image_tag(image, options={})
    image_url =
      if image.present?
        image.url
      else
        'fallback/image_not_available.png'
      end

    image_tag image_url, options
  end

  def link_to_delete_with path, options = {}
    options[:label] = t('views.buttons.delete') if options[:label].blank?
    options[:class] = "#{options[:class] if options[:class].present?} btn btn-red bootbox-confirmation"
    options[:method] = :delete if options[:method].blank?
    options[:data] = {} if options[:data].blank?
    options[:data][:confirm] = t('views.messages.confirms.delete') if options[:data][:confirm].blank?
    options[:data][:confirm_button] = t('views.bootbox.buttons.confirm') if options[:data][:confirm_button].blank?
    options[:data][:cancel_button] = t('views.bootbox.buttons.cancel') if options[:data][:cancel_button].blank?

    link_to options[:label], path, options
  end

  def date_and_day_name(date)
    date_format = date.strftime(I18n.t('datetime.formats.short'))
    day_name = I18n.t("day_name.#{date.strftime('%A').downcase}")

    "#{date_format}(#{day_name})"
  end

  def global_site_tag
    #https://app.clickup.com/t/2f7fftz
    raw("
      <script async src='https://www.googletagmanager.com/gtag/js?id=#{Settings.ga_tracker_code}'></script>
      <script>
        window.dataLayer = window.dataLayer || [];
        function gtag(){window.dataLayer.push(arguments);}
        gtag('js', new Date());

        gtag('config', '#{Settings.ga_tracker_code}');
      </script>
    ")
  end

  # Overwrite the title method in the meta tags gem
  # https://app.clickup.com/t/2ew35up
  def title(title = nil, headline = '')
    title.reverse! if title.is_a? Array

    set_meta_tags(title: title) unless title.nil?
    headline.presence || meta_tags[:title]
  end

  def strip_html_to_string(raw_html)
    raw_html.gsub(/<\/?[^>]*>/, "").gsub(/\r\n?/, "").gsub(/&nbsp;/, "").first(200)
  end
end
