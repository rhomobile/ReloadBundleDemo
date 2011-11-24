require 'rho/rhocontroller'
require 'helpers/application_helper'
require 'helpers/browser_helper'

class BundleController < Rho::RhoController
  include BrowserHelper
  include ApplicationHelper
  
  def index
    render :back => '/app'
  end

  def do_bundle_download

    full_path = File.join(Rho::RhoApplication::get_base_app_path(), '/public/Bundle/Bundle.zip')

    bundle_zip_url = @params['url']

    file_name = File.join(Rho::RhoApplication::get_base_app_path, "bundle.zip")

    if File.exists?(file_name)
         File.delete(file_name) 
    end

    Rho::AsyncHttp.download_file(
             :url => bundle_zip_url,
             :filename => file_name,
             :headers => {},
             :callback => url_for(:action => :httpdownload_callback)  )

    render :action => :wait_download, :back => '/app'
  end


  def do_bundle_replace
    file_name = File.join(Rho::RhoApplication::get_base_app_path, "bundle.zip")
    System.replace_current_bundle_by_zip(file_name, '')

    render :action => :wait_replace, :back => '/app'
  end


  def httpdownload_callback

       if @params["status"] == "ok"
            render_transition :action => :replace
       else
            WebView.navigate url_for :action => :error
       end
  end
  
end
