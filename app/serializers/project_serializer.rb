class ProjectSerializer < ActiveModel::Serializer
  attributes :id, :title, :todos_count

  def todos_count
    object.todos.count
  end
end
