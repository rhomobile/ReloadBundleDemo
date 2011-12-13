require 'rho/rhocontroller'
require 'helpers/application_helper'
require 'helpers/browser_helper'

module Rho
module RhoSupport
    def self.rhobundle_getfilename()
        File.join( __rhoGetCurrentDir(), '/RhoBundle/upgrade_bundle.zip')
    end
    
    def self.rhobundle_download(download_url, download_callback)

        file_name = rhobundle_getfilename()
        dir_name = File.dirname(file_name)
        if Dir.exists?(dir_name) && System.delete_folder(dir_name) != 0
            return false
        end
        
        Dir.mkdir(dir_name) unless Dir.exists?(dir_name)
        
        Rho::AsyncHttp.download_file(
                 :url => download_url,
                 :filename => file_name,
                 :headers => {},
                 :callback => download_callback ) if download_url
                 
        return true
                
    end
end
end

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
  
  def do_bundle_replace
    if System.unzip_file(::Rho::RhoSupport.rhobundle_getfilename())==0
        System.replace_current_bundle( File.dirname(::Rho::RhoSupport.rhobundle_getfilename()) )
        render :action => :wait_replace, :back => '/app'
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

=begin
  def copy_file(src, dst_dir)
        content = File.binread(src)  
        File.open(File.join( dst_dir, File.basename(src) ), "wb"){|f| f.write(content) }
  end

  def do_bundle_download2
    if !::Rho::RhoSupport.rhobundle_download(nil,nil)
        WebView.navigate url_for :action => :error    
        return
    end

    bundle_path = ::Rho::RhoSupport.rhobundle_getfilename()    
    
    if System.get_property('device_name') == 'Win32'
        file_name = 'C:\projects\rapps\ReloadBundleDemo\bin\target\wm6p\upgrade_bundle.zip'
    else
        file_name = '\Program Files\upgrade_bundle.zip'
    end
        
    copy_file(file_name, File.dirname(bundle_path) )

    if System.unzip_file(bundle_path) == 0
        System.replace_current_bundle( File.dirname(bundle_path) )
    else
        WebView.navigate url_for :action => :error    
    end
    
  end
=end
  
end

=begin    
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
=end
