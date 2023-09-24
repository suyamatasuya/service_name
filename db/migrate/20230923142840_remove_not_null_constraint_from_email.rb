class RemoveNotNullConstraintFromEmail < ActiveRecord::Migration[6.1]
  def change
    change_column_null :users, :email, true
  end
end  
