module LayoutsHelper
  def admin?(current_profile)
    if current_profile && current_profile.admin
      true
    end
  end
end