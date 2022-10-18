module GMO
  class Site < Base
    def initialize
      @gmo = GMO::Payment::SiteAPI.new(
        site_id: "tsite00044990",
        site_pass: "tt2s4h17",
        host: "kt01.mul-pay.jp"
      )

      result = gmo.save_member \
                :member_id => "dev-test-1",
                :member_name => "John Smith"

      # {"CardSeq"=>"0", "CardNo"=>"*************111", "Forward"=>"2a99662"}
      result = gmo.save_card \
                :member_id => 'dev-test-1',
                :card_no => "4111111111111111",
                :expire => "2105",
                :card_seq => "1000" # do not add this when create card

      result = gmo.exec_tran(
        :access_id => "access_id",
        :access_pass => "access_pass",
        :order_id => "100",
        :method => "1",
        :pay_times => "1",
        :member_id => "dev-test-1",
        :card_seq => "0",
        :seq_mode => "0",
        :amount => "0"
      )
    end


  end
end
