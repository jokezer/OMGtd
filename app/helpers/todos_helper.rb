module TodosHelper

  def get_contexts
    current_user.contexts.map { |context| [context.id, context.label] }
  end

  def get_projects
    current_user.projects.with_state(:active)
    .map { |project| [project.label, project.id] }
  end

end
