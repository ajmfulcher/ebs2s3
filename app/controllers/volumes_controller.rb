class VolumesController < ApplicationController
  before_filter :require_user
  def index
    aws_key = APP_CONFIG["aws_key"]
    secret = APP_CONFIG["aws_secret"]
    region = APP_CONFIG["aws_region"]
    
    @jobvols = Job.all.map{|a| a[:ebsvol]}
    
    begin
      conn = Fog::Compute.new(:provider => 'AWS', :aws_access_key_id => aws_key, :aws_secret_access_key => secret, :region => region)
      @volumes = conn.volumes.all
    rescue
      @volumes = []
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @jobs }
    end
  end

  def show
  end

  def new
  end

  def edit
  end

  def create
  end

  def update
  end

  def destroy
  end
  
end
