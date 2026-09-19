class User
    has_may :through, :to_do_items, :to_budgets
    has_many :to_do_items
end