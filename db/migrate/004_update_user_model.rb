Sequel.migration do
  up do
    add_column :users, :validation_code, String, null: true
    add_column :users, :update_password, TrueClass, default: false
  end

  down do
    remove_column :users, :validation_code
    remove_column :users, :update_password
  end
end

