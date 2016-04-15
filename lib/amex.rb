class Amex
  def initialize(card_number)
    @card_number = card_number
  end

  def name
    'AMEX'
  end

  def charge(amount)
    receipt = AmexService.hold(@card_number, amount)
    BatchBilling.enqueue(receipt)
  end
end
