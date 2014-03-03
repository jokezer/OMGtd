class Todo < ActiveRecord::Base

  # default_scope { order('updated_at DESC') } #todo dont work in postgresql

  scope :by_status, ->(label) { where(:status_id => TodoStatus.invert[label.to_sym]) }
  scope :today, ->(label) { where(:status_id => TodoStatus.invert[label.to_sym]) }

  belongs_to :user
  validates :user, presence: true
  validates :title, presence: true
  validates :status_id, presence: true, :inclusion => {:in => TodoStatus::STATUSES.keys}

  self.per_page = 5

  def status
    TodoStatus::STATUSES[self.status_id]
  end

  def prior
    TodoPrior::PRIORS[self.prior_id]
  end
end
