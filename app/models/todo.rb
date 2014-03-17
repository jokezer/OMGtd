class Todo < ActiveRecord::Base

  #default_scope { order('updated_at DESC') } #_todo dont work in postgresql

  attr_accessor :is_deadline
  include TodoStates
  include TodoTypes
  before_validation {self.expire = nil if self.is_deadline=='0'}

  scope :today, -> {
    where('expire < ?', DateTime.now.end_of_day)
    .where('state = ?', 'active')
    .order('updated_at DESC')
  }
  scope :tomorrow, -> {
    where('expire BETWEEN ? AND ?', DateTime.now.tomorrow.beginning_of_day,
          DateTime.now.tomorrow.end_of_day)
    .where('state = ?', 'active')
    .order('updated_at DESC')
  }
  scope :later_or_no_deadline, -> { where("expire > ? or expire is NULL",
                                          DateTime.now.tomorrow.end_of_day) }

  belongs_to :user
  belongs_to :context
  belongs_to :project

  validates :user, presence: true
  validates :title, presence: true

  self.per_page = 5

  def prior
    TodoPrior::COLLECTION[self.prior_id]
  end

end
