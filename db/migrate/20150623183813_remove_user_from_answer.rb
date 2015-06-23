class RemoveUserFromAnswer < ActiveRecord::Migration
  def change
    remove_reference :answers, :user, index: true
    remove_foreign_key :answers, :users
  end
end
