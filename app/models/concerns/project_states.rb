module ProjectStates
  extend ActiveSupport::Concern

  included do
    after_initialize :set_defaults #because state_machine gem does not set defaults in Rails 4.2

    state_machine :state, initial: :active do
      after_transition :on => :activate, :do => :todos_activate
      after_transition :on => :cancel, :do => :todos_cancel
      after_transition :on => :finish, :do => :todos_complete

      state :active do
        def can_delete?
          false
        end
      end

      state :trash, :finished do
        def can_delete?
          true
        end
      end

      event :activate do
        transition [:trash, :finished] => :active
      end

      event :cancel do
        transition :active => :trash
      end

      event :finish do
        transition :active => :finished
      end
    end

    def set_defaults
      self.state ||= :active
    end
  end

  def todos_activate
    todos.each{|t|t.activate}
  end

  def todos_cancel
    todos.each{|t|t.cancel}
  end

  def todos_complete
    todos.each{|t|t.complete}
  end

  module ClassMethods
  end
end