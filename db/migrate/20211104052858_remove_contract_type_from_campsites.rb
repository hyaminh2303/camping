class RemoveContractTypeFromCampsites < ActiveRecord::Migration[6.1]
  def change
    remove_column :campsites, :contract_type, :string
  end
end
