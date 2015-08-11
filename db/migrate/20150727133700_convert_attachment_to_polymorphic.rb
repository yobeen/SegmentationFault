class ConvertAttachmentToPolymorphic < ActiveRecord::Migration
  def change
	  add_column :attachments, :attachable_id, :integer
	  add_index :attachments, :attachable_id

	  add_column :attachments, :attachable_type, :string
	  add_index :attachments, :attachable_type
  end
end
