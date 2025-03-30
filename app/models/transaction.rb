class Transaction < ApplicationRecord
    # Associations
    belongs_to :new_user, class_name: "NewUser"  # Explicitly reference NewUser model

  # Correct Enum Definition
    #enum transaction_category: { credit: 0, debit: 1 }
    after_commit :update_user_balance
    before_save :check_transaction_budget

    private
    
    def update_user_balance
        user = self.new_user
        balance = user.balance_amount.amount.to_i
        if self.transaction_category == 0
            balance = balance + self.amount.to_i
        else
            balance = balance - self.amount.to_i
        end
        user.balance_amount.update(amount: balance)
    end

    def check_transaction_budget
        balance_amount = self.new_user.balance_amount
        if self.transaction_category == 1 && balance_amount.present?
            if balance_amount.amount < self.amount
                errors.add(:amount, "exceeds budget limit")
                throw :abort
            end
        end
    end
end