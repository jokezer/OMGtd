module Todo::TodoStates
  #filter - .with_state(:state_name)
  extend ActiveSupport::Concern
  included do
    before_create { |t| t.state = 'active' unless t.inbox? }
    before_update { |t| t.state = 'active' if !t.inbox? and t.new? }
    before_update { |t| return false if t.state!='new' and t.inbox? }
    state_machine :state, initial: :new do
      state :new
      state :active
      state :completed
      state :trash
      state :trash, :completed do
        def can_delete?
          true
        end
      end
      state all - [:trash, :completed] do
        def can_delete?
          false
        end
      end
      event :activate do
        transition all => :active
      end
      event :cancel do
        transition all => :trash
      end
      event :complete do
        transition all => :completed
      end
    end
  end
  module ClassMethods
    def group_state
      self.select('state as label, count(todos.id) as todo_count').group('state')
      .to_a.map { |a| a.serializable_hash.symbolize_keys }
    end
  end
end

module TodoTypes
  extend ActiveSupport::Concern
  included do
    state_machine :kind, initial: :inbox do
      state :inbox
      state :next
      state :scheduled
      state :cycled
      state :someday
      state :waiting
      state :scheduled, :cycled do
        validates_presence_of :expire
        validates :is_deadline, acceptance: {accept: '1',
                                             message:'Deadline is required!'}
      end
    end
  end
  module ClassMethods
    def group_kind
      self.select("kind as label, count(todos.id) as todo_count").group("kind")
      .to_a.map { |a| a.serializable_hash.symbolize_keys }
    end
  end
end