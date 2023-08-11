class RemoveNotNullConstraintFromUserIdInSymptoms < ActiveRecord::Migration[6.0] # バージョン番号は適切なものに変更してください
  def change
    change_column_null :symptoms, :user_id, true
  end
end
