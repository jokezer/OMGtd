module TodoStates
  extend ActiveSupport::Concern
  included do
    before_create { |t| t.state = 'active' if t.kind.present? }
    before_update { |t| t.state = 'active' if t.kind.present? and t.inbox? }
    before_update { |t| false if t.state=='active' && t.kind.blank? }
    state_machine :state, initial: :inbox do
      state :inbox
      state :active #validates presence of kind
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
        transition all - [:inbox, :active] => :active
      end
      event :cancel do
        transition [:inbox, :active] => :trash
      end
      event :complete do
        transition [:inbox, :active] => :completed
      end
    end
  end
  module ClassMethods
    def count_state
      output = {}
      select('state as label, count(todos.id) as todo_count').group('state')
      .each{|i| output[i['label']] = i['todo_count'] }
      output.symbolize_keys
    end
  end
end

module TodoTypes
  extend ActiveSupport::Concern
  included do
    state_machine :kind do
      state :next
      state :someday
      state :waiting
      state :scheduled, :cycled do
        validates_presence_of :due
        validates :is_deadline, acceptance: {accept: '1',
                                             message:'Deadline is required!'}
      end
    end
  end
  module ClassMethods
    def count_kind
      output = {}
      select('kind as label, count(todos.id) as todo_count').group('kind')
      .each{|i| output[i['label']] = i['todo_count'] }
      output.symbolize_keys
    end
  end
  #where nil changed to "inbox":
  def get_kinds
    kinds = Todo.state_machines[:kind].states.map { |n| n.name }
    .inject({}) do |hsh, sym|
      if sym
        hsh[sym]=sym
      else
        hsh[:inbox] = '' if inbox?
      end
      hsh
    end
  end
  def kind_label
    kind.blank? ? 'inbox' : kind
  end
end