class ContextSerializer < ActiveModel::Serializer
  attributes :id, :label, :todos_count, :errors
  def todos_count
    object.todos.with_state(:active).count
  end
end
