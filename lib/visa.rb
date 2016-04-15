class Visa
  def initialize(card_number)
    @card_number = card_number
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
end
