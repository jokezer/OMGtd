module ApplicationHelper
  def tryscope
    'try scope'
  end

  def make_sidebar_menu_item(menu_item)
    content_tag :li, :class => ("active" if params[:status]==menu_item[:label]) do
      link_to '/todos/status/'+menu_item[:label], :class => 'button white' do
        content_tag(:span, menu_item[:label]) +
            content_tag(:span, menu_item[:quantity], class: "badge pull-right")
      end
    end
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
      output[group] << {status:key.to_s, label: stat, quantity: counts[key]}
    end
    output
  end
end
