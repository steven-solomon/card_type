require 'visa'

describe 'Visa' do
  let(:card_number) { '4111111111111111' }
  subject { Visa.new(card_number) }

  describe 'self' do
    describe '#is_card?' do
      context 'when card number is too short' do
        it 'is false' do
          expect(Visa.is_card?('111111111111111')).to eq(false)
        end
      end

      context 'when card number is correct length' do
        context 'when card number does not valid combination' do
          it 'is false' do
            expect(Visa.is_card?('1111111111111111')).to eq(false)
          end
        end

        context 'when card number is valid combination' do
          it 'is true' do
            expect(Visa.is_card?('4111111111111111')).to eq(true)
          end
        end
      end

      context 'when card number is too long' do
        it 'is false' do
          expect(Visa.is_card?('11111111111111111')).to eq(false)
        end
      end
    end
  end

  describe '#name' do
    it 'returns name' do
      expect(subject.name).to eq('VISA')
    end
  end

  describe '#charge' do
    context 'when amount is less than upper bound' do
      it 'calls Visa service' do
        amount = 10.00
        expect(VisaService)
          .to receive(:charge)
                .with(card_number, amount)
        subject.charge(amount)
      end

      it 'calls Visa service' do
        amount = 499.00
        expect(VisaService)
          .to receive(:charge)
                .with(card_number, amount)
        subject.charge(amount)
      end
    end

    context 'when amount is greater than upper bound' do
      it 'throws an exception' do
        amount = 500.00

        expect { subject.charge(amount) }.to raise_error('Error: amount exceeds limit')
      end

      it 'throws an exception' do
        amount = 501.00

        expect { subject.charge(amount) }.to raise_error('Error: amount exceeds limit')
      end
    end
  end

  describe '#return' do
    context 'when refund succeeds' do
      it 'calls refund on visa service' do
        receipt = double(:receipt, amount: 20.00)
        expect(VisaService)
          .to receive(:refund)
                .with(receipt)
                .and_return(double(:response, success: true))

        subject.return(receipt)
      end
    end

    context 'when refund fails' do
      it 'calls refund on visa service' do
        receipt = double(:receipt, amount: 20.00)
        expect(VisaService)
          .to receive(:refund)
                .with(receipt)
                .and_return(double(:response, success: false))

        expect { subject.return(receipt) }
          .to raise_error('Error: return not valid')
      end
    end
  end
end
