module ApplicationHelper
  def tryscope
    'try scope'
  end

  def link_params
    link_params = {}
    link_params[:from_kind] = params[:type_name] if (params[:controller]=='todos' && params[:type]=='kind')
    link_params[:from_project] = @project.id if (params[:controller]=='projects' && action_name == 'show')
    link_params[:from_context] = @context.id if (params[:controller]=='contexts' && action_name == 'show')
    link_params
  end

  def prior_buttons(collection, opts={})
    opts[:model] ||= 'todo'
    render 'todos/form/prior_buttons',
           collection: collection,
           selected: opts[:selected],
           model: opts[:model],
           column: opts[:column]
  end

  def sidebar_active
    counts = current_user.todos.count_groups
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
    counts = current_user.todos.count_groups
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
    return if collection.empty?
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
    return if collection.empty?
    opts[:count] ||= 5
    opts[:group_name] ||= 'label'
    opts[:link]  ||= "/todos/filter/kind/#{opts[:group_name]}"
    render 'todos/collection',
           collection: collection[0..(opts[:count]-1)],
           todo_counts: collection.count,
           show_button: (collection.count > opts[:count]),
           group_name: opts[:group_name],
           link: opts[:link]

  end

  def make_breadcrumb
    if controller_name == 'projects'
      render 'menu/breadcrumb',
             parent: @project.label,
             parent_href: project_path(@project.name),
             active: params[:type_name]
    end
  end

  def truncate_content(content)
      simple_format content.truncate(230).lines[0..2].join
  end

end
