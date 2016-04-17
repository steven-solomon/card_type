class Discover
  def initialize(card_number)
    @card_number = card_number
  end

  def self.is_card?(card_number)
    card_number.length == 16 && card_number[0..3].to_i == 6011
  end

  def name
    'Discover'
  end

  def charge(amount)
    receipt = DiscoverService.hold(@card_number, amount)
    BatchBilling.enqueue(receipt)
  end

  def return(receipt)
    raise 'Error: returns not valid for Discover'
  end
end
