class AddCampsiteToCampsitePlanOptions < ActiveRecord::Migration[6.1]
  def change
    add_reference :campsite_plan_options, :campsite
    add_reference :campsite_plan_options, :supplier_company
  end
end
