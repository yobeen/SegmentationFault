class RemoveUserFromQuestion < ActiveRecord::Migration
  def change
    remove_reference :questions, :user, index: true
    remove_foreign_key :questions, :users
  end
end
