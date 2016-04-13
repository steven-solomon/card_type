require 'rspec'
require 'card_type'

describe 'CardType' do
  it 'is an unknown card' do
    card = CardType.new(1111111111111111)
    expect(card.name).to eq('Unknown')
  end

  it 'is an amex card' do
    card = CardType.new(378282246310005)
    expect(card.name).to eq('AMEX')
  end

  it 'is a visa card' do
    card = CardType.new(4111111111111111)
    expect(card.name).to eq('VISA')
  end

  it 'is a discover card' do
    card = CardType.new(6011111111111117)
    expect(card.name).to eq('Discover')
  end

  it 'is a master card' do
    card = CardType.new(5555555555554444)
    expect(card.name).to eq('Mastercard')
  end
end
