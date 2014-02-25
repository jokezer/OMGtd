class Todo < ActiveRecord::Base
  belongs_to :user
  validates :user, presence: true
  validates :title, presence: true

  ALLOWED_STATUSES = [:inbox, :next, :scheduled, :someday, :waiting, :completed, :trash]
  ACTIVE_STATUSES = [:inbox, :next, :scheduled, :someday, :waiting]
  HIDDEN_STATUSES = [:completed, :trash]

  self.per_page = 4

  def count_by_type
    user.todos.group(:status).count
  end

  def get_main_page
  end
end
