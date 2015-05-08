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

    if !::Rho::RhoSupport.rhobundle_download(@params['url'], url_for(:action => :httpdownload_callback))
        render :action =>:error    
    else
        render :action => :wait_download, :back => '/app'
    end    
    
  end


  def do_bundle_download_partial

    if !::Rho::RhoSupport.rhobundle_download(@params['url'], url_for(:action => :httpdownload_callback_partial))
        render :action =>:error    
    else
        render :action => :wait_download, :back => '/app'
    end    
    
  end
  
  def do_bundle_replace
    if System.unzip_file(::Rho::RhoSupport.rhobundle_getfilename())==0
        System.replace_current_bundle( File.dirname(::Rho::RhoSupport.rhobundle_getfilename()), {} )
        render :action => :wait_replace, :back => '/app'
    else
        WebView.navigate url_for :action => :error    
    end
  end

  def do_bundle_replace_partial
    if System.unzip_file(::Rho::RhoSupport.rhobundle_getfilename())==0
        System.replace_current_bundle( File.dirname(::Rho::RhoSupport.rhobundle_getfilename()), { :callback => url_for(:action => :partial_update_callback), :do_not_restart_app => true } )
        render :action => :wait_replace, :back => '/app'
    else
        WebView.navigate url_for :action => :error    
    end
  end

  def partial_update_callback
       if @params["status"] == "ok"
            WebView.navigate url_for :action => :done
       else
            WebView.navigate url_for :action => :error
       end
  end


  def httpdownload_callback
       if @params["status"] == "ok"
            #render_transition :action => :replace
            WebView.navigate url_for :action => :replace
       else
            WebView.navigate url_for :action => :error
       end
  end

  def httpdownload_callback_partial
       if @params["status"] == "ok"
            WebView.navigate url_for :action => :replace_partial
       else
            WebView.navigate url_for :action => :error
       end
  end

  
end
