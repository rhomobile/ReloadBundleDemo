require 'rho/rhocontroller'
require 'helpers/browser_helper'

class FooController < Rho::RhoController
  include BrowserHelper

  # GET /Foo
  def index
    @foos = Foo.find(:all)
    render :back => '/app'
  end

  # GET /Foo/{1}
  def show
    @foo = Foo.find(@params['id'])
    if @foo
      render :action => :show, :back => url_for(:action => :index)
    else
      redirect :action => :index
    end
  end

  # GET /Foo/new
  def new
    @foo = Foo.new
    render :action => :new, :back => url_for(:action => :index)
  end

  # GET /Foo/{1}/edit
  def edit
    @foo = Foo.find(@params['id'])
    if @foo
      render :action => :edit, :back => url_for(:action => :index)
    else
      redirect :action => :index
    end
  end

  # POST /Foo/create
  def create
    @foo = Foo.create(@params['foo'])
    redirect :action => :index
  end

  # POST /Foo/{1}/update
  def update
    @foo = Foo.find(@params['id'])
    @foo.update_attributes(@params['foo']) if @foo
    redirect :action => :index
  end

  # POST /Foo/{1}/delete
  def delete
    @foo = Foo.find(@params['id'])
    @foo.destroy if @foo
    redirect :action => :index  
  end
end
