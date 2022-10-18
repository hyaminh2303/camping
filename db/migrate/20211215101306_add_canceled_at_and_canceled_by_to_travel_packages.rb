class AddCanceledAtAndCanceledByToTravelPackages < ActiveRecord::Migration[6.1]
  def change
    add_column :travel_packages, :canceled_at, :datetime
    add_reference :travel_packages, :canceled_by, polymorphic: true
  end
end
