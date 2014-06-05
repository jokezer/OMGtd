module TodoDues
  extend ActiveSupport::Concern
  included do
    scope :today, -> {
      ordering.where('due < ?', DateTime.now.end_of_day)
    }
    scope :tomorrow, -> {
      ordering.where('due BETWEEN ? AND ?', DateTime.now.tomorrow.beginning_of_day,
                     DateTime.now.tomorrow.end_of_day)
    }
    scope :weekly, -> {
      ordering.where('due BETWEEN ? AND ?', DateTime.now.tomorrow.end_of_day,
                     DateTime.now + 7.days) }
    scope :later_or_no_deadline, -> { ordering.where("due > ? or due is NULL",
                                                     DateTime.now.tomorrow.end_of_day) }
  end
  module ClassMethods
  end

  def today?
    return false unless due
    due < DateTime.now.end_of_day
  end

  def tomorrow?
    return false unless due
    due > DateTime.now.tomorrow.beginning_of_day && due < DateTime.now.tomorrow.end_of_day
  end
  def weekly?
    return false unless due
    due > DateTime.now.tomorrow.end_of_day && due < DateTime.now + 7.days
  end

  # for js mb delete after bb integration
  def calendar
    return 'no' if due.blank?
    return 'today' if today?
    return 'tomorrow' if tomorrow?
    'weekly' if weekly?
  end

  def due_seconds
    due.to_i
  end
  def updated_seconds
    updated_at.to_i
  end
end