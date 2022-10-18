class Bank < ApplicationRecord
  belongs_to :bankable, polymorphic: true
end

# == Schema Information
#
# Table name: banks
#
#  id                     :bigint           not null, primary key
#  account_holder         :string
#  account_holder_frigana :string
#  account_number         :string
#  account_type           :string
#  bankable_type          :string
#  branch_name            :string
#  name                   :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  bankable_id            :integer
#
