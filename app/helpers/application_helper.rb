module ApplicationHelper
  def tryscope
    'try scope'
  end

  def count_by_status
    counts = current_user.todos.group(:status_id).count
    output = {}
    output[:active] = []
    output[:hidden] = []
    TodoStatus::COLLECTION.each do |key, stat|
      group = (TodoStatus::GROUP[:hidden].include? key) ? :hidden : :active
      stat = stat.to_s
      counts[key] = 0 unless counts[key]
      output[group] << {status: key.to_s, label: stat, quantity: counts[key]}
    end
    output
  end
end
