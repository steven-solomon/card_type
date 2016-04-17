require 'mastercard'

describe 'Mastercard' do
  let(:security_code) { 956 }
  let(:current_date) { DateTime.new(2015, 01, 01) }
  let(:card_number) { '5555555555554444' }
  subject {Mastercard.new(card_number, 956, current_date)}

  describe 'self' do
    describe '#is_card?' do
      context 'when card number is too short' do
        it 'is false' do
          expect(Mastercard.is_card?('111111111111111')).to eq(false)
        end
      end

      context 'when card number is correct length' do
        context 'when card number does not valid combination' do
          it 'is false' do
            expect(Mastercard.is_card?('1111111111111111')).to eq(false)
          end
        end

        context 'when card number is valid combination' do
          it 'is true' do
            expect(Mastercard.is_card?('5111111111111111')).to eq(true)
            expect(Mastercard.is_card?('5211111111111111')).to eq(true)
            expect(Mastercard.is_card?('5311111111111111')).to eq(true)
            expect(Mastercard.is_card?('5411111111111111')).to eq(true)
            expect(Mastercard.is_card?('5511111111111111')).to eq(true)
          end
        end
      end

      context 'when card number is too long' do
        it 'is false' do
          expect(Mastercard.is_card?('111111111111111111')).to eq(false)
        end
      end
    end
  end

  describe '#name' do
    it 'returns name' do
      expect(subject.name).to eq('Mastercard')
    end
  end

  describe '#charge' do
    it 'calls mastercard service' do
      amount = 10.00
      expect(MastercardService)
        .to receive(:charge)
              .with(card_number, amount, security_code)
      subject.charge(amount)
    end
  end

  describe  '#return' do
    context 'when return is within 14 days' do
      let(:receipt_date) { DateTime.new(2015, 01, 02) }

      it 'calls mastercard service' do
        amount = 10.00
        receipt = double(:receipt, amount: amount, date: receipt_date)
        expect(MastercardService)
          .to receive(:refund)
                .with(card_number, amount, security_code, receipt_date)

        subject.return(receipt)
      end
    end

    context 'when return is outside of 14 days' do
      let(:receipt_date) { DateTime.new(2015, 01, 15) }
    end
  end
end
