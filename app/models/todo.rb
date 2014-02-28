class Todo < ActiveRecord::Base

  default_scope { order('updated_at DESC') }

  scope :by_status, ->(label) { where(:status => TodoStatus.invert_statuses[label.to_sym])}

  belongs_to :user
  validates :user, presence: true
  validates :title, presence: true
  validates :status, presence: true, :inclusion => {:in => TodoStatus::STATUSES.keys}

  self.per_page = 4

  def status_label
    TodoStatus::STATUSES[self.status]
  end
end
