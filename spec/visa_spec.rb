require 'visa'

describe 'Visa' do
  let(:card_number) { '4111111111111111' }
  subject { Visa.new(card_number) }

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
end
