# frozen_string_literal: true

# バージョン番号は適切なものに変更してください
class RemoveNotNullConstraintFromUserIdInSymptoms < ActiveRecord::Migration[6.0]
  def change
    change_column_null :symptoms, :user_id, true
  end
end
