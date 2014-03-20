module TodosHelper
  def get_kinds
    kinds = Todo.state_machines[:kind].states.map{|n| n.name}
    kinds.delete(:inbox) unless @todo.state == 'new'
    kinds
  end
end
