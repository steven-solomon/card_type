class Amex
  def initialize(card_number)
    @card_number = card_number
  end

  def self.is_card?(card_number)
    card_number.length == 15 &&
      ([*34..37].include? card_number[0..1].to_i)
  end

  def name
    'AMEX'
  end

  def charge(amount)
    receipt = AmexService.hold(@card_number, amount)
    BatchBilling.enqueue(receipt)
  end

  def return(receipt)
    AmexService.refund(@card_number, receipt.amount)
  end
end
