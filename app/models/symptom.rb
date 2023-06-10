class Symptom < ApplicationRecord
  belongs_to :user

  def self.form_steps
    %w[pain_type pain_intensity pain_start_time injury_related]
  end

  

  def generate_care_methods
    return [] unless pain_location && pain_start_time && pain_type && pain_intensity
    care_methods = [] # ケア方法を格納する配列を初期化

    if pain_location == '首'
      care_methods << "首の痛みに対するケア方法"
    elsif pain_location == '腰'
      care_methods << "腰の痛みに対するケア方法"
    end

    case pain_start_time
    when '今日'
      care_methods << "急性の痛みに対するケア方法"
    when '1日から3日前'
      care_methods << "数日前からの痛みに対するケア方法"
    when '4日以上前'
      care_methods << "慢性的な痛みに対するケア方法"
    end

    if injury_related
      care_methods << "外傷による痛みに対するケア方法"
    else
      care_methods << "非外傷性の痛みに対するケア方法"
    end

    case pain_type
    when '鋭い痛み'
      care_methods << "鋭い痛みに対するケア方法"
    when '鈍い痛み'
      care_methods << "鈍い痛みに対するケア方法"
    when '脈打つ痛み'
      care_methods << "脈打つ痛みに対するケア方法"
    when '電撃のように痺れる痛み'
      care_methods << "電撃のように痺れる痛みに対するケア方法"
    end

    if pain_intensity >= 1 && pain_intensity <= 5
      care_methods << "普通のケア方法"
    elsif pain_intensity >= 6 && pain_intensity <= 7
      if pain_type == '鈍い痛み'
        care_methods << "普通のケア方法"
      else
        care_methods << "強い痛みに対するケア方法"
      end
    elsif pain_intensity >= 8 && pain_intensity <= 10
      care_methods << "早急に病院へ受診する"
    end

    care_methods # 生成したケア方法のリストを返す
  end
end
