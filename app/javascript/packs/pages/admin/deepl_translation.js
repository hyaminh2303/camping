class DeeplTranslation {
  constructor() {
  }

  bindEvents() {
    this.handleTranslate()
  }

  handleTranslate() {
    $('.btn-translate-by-deepl').on('click', (e) => {
      const sourceLangElement = $(e.target).data('translation-source-element')
      const targetLangElement = $(e.target).data('translation-target-element')
      const targetLang = $(e.target).data('translation-target-lang')
      const dataTypeTranslation = $(e.target).data('type-translation')
      switch (dataTypeTranslation) {
        case 'ckeditor':
          this.ckeditorTranslation(sourceLangElement,targetLangElement,targetLang)
          break
        case 'text':
          this.textTranslation(sourceLangElement,targetLangElement,targetLang)
          break
        case 'tags':
          this.tagTranslation(sourceLangElement,targetLangElement,targetLang)
          break
      }
    })
  }

  ckeditorTranslation(sourceLangElement,targetLangElement,targetLang){
    const sourceText = CKEDITOR.instances[sourceLangElement].getData()
    $.ajax({
      url: Routes.translate_admin_deepl_translations_path(),
      type: 'POST',
      dataType: 'json',
      data: {
        source_text: sourceText,
        target_lang: targetLang
      },
      success: (res) => {
        CKEDITOR.instances[targetLangElement].setData(res['translated_result'])
      }
    })
  }

  textTranslation(sourceLangElement,targetLangElement,targetLang){
    let sourceText = $(sourceLangElement).val()
    sourceText = sourceText.replaceAll("\n", "<br>")
    $.ajax({
      url: Routes.translate_admin_deepl_translations_path(),
      type: 'POST',
      dataType: 'json',
      data: {
        source_text: sourceText,
        target_lang: targetLang
      },
      success: (res) => {
        const regexFormat = /<br>\s?/ig
        $(targetLangElement).val(res['translated_result'].replaceAll(regexFormat, "\n"))
      }
    })
  }

  tagTranslation(sourceLangElement,targetLangElement,targetLang){
    const sourceText = $(sourceLangElement).val()
    $.ajax({
      url: Routes.translate_admin_deepl_translations_path(),
      type: 'POST',
      dataType: 'json',
      data: {
        source_text: sourceText,
        target_lang: targetLang
      },
      success: (res) => {
        $(targetLangElement).tagsinput('add',res['translated_result'])
      }
    })
  }
}

export default DeeplTranslation