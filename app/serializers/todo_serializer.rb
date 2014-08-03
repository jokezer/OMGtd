class TodoSerializer < ActiveModel::Serializer
  attributes :id, :title, :content, :state, :kind, :prior, :context_id,
             :project_id, :user_id, :calendar, :due_seconds,
             :updated_seconds, :can_increase_prior?, :can_decrease_prior?,
             :errors, :project_label, :context_label
  def project_label
    object.project.label if object.project
  end
  def context_label
    object.context.label if object.context
  end
end
