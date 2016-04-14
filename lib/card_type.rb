class MastercardService
  def self.charge(amount, security_code)
  end
end

class AmexService
  def self.hold(amount)
  end
end

class VisaService
  def self.charge(amount)
  end
end

class DiscoverService
  def self.hold(amount)
  end
end

class BatchBilling
  def self.enqueue(receipt)
  end
end

class CardType
  attr_accessor :card_number

  def initialize(card_number, security_code = nil)
    @security_code = security_code
    @card_number = card_number.to_s
  end

  def charge(amount)
    case
      when american_express?
        receipt = AmexService.hold(amount)
        BatchBilling.enqueue(receipt)
      when mastercard?
        MastercardService.charge(amount, @security_code)
      when visa?
        if (amount >= 500)
          raise StandardError.new 'Error: amount exceeds limit'
        else
          VisaService.charge(amount)
        end
      when discover?
        receipt = DiscoverService.hold(amount)
        BatchBilling.enqueue(receipt)
    end
  end

  def name
    case
      when american_express?
        'AMEX'
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
