# frozen_string_literal: true

class Symptom < ApplicationRecord
  belongs_to :user, optional: true
  has_and_belongs_to_many :care_methods
  has_many :user_care_histories

  validates :pain_location, presence: true, if: :on_pain_location_step?
  validates :pain_type, presence: true, if: :on_pain_type_step?
  validates :pain_intensity, presence: true, if: :on_pain_intensity_step?
  validates :pain_start_time, presence: true, if: :on_pain_start_time_step?
  validates :injury_related, presence: true, if: :on_injury_related_step?

  def required_for_step?(step)
    return true if current_step.nil?
    return true if self.class.form_steps.index(step.to_s) <= self.class.form_steps.index(current_step)

    false
  end

  def on_pain_location_step?
    current_step == 'pain_location'
  end

  def on_pain_type_step?
    current_step == 'pain_type'
  end

  def on_pain_intensity_step?
    current_step == 'pain_intensity'
  end

  def on_pain_start_time_step?
    current_step == 'pain_start_time'
  end

  def on_injury_related_step?
    current_step == 'injury_related'
  end

  def on_generate_care_methods_step?
    current_step == 'generate_care_methods'
  end

  def self.form_steps
    %w[pain_location pain_type pain_intensity pain_start_time injury_related]
  end

  def generate_care_methods
    return CareMethod.none unless pain_location && pain_start_time && pain_type && pain_intensity

    care_methods = CareMethod.none

    # 一部の条件を定義
    severe_pain = pain_intensity >= 8
    pain_started_today = pain_start_time == '今日'
    related_to_injury = injury_related
    shocking_pain = pain_type == '電撃のように痺れる痛み'

    # 上記のいずれかの条件に該当する場合は、受診を推奨
    if severe_pain || pain_started_today || related_to_injury || shocking_pain
      care_methods = care_methods.or(CareMethod.where(name: '医療機関へ受診することを推奨します'))
    end

    if pain_type == '鋭い痛み' || pain_type == '脈打つ痛み'
      # それ以外の場合は、通常のケア方法を提供
      care_methods = care_methods.or(CareMethod.where(name: '強い痛みに対するケア方法'))
    end

    if pain_location == '首'
      care_methods = care_methods.or(CareMethod.where(name: '首の痛みに対するケア方法'))
    end

    if pain_location == '腰'
      care_methods = care_methods.or(CareMethod.where(name: '腰の痛みに対するケア方法'))
    end

    care_methods
  end

  def group_name
    pain_location
  end

  def name_with_pain_type
    [pain_location, pain_type.present? ? "(#{pain_type})" : nil].compact.join(' ')
  end
end
