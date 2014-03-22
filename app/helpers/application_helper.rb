module ApplicationHelper
  def tryscope
    'try scope'
  end

  def link_params
    link_params = {}
    link_params[:from_kind] = params[:label] if (params[:controller]=='todos' && params[:type]=='kind')
    link_params[:from_project] = @project.id if (params[:controller]=='projects' && action_name == 'show')
    link_params[:from_context] = @context.id if (params[:controller]=='contexts' && action_name == 'show')
    link_params
  end


  def get_priors
    #TodoPrior::COLLECTION.invert
    Todo.state_machines[:prior].states.map { |n| n.name }
  end

  def sidebar_count_todos
    counts = {calendar:{}}
    counts[:state] = current_user.todos.count_state
    counts[:kind] = current_user.todos.with_state(:active).count_kind
    counts[:calendar][:today] = current_user.todos.with_state(:active).today.count
    counts[:calendar][:tomorrow] = current_user.todos.with_state(:active).tomorrow.count
    counts
  end

  def sidebar_contexts
    current_user.contexts.make_group
  end

  def sidebar_projects
    current_user.projects.with_state('active').make_group
  end
end
