task adjust_cities_data: :environment do
  # https://app.clickup.com/t/24ppfbf
  # Cities need to be removed
  reduction_cities_code = %w[
    mount_chokai
    mt_chokai
    mt_tsukuba
    oikawa
    gero_gujo
    gozaisho
    kitakyushu_munakata
    unzen
    kunisaki
  ]

  reduction_cities = Master::City.where(code: reduction_cities_code)
  reduction_cities.select{|x| x.campsites.blank?}.each(&:destroy)

  puts '********* Cities were successfully deleted *********'

  cities_ids = reduction_cities.select{|x| x.campsites.present?}.map(&:id)
  puts "The remaining cities have campsites belonging to: #{cities_ids}"

  puts '##################################################'
  puts '********* Adding cities are processing *********'
  # Cities need to be created
  {
    'fukushima': {
      'hamadouri_souma': '浜通り/相馬'
    },
    'tokyo': {
      'middle_city': '都心部'
    },
    'saitama': {
      'south_north': '県南/県北'
    },
    'chiba': {
      'narita_inbanuma': '成田、印旛沼'
    },
    'tochigi': {
      'ikaho_mooka': '伊香保、真岡'
    },
    'toyama': {
      'himi_takaoka': '氷見/高岡',
      'toyama': '富山'
    },
    'okayama': {
      'niimi_takahashi': '新見、高梁'
    },
    'shimane': {
      'matsue': '松江'
    },
    'tokushima': {
      'naruto_komatuzima': '鳴門、小松島'
    },
    'kagawa': {
      'goshikidai_sanuki': '五色台、さぬき'
    },
    'kumamoto': {
      'kuma_hitoyoshi': '球磨/人吉'
    },
    'miyazaki': {
      'nichinan': '日南'
    }
  }.each do |prefecture_code, cities|
    prefecture = Master::Prefecture.find_by_code(prefecture_code)

    next if prefecture.blank?

    cities.each do |code, name_ja|
      attrs = {
        prefecture_id: prefecture.id,
        code: code,
        name: name_ja
      }
      Master::City.find_or_create_by(attrs)

      print '.'
    end
  end

  puts ''
  puts '********* Cities were successfully created *********'

end