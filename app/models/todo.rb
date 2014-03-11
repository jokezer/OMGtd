class Todo < ActiveRecord::Base

  #default_scope { order('updated_at DESC') } #todo dont work in postgresql
  #validates_presence_of :state, :granted_at, :if => Proc.new { |o| o.type != 1 } #todo deadline obligatory if scheduled
  attr_accessor :is_deadline

  before_save {self.expire = nil if self.is_deadline=='0'}

  scope :by_status, ->(label) { where(:status_id => TodoStatus.invert[label.to_sym]) }
  scope :today, -> {
    where('expire < ?', DateTime.now.end_of_day)
    .where(:status_id => TodoStatus::GROUP[:active])
    .order('updated_at DESC')
  }
  scope :tomorrow, -> {
    where('expire BETWEEN ? AND ?', DateTime.now.tomorrow.beginning_of_day,
          DateTime.now.tomorrow.end_of_day)
    .where(:status_id => TodoStatus::GROUP[:active])
    .order('updated_at DESC')
  }
  scope :later_or_no_deadline, -> { where("expire > ? or expire is NULL",
                                          DateTime.now.end_of_day) }

  belongs_to :user
  belongs_to :context

  validates :user, presence: true
  validates :title, presence: true
  validates :status_id, presence: true,
            :inclusion => {:in => TodoStatus::COLLECTION.keys}
  self.per_page = 5

  def status
    TodoStatus::COLLECTION[self.status_id]
  end

  def prior
    TodoPrior::COLLECTION[self.prior_id]
  end

end
