require 'rspec'
require 'card_type'

describe 'CardType' do
  context 'unknown card' do
    subject { CardType.new(1111111111111111) }

    it 'populates name' do
      expect(subject.name).to eq('Unknown')
    end

    describe '#charge' do
      it 'does NOT call any services' do
        amount = 10.00
        expect(AmexService)
          .to_not receive(:hold)
                .with(amount)
        expect(VisaService)
          .to_not receive(:charge)
                .with(amount)
        expect(DiscoverService)
          .to_not receive(:hold)
                .with(amount)
        expect(MastercardService)
          .to_not receive(:charge)
                .with(amount, nil)

        subject.charge(amount)
      end
    end
  end

  context 'amex card' do
    subject {
      CardType.new(378282246310005)
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
                .with(amount)
                .and_return(receipt)

        expect(BatchBilling)
          .to receive(:enqueue)
                .with(receipt)
        subject.charge(amount)
      end
    end
  end

  context 'visa card' do
    subject { CardType.new(4111111111111111) }
    it 'populates name' do
      expect(subject.name).to eq('VISA')
    end

    describe '#charge' do
      context 'when amount is less than upper bound' do
        it 'calls Visa service' do
          amount = 10.00
          expect(VisaService)
            .to receive(:charge)
                  .with(amount)
          subject.charge(amount)
        end

        it 'calls Visa service' do
          amount = 499.00
          expect(VisaService)
            .to receive(:charge)
                  .with(amount)
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
  end

  context 'discover card' do
    subject {CardType.new(6011111111111117)}
    it 'populates name' do
      expect(subject.name).to eq('Discover')
    end

    describe '#charge' do
      it 'calls discover service' do
        amount = 10.00
        receipt = double(:receipt)
        expect(DiscoverService)
          .to receive(:hold)
                .with(amount)
                .and_return(receipt)

        expect(BatchBilling)
          .to receive(:enqueue)
                .with(receipt)

        subject.charge(amount)
      end
    end
  end

  context 'mastercard' do
    let(:security_code) { 956 }
    subject {CardType.new(5555555555554444, 956)}

    it 'populates name' do
      expect(subject.name).to eq('Mastercard')
    end

    describe '#charge' do
      it 'calls mastercard service' do
        amount = 10.00
        expect(MastercardService)
          .to receive(:charge)
                .with(amount, security_code)
        subject.charge(amount)
      end
    end
  end
end
