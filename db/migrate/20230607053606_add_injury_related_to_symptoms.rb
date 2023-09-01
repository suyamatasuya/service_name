# frozen_string_literal: true

class AddInjuryRelatedToSymptoms < ActiveRecord::Migration[6.1]
  def change
    add_column :symptoms, :injury_related, :boolean
  end
end
