# app/controllers/application_controller.rb
class ApplicationController < ActionController::Base
  before_action :set_view_path

  private

  def set_view_path
    case request.host
    when "mysite.com"
      site = "my_site" # root view path will be app/views/my_site
    when "myothersite.com"
      site = "my_other_site" # root view path will be app/views/my_other_site
    else
      site = "default_site" # root view path will be app/views/default_site
    end
    prepend_view_path "#{Rails.root}/app/views/#{site}"
  end
end
