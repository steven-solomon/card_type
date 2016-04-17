require 'unknown_card'

describe 'UnknownCard' do
  subject { UnknownCard.new }
  describe '#name' do
    it 'returns name' do
      expect(subject.name).to eq('Unknown')
    end
  end

  describe '#charge' do
    it 'does NOT call any services' do
      amount = 10.00
      expect(AmexService)
        .to_not receive(:hold)
              .with(nil, amount)
      expect(VisaService)
        .to_not receive(:charge)
              .with(nil, amount)
      expect(DiscoverService)
        .to_not receive(:hold)
              .with(nil, amount)
      expect(MastercardService)
        .to_not receive(:charge)
              .with(nil, amount, nil)

      subject.charge(amount)
    end
  end

  describe '#return' do
    it 'responds to return' do
      expect(subject).to respond_to(:return)
    end
  end
end
