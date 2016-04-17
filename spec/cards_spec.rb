require 'rspec'
require 'card_type'
require 'date'

describe 'CardType' do
  context 'make' do
    context 'when card_number is Amex' do
      it 'returns Amex instance' do
        card_number = '341111111111111'
        card_instance = double(:card_instance)
        expect(Amex)
          .to receive(:new)
                .with(card_number)
                .and_return(card_instance)
        expect(CardType.make('341111111111111')).to eq(card_instance)
      end
    end

    context 'when card_number is Discover' do
      it 'returns Discover instance' do
        card_number = '6011111111111111'
        card_instance = double(:card_instance)
        expect(Discover)
          .to receive(:new)
                .with(card_number)
                .and_return(card_instance)
        expect(CardType.make(card_number)).to eq(card_instance)
      end
    end

    context 'when card_number is Mastercard' do
      it 'returns Mastercard instance' do
        card_number = '5111111111111111'
        card_instance = double(:card_instance)
        security_code = 959
        date = double(:date)
        expect(Mastercard)
          .to receive(:new)
                .with(card_number, security_code, date)
                .and_return(card_instance)
        expect(CardType.make(card_number, security_code, date)).to eq(card_instance)
      end
    end

    context 'when card_number is Visa' do
      it 'returns Visa instance' do
        card_number = '4111111111111111'
        card_instance = double(:card_instance)
        expect(Visa)
          .to receive(:new)
                .with(card_number)
                .and_return(card_instance)
        expect(CardType.make(card_number)).to eq(card_instance)
      end
    end

    context 'when card_number is Unknown' do
      it 'returns UnknownCard instance' do
        card_number = '1111111111111111'
        card_instance = double(:card_instance)
        expect(UnknownCard)
          .to receive(:new)
                .and_return(card_instance)
        expect(CardType.make(card_number)).to eq(card_instance)
      end
    end
  end
end
