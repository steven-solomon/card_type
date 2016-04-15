require 'rspec'
require 'card_type'
require 'date'

describe 'CardType' do
  context 'unknown card' do
    let(:card_number) { '1111111111111111' }
    subject { CardType.new(card_number) }

    it 'populates name' do
      expect(subject.name).to eq('Unknown')
    end

    describe '#charge' do
      it 'does NOT call any services' do
        amount = 10.00
        expect(AmexService)
          .to_not receive(:hold)
                .with(card_number, amount)
        expect(VisaService)
          .to_not receive(:charge)
                .with(card_number, amount)
        expect(DiscoverService)
          .to_not receive(:hold)
                .with(card_number, amount)
        expect(MastercardService)
          .to_not receive(:charge)
                .with(card_number, amount, nil)

        subject.charge(amount)
      end
    end
  end

  context 'amex card' do
    let(:card_number) { '378282246310005' }
    subject {
      CardType.new(card_number)
    }

    it 'populates name' do
      expect(subject.name).to eq('AMEX')
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

  context 'visa card' do
    let(:card_number) { '4111111111111111' }
    subject { CardType.new(card_number) }
    it 'populates name' do
      expect(subject.name).to eq('VISA')
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

  context 'discover card' do
    let(:card_number) { '6011111111111117' }
    subject {CardType.new(card_number)}
    it 'populates name' do
      expect(subject.name).to eq('Discover')
    end

    describe '#charge' do
      it 'calls discover service' do
        amount = 10.00
        receipt = double(:receipt)
        expect(DiscoverService)
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
      it 'raise error' do
        receipt = double(:receipt)
        expect { subject.return(receipt) }.to raise_error('Error: returns not valid for Discover')
      end
    end
  end

  context 'mastercard' do
    let(:security_code) { 956 }
    let(:current_date) { DateTime.new(2015, 01, 01) }
    let(:card_number) { '5555555555554444' }
    subject {CardType.new(card_number, 956, current_date)}

    it 'populates name' do
      expect(subject.name).to eq('Mastercard')
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
end
