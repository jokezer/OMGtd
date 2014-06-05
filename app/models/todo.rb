class Todo < ActiveRecord::Base

  include TodoStates
  include TodoTypes
  include Prior
  include TodoDues

  scope :ordering, -> { order('prior DESC').order('due') }

  belongs_to :user
  belongs_to :context
  belongs_to :project

  validates :user, presence: true
  validates :title, presence: true
  validates :title, length: {maximum: 255}
  validate :user_project
  validate :user_context

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
