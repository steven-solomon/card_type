require 'mastercard'

describe 'Mastercard' do
  let(:security_code) { 956 }
  let(:current_date) { DateTime.new(2015, 01, 01) }
  let(:card_number) { '5555555555554444' }
  subject {Mastercard.new(card_number, 956, current_date)}

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
