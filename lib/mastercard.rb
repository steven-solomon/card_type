class Mastercard
  def initialize(card_number, security_code, current_date)
    @card_number = card_number
    @security_code = security_code
  end

  def name
    'Mastercard'
  end

  def charge(amount)
    MastercardService.charge(@card_number, amount, @security_code)
  end

  def return(receipt)
    MastercardService.refund(@card_number, receipt.amount, @security_code, receipt.date)
  end
end
