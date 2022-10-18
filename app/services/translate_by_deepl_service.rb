class TranslateByDeeplService
  # https://app.clickup.com/t/2nvjmyg
  def initialize(source_text,target_lang)
    @source_text = source_text
    @target_lang = target_lang
  end

  def run
    translate = DeepL.translate(
      @source_text,
      nil,
      @target_lang,
      tag_handling: 'html',
      preserve_formatting: true
    )
    translate.text
  end

end
