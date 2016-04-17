require 'amex'

describe 'Amex' do
  let(:card_number) { '378282246310005' }
  subject { Amex.new(card_number) }

  describe 'self' do
    describe '#is_card?' do
      context 'when card number is too short' do
        it 'is false' do
          expect(Amex.is_card?('11111111111111')).to eq(false)
        end
      end

      context 'when card number is correct length' do
        context 'when card number does not valid combination' do
          it 'is false' do
            expect(Amex.is_card?('111111111111111')).to eq(false)
          end
        end

        context 'when card number is valid combination' do
          it 'is true' do
            expect(Amex.is_card?('341111111111111')).to eq(true)
            expect(Amex.is_card?('351111111111111')).to eq(true)
            expect(Amex.is_card?('361111111111111')).to eq(true)
            expect(Amex.is_card?('371111111111111')).to eq(true)
          end
        end
      end

      context 'when card number is too long' do
        it 'is false' do
          expect(Amex.is_card?('1111111111111111')).to eq(false)
        end
      end
    end
  end

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
