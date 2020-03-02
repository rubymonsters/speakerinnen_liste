class CreateServices < ActiveRecord::Migration[5.2]
  def change
    create_table :services do |t|
      t.string :name
    end

    create_join_table :services, :profiles do |t|
      t.index [:service_id, :profile_id]
    end

    Service.create(name: 'Talk')
    Service.create(name: 'Moderation')
    Service.create(name: 'Workshop management')
    Service.create(name: 'Consulting')
    Service.create(name: 'Coaching')
    Service.create(name: 'Interview')
  end
end
