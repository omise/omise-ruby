require "omise/object"

module Omise
  # {BankAccount} represents a bank account object. Bank accounts can be found
  # in transfer and recipient objects. Note that bank accounts can't be
  # retrieved directely from the API. But they will always be present in their
  # expanded form in transfers and recipients.
  #
  # Example:
  #
  #     transfer = Omise::Transfer.retrieve(transfer_id)
  #     bank_account = transfer.bank_account
  #
  class BankAccount < OmiseObject
  end
end
