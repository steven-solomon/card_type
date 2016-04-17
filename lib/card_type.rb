require 'services/mastercard_service'
require 'services/amex_service'
require 'services/visa_service'
require 'services/discover_service'
require 'batch/batch_billing'
require 'amex'
require 'visa'
require 'mastercard'
require 'discover'
require 'unknown_card'

class CardType
  def initialize(card_number, security_code = nil, current_date = nil)
    @security_code = security_code
    @card_number = card_number
    case
      when Amex.is_card?(card_number)
        @card = Amex.new(card_number)
      when discover?
        @card = Discover.new(card_number)
      when mastercard?
        @card = Mastercard.new(card_number, security_code, current_date)
      when visa?
        @card = Visa.new(card_number)
      else
        @card = UnknownCard.new
    end
  end

  def charge(amount)
    @card.charge(amount)
  end

  def name
    @card.name
  end

  def return(receipt)
    @card.return(receipt)
  end

  private

  attr_accessor :card_number

  def card_num_length
    @card_num_length ||= card_number.to_s.size
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
