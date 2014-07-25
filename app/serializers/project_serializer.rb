class ProjectSerializer < ActiveModel::Serializer
  attributes :id, :label, :title, :content, :state, :errors
end
