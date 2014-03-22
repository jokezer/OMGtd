module Prior
  extend ActiveSupport::Concern
  included do
    state_machine :prior, initial: :none do
      state :none
      state :low
      state :medium
      state :high
      event :increase_prior do
        transition :none => :low, :low => :medium, :medium => :high
      end
      event :decrease_prior do
        transition :high => :medium, :medium => :low, :medium => :none
      end
    end
  end
  module ClassMethods
  end
end