require 'amex'

describe 'Amex' do
  let(:card_number) { '378282246310005' }
  subject { Amex.new(card_number) }

  describe '#name' do
    it 'returns name' do
      expect(subject.name).to eq('AMEX')
    end
  end

  describe '#charge' do
    it 'calls amex service' do
      receipt = double(:receipt)
      amount = 10.00
      expect(AmexService)
        .to receive(:hold)
              .with(card_number, amount)
              .and_return(receipt)

      expect(BatchBilling)
        .to receive(:enqueue)
              .with(receipt)
      subject.charge(amount)
    end
  end

  describe '#return' do
    it 'calls refund on amex service' do
      amount = 20.00
      expect(AmexService)
        .to receive(:refund)
              .with(card_number, amount)

      subject.return(double(:receipt, amount: amount))
    end
  end
end
