require 'rho/rhocontroller'
require 'helpers/browser_helper'

class FooNewController < Rho::RhoController
  include BrowserHelper

  # GET /FooNew
  def index
    @foonews = FooNew.find(:all)
    render :back => '/app'
  end

  # GET /FooNew/{1}
  def show
    @foonew = FooNew.find(@params['id'])
    if @foonew
      render :action => :show, :back => url_for(:action => :index)
    else
      redirect :action => :index
    end
  end

  # GET /FooNew/new
  def new
    @foonew = FooNew.new
    render :action => :new, :back => url_for(:action => :index)
  end

  # GET /FooNew/{1}/edit
  def edit
    @foonew = FooNew.find(@params['id'])
    if @foonew
      render :action => :edit, :back => url_for(:action => :index)
    else
      redirect :action => :index
    end
  end

  # POST /FooNew/create
  def create
    @foonew = FooNew.create(@params['foonew'])
    redirect :action => :index
  end

  # POST /FooNew/{1}/update
  def update
    @foonew = FooNew.find(@params['id'])
    @foonew.update_attributes(@params['foonew']) if @foonew
    redirect :action => :index
  end

  # POST /FooNew/{1}/delete
  def delete
    @foonew = FooNew.find(@params['id'])
    @foonew.destroy if @foonew
    redirect :action => :index  
  end
end
