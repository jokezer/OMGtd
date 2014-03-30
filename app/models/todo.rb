class Todo < ActiveRecord::Base
  #TODO FIX ORDERs
  include TodoStates
  include TodoTypes
  include Prior

  scope :today, -> {
    ordering.where('due < ?', DateTime.now.end_of_day)
  }
  scope :tomorrow, -> {
    ordering.where('due BETWEEN ? AND ?', DateTime.now.tomorrow.beginning_of_day,
                   DateTime.now.tomorrow.end_of_day)
  }
  scope :later_or_no_deadline, -> { ordering.where("due > ? or due is NULL",
                                                   DateTime.now.tomorrow.end_of_day) }
  #change ordering to default scope in rails 4.1
  scope :ordering, -> { order('prior DESC').order('due').order('updated_at DESC') }

  belongs_to :user
  belongs_to :context
  belongs_to :project

  validates :user, presence: true
  validates :title, presence: true
  validates :title, length: {maximum: 255}
  validate :user_project
  validate :user_context

  self.per_page = 10
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

  def today?
    return false unless due
    due < DateTime.now.end_of_day
  end

  def tomorrow?
    return false unless due
    due > DateTime.now.tomorrow.beginning_of_day && due < DateTime.now.tomorrow.end_of_day
  end

  def get_schedule_label
    return 'no' if due.blank?
    return 'today' if today?
    'tomorrow' if tomorrow?
  end

  def self.get_index
    todos = {}
    todos[:today] = with_state(:active).today
    todos[:tomorrow] = with_state(:active).tomorrow
    todos[:next] = with_state(:active).with_kind(:next).later_or_no_deadline
    todos
  end

  def self.create_defaults
    create(title: 'Welcome to One More GTD',
           content: "This is GTD style task manager\n"+
               "Click to \"Create new\" to create new task.",
           kind: 'next',
           prior: 3)
    create(title: 'Drag and Drop',
           content: "Drag and drop todos with mouse to manage them",
           kind: 'next',
           prior: 2)
    create(title: 'Edit todos',
           content: "Click on todo header to edit todo content.\n Also you can create project from todo",
           kind: 'next',
           prior: 2)
    create(title: 'Edit todos',
           content: "Use arrow buttons on the right to change todo prior",
           kind: 'next',
           prior: 2)
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
