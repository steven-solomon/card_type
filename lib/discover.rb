class Discover
  def initialize(card_number)
    @card_number = card_number
  end

  def name
    'Discover'
  end

  def charge(amount)
    receipt = DiscoverService.hold(@card_number, amount)
    BatchBilling.enqueue(receipt)
  end
end
