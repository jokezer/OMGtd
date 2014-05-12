class Todo < ActiveRecord::Base

  include TodoStates
  include TodoTypes
  include Prior
  include TodoDues

  #change ordering to default scope in rails 4.1
  scope :ordering, -> { order('prior DESC').order('due') }
  # .order('updated_at DESC') }

  belongs_to :user
  belongs_to :context
  belongs_to :project

  validates :user, presence: true
  validates :title, presence: true
  validates :title, length: {maximum: 255}
  validate :user_project
  validate :user_context

  # self.per_page = 10

  #todo decouple filter and count_groups methods
  def self.filter(type, label)
    type.to_s
    label.to_s
    begin
      output = case type
                 when 'state'
                   with_state(label)
                 when 'kind'
                   active.with_kind(label)
                 when 'calendar'
                   if label == 'today'
                     active.today
                   elsif label == 'tomorrow'
                     active.tomorrow
                   end
                 else
                   false
               end
    rescue IndexError
      #incorrect state
    end
    output.ordering if output
  end

  def self.count_groups
    {
        state: count_state,
        kind: active.count_kind,
        calendar: {
            today: active.today.count,
            tomorrow: active.tomorrow.count
        }
    }
  end

  def move(group, value, set_due=nil)
    self.due = DateTime.parse(set_due) if set_due.present?
    activate
    case group
      when 'kind'
        self.kind = value
      when 'state'
        self.state = value
      when 'calendar'
        self.due = DateTime.now if value == 'today'
        self.due = DateTime.now.tomorrow if value == 'tomorrow'
        self.kind = 'scheduled' if inbox? && due
      when 'context'
        context = user.contexts.by_name(value)
        self.context_id = context.id if context
      when 'project'
        project = user.projects.by_name(value)
        self.project_id = project.id if project
      else
        return false
    end
    save
  end

  def self.get_index
    todos = {}
    todos[:today] = with_state(:active).today
    todos[:tomorrow] = with_state(:active).tomorrow
    todos[:next] = with_state(:active).with_kind(:next).later_or_no_deadline
    todos
  end

  private

  def user_project
    if project.present?
      errors.add(:project, 'Incorrect project') unless user.id == project.user_id
    end
  end

  def user_context
    if context.present?
      errors.add(:project, 'Incorrect context') unless user.id == context.user_id
    end
  end
end
