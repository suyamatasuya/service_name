class Symptom < ApplicationRecord
  belongs_to :user
  has_and_belongs_to_many :care_methods
  has_many :user_care_histories

  validates :pain_location, presence: true, if: :on_pain_location_step?
  validates :pain_type, presence: true, if: :on_pain_type_step?
  validates :pain_intensity, presence: true, if: :on_pain_intensity_step?
  validates :pain_start_time, presence: true, if: :on_pain_start_time_step?
  validates :injury_related, presence: true, if: :on_injury_related_step?

  def required_for_step?(step)
    # All fields are required if no step is present
    return true if current_step.nil?

    # All fields from previous steps are required if the
    # current step is higher than the step parameter
    return true if self.class.form_steps.index(step.to_s) <= self.class.form_steps.index(current_step)

    # The current field is not required
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
    return [] unless pain_location && pain_start_time && pain_type && pain_intensity
    care_methods = CareMethod.none # ケア方法を格納するクエリオブジェクトを初期化

    if pain_location == '首'
      care_methods = care_methods.or(CareMethod.where(name: "首の痛みに対するケア方法"))
    elsif pain_location == '腰'
      care_methods = care_methods.or(CareMethod.where(name: "腰の痛みに対するケア方法"))
    end

    case pain_start_time
    when '今日'
      care_methods = care_methods.or(CareMethod.where(name: "急性の痛みに対するケア方法"))
    when '1日から3日前'
      care_methods = care_methods.or(CareMethod.where(name: "数日前からの痛みに対するケア方法"))
    when '4日以上前'
      care_methods = care_methods.or(CareMethod.where(name: "慢性的な痛みに対するケア方法"))
    end

    if injury_related
      care_methods = care_methods.or(CareMethod.where(name: "外傷による痛みに対するケア方法"))
    else
      care_methods = care_methods.or(CareMethod.where(name: "非外傷性の痛みに対するケア方法"))
    end

    case pain_type
    when '鋭い痛み'
      care_methods = care_methods.or(CareMethod.where(name: "鋭い痛みに対するケア方法"))
    when '鈍い痛み'
      care_methods = care_methods.or(CareMethod.where(name: "鈍い痛みに対するケア方法"))
    when '脈打つ痛み'
      care_methods = care_methods.or(CareMethod.where(name: "脈打つ痛みに対するケア方法"))
    when '電撃のように痺れる痛み'
      care_methods = care_methods.or(CareMethod.where(name: "電撃のように痺れる痛みに対するケア方法"))
    end

    if pain_intensity >= 1 && pain_intensity <= 5
      care_methods = care_methods.or(CareMethod.where(name: "普通のケア方法"))
    elsif pain_intensity >= 6 && pain_intensity <= 7
      if pain_type == '鈍い痛み'
        care_methods = care_methods.or(CareMethod.where(name: "普通のケア方法"))
      else
        care_methods = care_methods.or(CareMethod.where(name: "強い痛みに対するケア方法 安静にしましょう"))
      end
    elsif pain_intensity >= 8 && pain_intensity <= 10
      care_methods = care_methods.or(CareMethod.where(name: "早急に病院へ受診する"))
      @show_map = true
    end

    care_methods # 生成したケア方法のリストを返す
  end
  
  def group_name
    pain_location
  end

  def name_with_pain_type
    "#{pain_location} #{pain_type.present? ? "(#{pain_type})" : ''}"
  end
end
