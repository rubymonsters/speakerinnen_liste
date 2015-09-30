module LayoutsHelper
  def admin?(current_profile)
    current_profile && current_profile.admin?
  end
end
