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
  def self.make(card_number, security_code = nil, current_date = nil)
    case
      when Amex.is_card?(card_number)
        Amex.new(card_number)
      when Discover.is_card?(card_number)
        Discover.new(card_number)
      when Visa.is_card?(card_number)
        Visa.new(card_number)
      when Mastercard.is_card?(card_number)
        Mastercard.new(card_number, security_code, current_date)
      else
        UnknownCard.new
    end
  end
end
