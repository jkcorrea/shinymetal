class CreateOrganizations < ActiveRecord::Migration
  def change
    create_table :organizations do |t|
      t.string :name
      t.integer :external_id
      t.boolean :removed, default: false

      t.timestamps null: false
    end
  end
end
