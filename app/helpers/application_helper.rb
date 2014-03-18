module ApplicationHelper
  def tryscope
    'try scope'
  end
  def link_params
    link_params = {}
    link_params[:from_kind] = params[:label] if(params[:controller]=='todos' and params[:type]=='kind')
    link_params[:from_project] = @project.id if(params[:controller]=='projects' and action_name == 'show')
    link_params[:from_context] = @context.id if(params[:controller]=='contexts' and action_name == 'show')
    link_params
  end
end
