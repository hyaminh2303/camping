class AutocompletesController < ApplicationController
  # https://app.clickup.com/t/1yyumj3 | 【Header】Search function
  def search_free_word
    @campsites = Campsite.includes(:photos).
                          with_prefecture_translations(I18n.locale).
                          without_keep_private().
                          search_name_by(params[:keywords]).
                          page(params[:page]).
                          order(created_at: :desc)
  end
end
