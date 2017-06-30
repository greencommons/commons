require 'rails_helper'

describe DateHelper do
  describe '#humanize_data' do
    context 'with date' do
      it 'returns a date object' do
        date = helper.humanize_date(Date.new(2016, 1, 1))
        expect(date).to eq('January 01, 2016')
      end
    end

    context 'with nil' do
      it 'returns ""' do
        expect(helper.humanize_date(nil)).to eq('')
      end
    end
  end

  describe '#humanize_str_date' do
    context 'with valid date' do
      it 'returns a date object' do
        date = helper.humanize_str_date('2016-01-01')
        expect(date).to eq('January 01, 2016')
      end
    end

    context 'with invalid date' do
      it 'returns nil' do
        expect(helper.humanize_str_date(123)).to eq(nil)
        expect(helper.humanize_str_date('')).to eq(nil)
        expect(helper.humanize_str_date(nil)).to eq(nil)
      end
    end
  end
end
