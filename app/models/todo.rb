class Todo < ActiveRecord::Base

  attr_accessor :is_deadline
  include TodoStates
  include TodoTypes
  before_validation { self.expire = nil if self.is_deadline=='0' }

  scope :today, -> {
    where('expire < ?', DateTime.now.end_of_day)
    .order('updated_at DESC')
  }
  scope :tomorrow, -> {
    where('expire BETWEEN ? AND ?', DateTime.now.tomorrow.beginning_of_day,
          DateTime.now.tomorrow.end_of_day)
    .order('updated_at DESC')
  }
  scope :later_or_no_deadline, -> { where("expire > ? or expire is NULL",
                                          DateTime.now.tomorrow.end_of_day) }

  belongs_to :user
  belongs_to :context
  belongs_to :project

  validates :user, presence: true
  validates :title, presence: true
  validate :user_project
  validate :user_context

  self.per_page = 5

  def prior
    TodoPrior::COLLECTION[self.prior_id]
  end

  def self.filter(type, label)
    type.to_s
    label.to_s
    begin
      output =
          if type == 'state'
            self.with_state(label)
          elsif type == 'kind'
            self.with_state(:active).with_kind(label)
          elsif type == 'calendar'
            self.with_state(:active).today if label == 'today'
            self.with_state(:active).tomorrow if label == 'tomorrow'
          else
            false
          end
    rescue
      #incorrect state
    end
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
