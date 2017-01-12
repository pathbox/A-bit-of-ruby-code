add_index(:faults, [:priority, :created_at], order: {priority: :asc, created_at: :desc)
