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
      class_name = to_s.downcase
      table = class_name.pluralize
      self.select("#{table}.id, name, name as label, count(todos.id) as counts, count(todos.id) as length") #todo remove count(todos.id) as counts
      .joins("left outer join todos on todos.#{class_name}_id = #{table}.id and todos.state='active'")
      .group("#{table}.id")
      .to_a.map { |a| a.serializable_hash.symbolize_keys }
    end

    def by_name(name)
      where('lower(name) = ?', name.downcase).take
    end

    def by_label(label)
      where('lower(name) = ?', label[1..-1].downcase).take
    end
  end
end