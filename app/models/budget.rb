class Budget < ApplicationRecord
    belongs_to :new_user
    validates :amount, presence: true, numericality: { greater_than: 0 }
    #enum budget_category: { income: 0, expense: 1 }
    after_create :create_balance_amount

    private

    def create_balance_amount
        BalanceAmount.create(new_user_id: self.new_user_id, amount: self.amount)
    end
end