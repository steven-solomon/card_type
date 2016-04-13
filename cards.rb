class CardFactory
  card_types = [AmericanExpress, Discover, Mastercard, Visa]

  def self.make_card(card_number)
    @card_number = card_number.to_s
    if AmericanExpress.is_type?(@card_number)
      AmericanExpress.new
    elsif Discover.is_type?(@card_number)
      Discover.new
    elsif Mastercard.is_type?(@card_number)
      Mastercard.new
    elsif Visa.is_type?(@card_number)
      Visa.new
    else
      InvalidCard.new
    end
  end
end

class AmericanExpress
  def name
    "AMEX"
  end

  def self.is_type?(card_number)
    card_number.length == 15 &&
      ([*34..37].include? card_number[0..1].to_i)
  end
end

class Discover
  def name
    "Discover"
  end

  def self.is_type?(card_number)
    card_number.length == 16 &&
      card_number[0..3].to_i == 6011
  end
end

class Mastercard
  def name
    'Mastercard'
  end

  def self.is_type?(card_number)
    card_number.length == 16 &&
      ([*51..55].include? card_number[0..1].to_i)
  end
end

class Visa
  def name
    'VISA'
  end

  def self.is_type?(card_number)
    (card_number.length == 15 || card_number.length) &&
      card_number[0].to_i == 4
  end
end

class UnknownCard
  def name
    'Unknown'
  end

  def self.is_type?(card_number)
    false
  end
end
