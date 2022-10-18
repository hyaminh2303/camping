class Admin::DeeplTranslationsController < Admin::AdminController

  def translate
    translate_by_deepl_service = TranslateByDeeplService.new(params[:source_text], params[:target_lang])
    result = translate_by_deepl_service.run

    render json: {translated_result: result}
  end
end
