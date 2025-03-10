class NewUser < ApplicationRecord
    validates :password, presence: true
    validates :email, presence: true, uniqueness: true
    validates :name, presence: true
    # after_commit :write_query_log, on: %i[ create update destroy ]
    # has_many :documents
    has_one :balance_amount
    has_many :transactions
    has_many :documents
    has_one :budget


    private

    def write_query_log 
       print "Database query executed for User with id: #{self.id}"
    end

    # def authenticate(password)
    #     password_digest = self.password_digest
    #     if password_digest == password
    #         return true
    #     else
    #         return false
    #     end
    # end
end
