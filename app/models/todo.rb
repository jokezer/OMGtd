class Todo < ActiveRecord::Base
  #TODO FIX ORDERS

  attr_accessor :is_deadline
  include TodoStates
  include TodoTypes
  include Prior
  before_validation { self.due = nil if is_deadline=='0' }

  scope :today, -> {
    where('due < ?', DateTime.now.end_of_day)
    .order('updated_at DESC')
  }
  scope :tomorrow, -> {
    where('due BETWEEN ? AND ?', DateTime.now.tomorrow.beginning_of_day,
          DateTime.now.tomorrow.end_of_day)
    .order('updated_at DESC')
  }
  scope :later_or_no_deadline, -> { where("due > ? or due is NULL",
                                          DateTime.now.tomorrow.end_of_day) }

  belongs_to :user
  belongs_to :context
  belongs_to :project

  validates :user, presence: true
  validates :title, presence: true
  validate :user_project
  validate :user_context

  self.per_page = 5

  def self.filter(type, label)
    type.to_s
    label.to_s
    begin
      output =
          if type == 'state'
            with_state(label)
          elsif type == 'kind'
            with_state(:active).with_kind(label)
          elsif type == 'calendar'
            if label == 'today'
              with_state(:active).today
            elsif label == 'tomorrow'
              with_state(:active).tomorrow
            end
          else
            false
          end
    rescue
      #incorrect state
    end
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
