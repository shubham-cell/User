class Transaction < ApplicationRecord
    # Associations
    belongs_to :new_user, class_name: "NewUser"  # Explicitly reference NewUser model

  # Correct Enum Definition
    #enum transaction_category: { credit: 0, debit: 1 }
it
    after_commit :update_user_balance

    private
    
    def update_user_balance
        user = self.new_user
        balance = user.balance_amount
        if self.credit?
            balance += self.amount
        else
            balance -= self.amount
        end
        balance.save
    end
end