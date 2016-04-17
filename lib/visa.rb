class Visa
  def initialize(card_number)
    @card_number = card_number
  end

  def self.is_card?(card_number)
    card_number.length == 16 && card_number[0].to_i == 4
  end

  def name
    'VISA'
  end

  def charge(amount)
    if (amount >= 500)
      raise StandardError.new 'Error: amount exceeds limit'
    else
      VisaService.charge(@card_number, amount)
    end
  end

  def return(receipt)
    response = VisaService.refund(receipt)
    raise 'Error: return not valid' unless response.success
  end
end
