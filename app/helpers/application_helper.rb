module ApplicationHelper
  def tryscope
    'try scope'
  end

  def link_params
    link_params = {}
    link_params[:from_kind] = params[:name] if (params[:controller]=='todos' && params[:type]=='kind')
    link_params[:from_project] = @project.id if (params[:controller]=='projects' && action_name == 'show')
    link_params[:from_context] = @context.id if (params[:controller]=='contexts' && action_name == 'show')
    link_params
  end

  def get_priors
    #TodoPrior::COLLECTION.invert
    Todo.state_machines[:prior].states.map { |n| n.name }
  end

  def sidebar_count_todos
    counts = {calendar: {}}
    counts[:state] = current_user.todos.count_state
    counts[:kind] = current_user.todos.with_state(:active).count_kind
    counts[:calendar][:today] = current_user.todos.with_state(:active).today.count
    counts[:calendar][:tomorrow] = current_user.todos.with_state(:active).tomorrow.count
    counts
  end

  def sidebar_active
    counts = sidebar_count_todos
    [
        {name: 'inbox', link: '/state/inbox', counts: counts[:state][:inbox], group: 'state', disabled: true},
        {name: 'today', link: '/calendar/today', counts: counts[:calendar][:today], group: 'calendar'},
        {name: 'next', link: '/kind/next', counts: counts[:kind][:next], group: 'kind'},
        {name: 'tomorrow', link: '/calendar/tomorrow', counts: counts[:calendar][:tomorrow], group: 'calendar'},
        {name: 'scheduled', link: '/kind/scheduled', counts: counts[:kind][:scheduled], group: 'kind'},
        {name: 'cycled', link: '/kind/cycled', counts: counts[:kind][:cycled], group: 'kind'},
        {name: 'waiting', link: '/kind/waiting', counts: counts[:kind][:waiting], group: 'kind'},
        {name: 'someday', link: '/kind/someday', counts: counts[:kind][:someday], group: 'kind'}
    ]
  end

  def sidebar_hidden
    counts = sidebar_count_todos
    [
        {name: 'trash', link: '/state/trash', counts: counts[:state][:trash], group: 'state'},
        {name: 'completed', link: '/state/completed', counts: counts[:state][:completed], group: 'state'}
    ]
  end

  def sidebar_contexts
    current_user.contexts.make_group.each { |i| i[:group]='context' }
  end

  def sidebar_projects
    current_user.projects.with_state('active').make_group.each { |i| i[:group]='project' }
  end

  def make_badge(collection, opts={})
    return false if collection.empty?
    opts[:name] ||= lambda { |item| item[:name] }
    opts[:label] ||= lambda { |item| item[:label] }
    opts[:counts] ||= lambda { |item| item[:counts] }
    opts[:link] ||= lambda { |item| item[:link] }
    opts[:group] ||= lambda { |item| item[:group] }
    opts[:group_label] ||= ''
    opts[:show_group_name] ||= true #refactor it
    render 'menu/badge',
           collection: collection,
           group_name: opts[:group_name],
           name: opts[:name],
           label: opts[:label],
           counts: opts[:counts],
           link: opts[:link],
           group_label: opts[:group_label],
           show_group_label: opts[:show_group_name]
  end

  #collections
  def render_collection(collection, opts={})
    return false if collection.empty?
    opts[:count] ||= 5
    opts[:group_name] ||= 'label'
    opts[:link]  ||= "/todos/filter/kind/#{opts[:label]}"
    render 'todos/collection',
           collection: collection[0..(opts[:count]-1)],
           show_button: (collection.count > opts[:count]),
           group_name: opts[:group_name],
           link: opts[:link]

  end
end
