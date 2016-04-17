require 'discover'

describe 'Discover' do
  let(:card_number) { '6011111111111117' }
  subject {Discover.new(card_number)}

  describe 'self' do
    describe '#is_card?' do
      context 'when card number is too short' do
        it 'is false' do
          expect(Discover.is_card?('111111111111111')).to eq(false)
        end
      end

      context 'when card number is correct length' do
        context 'when card number does not valid combination' do
          it 'is false' do
            expect(Discover.is_card?('1111111111111111')).to eq(false)
          end
        end

        context 'when card number is valid combination' do
          it 'is true' do
            expect(Discover.is_card?('6011111111111111')).to eq(true)
          end
        end
      end

      context 'when card number is too long' do
        it 'is false' do
          expect(Discover.is_card?('111111111111111111')).to eq(false)
        end
      end
    end
  end

  describe '#name' do
    it 'returns name' do
      expect(subject.name).to eq('Discover')
    end
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
