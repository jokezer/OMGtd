module TodosHelper
  def get_kinds
    kinds = Todo.state_machines[:kind].states.map{|n| n.name}
    kinds.delete(:inbox) if action_name == 'show'
    kinds
  end
end
