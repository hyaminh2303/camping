class UpdateWeightOfExistingStates < ActiveRecord::Migration[6.1]
  def change
    # https://app.clickup.com/t/1qeevtt | https://app.clickup.com/t/2ad3wc0
    #1 => Hokkaido, #2 => TOHOKU, #3 => KANTO, #4 => CHUBU,
    #5 => KANSAI, #6=> CHUGOKU, #7=> SHIKOKU, and #8 => KYUSYU

    weight = 0

    [
      "hokkaido",
      "tohoku",
      "kanto",
      "chubu",
      "kansai",
      "chugoku",
      "shikoku",
      "kyushu"
    ].each do |code|
      state = Master::State.find_by_code(code)

      state.update(weight: weight += 1) if state.present?
    end
  end
end
