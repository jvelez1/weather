# frozen_string_literal: true


RSpec.describe Weather::CLI do
  subject { described_class.new }

  let(:attributes) { 
    {
      label: 'Sábado',
      minimum: {
        today: 8,
        week_average: 9
      },
      maximum: {
        today: 18,
        week_average: 19
      }
    }
  }

  before do
    allow_any_instance_of(Weather::City).to (
      receive(:call).and_return(OpenStruct.new(valid?: true, data: attributes))
    )
  end

  it 'returns valid temperature for today' do
    expect(subject.today('Barcelona')).to eq("For Today Sábado: Minimum: 8° | Maximum: 18°")
  end

  it 'returns max average for a week' do
    expect(subject.av_max('Barcelona')).to eq("Maximum Average for this week: 19°")
  end

  it 'returns min average for a week' do
    expect(subject.av_min('Barcelona')).to eq("Minimum Average for this week: 9°")
  end
end
