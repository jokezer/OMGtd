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
    counts = current_user.todos.group(:status).count
    output = {}
    output[:active] = []
    output[:hidden] = []
    Todo::ALLOWED_STATUSES.each do |stat|
      group = (Todo::HIDDEN_STATUSES.include? stat) ? :hidden : :active
      stat = stat.to_s
      counts[stat] = 0 unless counts[stat]
      output[group] << {label: stat, quantity: counts[stat]}
    end
    output
  end
end
