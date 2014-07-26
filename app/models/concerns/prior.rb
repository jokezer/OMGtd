module Prior
  extend ActiveSupport::Concern
  included do
    before_validation { |t| t.prior = 0 unless Todo.state_machines[:prior].states.map { |n| n.value }.include? t.prior }
    state_machine :prior, initial: :none do
      state :none, value: 0
      state :low, value: 1
      state :medium, value: 2
      state :high, value: 3
      event :increase_prior do
        transition :none => :low, :low => :medium, :medium => :high
      end
      event :decrease_prior do
        transition :high => :medium, :medium => :low, :low => :none
      end
    end
  end
  module ClassMethods
    def get_priors_collection
      output = {}
      state_machines[:prior].states.each do |item|
        output[item.value] = item.name
      end
      output
    end
  end
end