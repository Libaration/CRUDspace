class FixTypoInMessagesTable < ActiveRecord::Migration
  def change
    rename_column :messages, :reciever_id, :receiver_id
  end
end
