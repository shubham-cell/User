class BalanceAmount < ApplicationRecord
    belongs_to :new_user

    # Validations
    #validates :amount, presence: true, numericality: { greater_than: 0 }
end