module Todo::TodoStates
  #filter - .with_state(:state_name)
  extend ActiveSupport::Concern
  included do
    before_create { |t| t.state = 'active' unless t.inbox? }
    before_update { |t| t.state = 'active' if !t.inbox? and t.new? }
    before_update { |t| return false if t.state=='active' and t.inbox? }
    state_machine :state, initial: :new do
      state :new
      state :active
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
        transition all - [:new, :active] => :active
      end
      event :cancel do
        transition [:new, :active] => :trash
      end
      event :complete do
        transition [:new, :active] => :completed
      end
    end
  end
  module ClassMethods
    def count_state
      output = {}
      self.select('state as label, count(todos.id) as todo_count').group('state')
      .each{|i| output[i['label']] = i['todo_count'] }
      output.symbolize_keys
    end
  end
end

module TodoTypes
  extend ActiveSupport::Concern
  included do
    state_machine :kind, initial: :inbox do
      state :inbox
      state :next
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
    def count_kind
      output = {}
      self.select('kind as label, count(todos.id) as todo_count').group('kind')
      .each{|i| output[i['label']] = i['todo_count'] }
      output.symbolize_keys
    end
  end
end