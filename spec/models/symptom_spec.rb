# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Symptom do
  let(:symptom) { described_class.new }

  describe '#required_for_step?' do
    context 'when current_step is nil' do
      it 'returns true' do
        expect(symptom).to be_required_for_step('pain_location')
      end
    end

    context 'when current_step is less than or equal to given step' do
      before { symptom.current_step = 'pain_location' }

      it 'returns true for the pain_location step' do
        expect(symptom).to be_required_for_step('pain_location')
      end

      it 'returns false for a previous step' do
        expect(symptom).not_to be_required_for_step('pain_type')
      end

      it 'returns false for a subsequent step' do
        expect(symptom).not_to be_required_for_step('pain_intensity')
      end
    end
  end

  describe 'step checking methods' do
    before { symptom.current_step = 'pain_location' }

    it '#on_pain_location_step? returns true for pain_location step' do
      expect(symptom).to be_on_pain_location_step
    end

    it '#on_pain_type_step? returns false for pain_location step' do
      expect(symptom).not_to be_on_pain_type_step
    end

    it '#on_pain_intensity_step? returns false for pain_location step' do
      expect(symptom).not_to be_on_pain_intensity_step
    end

    it '#on_pain_start_time_step? returns false for pain_location step' do
      expect(symptom).not_to be_on_pain_start_time_step
    end

    it '#on_injury_related_step? returns false for pain_location step' do
      expect(symptom).not_to be_on_injury_related_step
    end

    it '#on_generate_care_methods_step? returns false for pain_location step' do
      expect(symptom).not_to be_on_generate_care_methods_step
    end
  end

  describe '#generate_care_methods' do
    let(:care_methods) { symptom.generate_care_methods.to_a }

    context 'when pain is severe' do
      before { symptom.pain_intensity = 9 }

      it 'recommends visiting a medical institution' do
        expect(care_methods).to include('医療機関へ受診することを推奨します')
      end
    end

    context 'when pain started today' do
      before { symptom.pain_start_time = '今日' }

      it 'recommends visiting a medical institution' do
        expect(care_methods).to include('医療機関へ受診することを推奨します')
      end
    end

    context 'when pain is related to injury' do
      before { symptom.injury_related = true }

      it 'recommends visiting a medical institution' do
        expect(care_methods).to include('医療機関へ受診することを推奨します')
      end
    end

    context 'when pain is shocking' do
      before { symptom.pain_type = '電撃のように痺れる痛み' }

      it 'recommends visiting a medical institution' do
        expect(care_methods).to include('医療機関へ受診することを推奨します')
      end
    end

    context 'when pain is sharp or pulsating' do
      it 'provides regular care methods for sharp pain' do
        symptom.pain_type = '鋭い痛み'
        expect(care_methods).to include('強い痛みに対するケア方法')
      end

      it 'provides regular care methods for pulsating pain' do
        symptom.pain_type = '脈打つ痛み'
        expect(care_methods).to include('強い痛みに対するケア方法')
      end
    end

    context 'when pain location is neck' do
      before { symptom.pain_location = '首' }

      it 'provides care methods for neck pain' do
        expect(care_methods).to include('首の痛みに対するケア方法')
      end
    end

    context 'when pain location is lower back' do
      before { symptom.pain_location = '腰' }

      it 'provides care methods for lower back pain' do
        expect(care_methods).to include('腰の痛みに対するケア方法')
      end
    end
  end

  describe '#group_name' do
    it 'returns pain_location' do
      symptom.pain_location = '首'
      expect(symptom.group_name).to eq '首'
    end
  end

  describe '#name_with_pain_type' do
    it 'returns pain_location with pain_type' do
      symptom.pain_location = '首'
      symptom.pain_type = '鋭い痛み'
      expect(symptom.name_with_pain_type).to eq '首 (鋭い痛み)'
    end

    it 'returns only pain_location if pain_type is not present' do
      symptom.pain_location = '首'
      expect(symptom.name_with_pain_type).to eq '首'
    end
  end
end
