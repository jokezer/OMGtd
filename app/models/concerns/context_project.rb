module ContextProject
  extend ActiveSupport::Concern
  included do
    belongs_to :user
  end

  def label
    "#{prefix}#{name}"
  end

  module ClassMethods
    def make_group
      class_name = self.to_s.downcase
      table = class_name.pluralize
      self.select("name, name as label, count(todos.id) as todo_count")
      .joins("left outer join todos on todos.#{class_name}_id = #{table}.id")
      .group("#{table}.id")
      .to_a.map { |a| a.serializable_hash.symbolize_keys }
    end

    def by_name(name)
      self.where('lower(name) = ?', name.downcase).take
    end

    def by_label(label)
      self.where('lower(name) = ?', label[1..-1].downcase).take
    end
  end
end