require 'rho/rhocontroller'
require 'helpers/application_helper'
require 'helpers/browser_helper'

class RemovedPageController < Rho::RhoController
  include BrowserHelper
  include ApplicationHelper
  
  def index
    render :back => '/app'
  end

end
