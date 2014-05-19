class TodoSerializer < ActiveModel::Serializer
  attributes :id, :title, :content, :state, :kind, :prior, :context_id,
             :project_id, :user_id, :due, :schedule_label, :due_seconds,
             :updated_seconds, :can_increase_prior?, :can_decrease_prior?,
             :errors, :context
  def context
    object.context.name if object.context_id
  end
end
