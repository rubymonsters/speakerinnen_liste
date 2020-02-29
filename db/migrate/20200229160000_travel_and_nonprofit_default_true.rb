class TravelAndNonprofitDefaultTrue < ActiveRecord::Migration[5.2]
  def change
    change_column_default :profiles, :willing_to_travel, { from: false, to: true }
    change_column_default :profiles, :nonprofit, { from: false, to: true }

    Profile.reset_column_information

    say_with_time "Updating 'willing to travel' and 'nonprofit' values..." do
      Profile.all.each do |p|
        p.update_attribute :willing_to_travel, true
        p.update_attribute :nonprofit, true
      end
    end
  end
end
