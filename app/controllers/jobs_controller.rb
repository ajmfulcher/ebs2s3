class JobsController < ApplicationController
  before_filter :require_user
  # GET /jobs
  # GET /jobs.xml
  def index
    @jobs = Job.all
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @jobs }
    end
  end

  # GET /jobs/1
  # GET /jobs/1.xml
  def show
    @job = Job.find(params[:id])
    
    aws_key = APP_CONFIG["aws_key"]
    secret = APP_CONFIG["aws_secret"]
    region = APP_CONFIG["aws_region"]
    
    begin
      conn = Fog::Compute.new(:provider => 'AWS', :aws_access_key_id => aws_key, :aws_secret_access_key => secret, :region => region)
      @snapshots = conn.snapshots.all('volume-id' => @job[:ebsvol])
    rescue
      @snapshots = []
    end

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @job }
    end
  end

  # GET /jobs/new
  # GET /jobs/new.xml
  def new
    @job = Job.new(:ebsvol => params[:ebsvol])

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @job }
    end
  end

  # GET /jobs/1/edit
  def edit
    @job = Job.find(params[:id])
  end

  # POST /jobs
  # POST /jobs.xml
  def create
    @job = Job.new(params[:job])

    respond_to do |format|
      if @job.save
        self.schedule(@job)
        format.html { redirect_to(@job, :notice => 'Job was successfully created.') }
        format.xml  { render :xml => @job, :status => :created, :location => @job }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @job.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /jobs/1
  # PUT /jobs/1.xml
  def update
    @job = Job.find(params[:id])

    respond_to do |format|
      if @job.update_attributes(params[:job])
        self.schedule(@job)
        format.html { redirect_to(@job, :notice => 'Job scheduled successfully.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @job.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /jobs/1
  # DELETE /jobs/1.xml
  def destroy
    @job = Job.find(params[:id])
    
    # Unschedule tasks if attached
    tasks = $scheduler.find_by_tag(params[:id]).each{|t| t.unschedule }
    @job.destroy

    respond_to do |format|
      format.html { redirect_to(jobs_url) }
      format.xml  { head :ok }
    end
  end
  
  def schedule(job)
    
    # Unschedule task if it already exists
    tasks = $scheduler.find_by_tag(job.id).each{|t| t.unschedule }
    
    # And re-schedule
    $scheduler.cron job.cronline, :tags => job.id do
      self.delete_old_snapshots(job.ebsvol,job.id,job.copies)
      self.backup(job.ebsvol,job.id)
    end
    
  end
  
  def delete_old_snapshots(ebsvol,tag,copies)
    
    aws_key = APP_CONFIG["aws_key"]
    secret = APP_CONFIG["aws_secret"]
    region = APP_CONFIG["aws_region"]
    
    conn = Fog::Compute.new(:provider => 'AWS', :aws_access_key_id => aws_key, :aws_secret_access_key => secret, :region => region)
    snapshots = conn.snapshots.map{|a| a if (a.volume_id == ebsvol && a.description == "Job id: #{tag}")}.compact
    
    unless snapshots.empty?
      sorted_snaps = snapshots.sort_by{|a| a.created_at}
      while sorted_snaps.count > copies
        snap_to_del = sorted_snaps.shift
        puts "Deleting snapshot #{snap_to_del.id}"
        snap_to_del.destroy
      end
    end
    
  end
  
  def backup(ebsvol,tag)
    
    aws_key = APP_CONFIG["aws_key"]
    secret = APP_CONFIG["aws_secret"]
    region = APP_CONFIG["aws_region"]
    
    puts "Creating snapshot of volume #{ebsvol} with id #{tag}"
    conn = Fog::Compute.new(:provider => 'AWS', :aws_access_key_id => aws_key, :aws_secret_access_key => secret, :region => region)
    conn.create_snapshot(ebsvol,"Job id: #{tag}")
    
  end
  
end
