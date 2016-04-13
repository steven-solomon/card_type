class MastercardService
  def self.charge(amount)
  end
end

class AmexService
  def self.charge(amount)
  end
end

class VisaService
  def self.charge(amount)
  end
end

class DiscoverService
  def self.charge(amount)
  end
end

class BatchBilling
  def self.enqueue(receipt)
  end
end

class CardType
  attr_accessor :card_number

  def initialize(card_number)
    @card_number = card_number.to_s
  end

  def charge(amount)
    case
      when american_express?
        receipt = AmexService.charge(amount)
        BatchBilling.enqueue(receipt)
      when mastercard?
        MastercardService.charge(amount)
      when visa?
        VisaService.charge(amount)
      when discover?
        receipt = DiscoverService.charge(amount)
        BatchBilling.enqueue(receipt)
    end
  end

  def name
    case
      when american_express?
        "AMEX"
      when discover?
        'Discover'
      when mastercard?
        'Mastercard'
      when visa?
        'VISA'
      else
        'Unknown'
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
