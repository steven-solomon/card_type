class CardType
  attr_accessor :card_number

  def initialize(card_number)
    @card_number = card_number.to_s
  end

  def name
    case
      when american_express?
        AmericanExpress.new.name
      when discover?
        Discover.new.name
      when mastercard?
        Mastercard.new.name
      when visa?
        Visa.new.name
      else
        InvalidCard.new.name
    end
  end

  private

  def card_num_length
    @card_num_length ||= card_number.to_s.size
  end

  def american_express?
    card_num_length == 15 &&
      ([*34..37].include? card_number[0..1].to_i)
  end

  def discover?
    card_num_length == 16 &&
      card_number[0..3].to_i == 6011
  end

  def mastercard?
    card_num_length == 16 &&
      ([*51..55].include? card_number[0..1].to_i)
  end

  def visa?
    (card_num_length == 15 || card_num_length) &&
      card_number[0].to_i == 4
  end
end

class AmericanExpress
  def name
    "AMEX"
  end
end

class Discover
  def name
    "Discover"
  end
end

class Mastercard
  def name
    'Mastercard'
  end
end

class Visa
  def name
    'VISA'
  end
end

class UnknownCard
  def name
    'Unknown'
  end
end
