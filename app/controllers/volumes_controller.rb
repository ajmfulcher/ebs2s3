#
# Copyright 2011, Andrew Fulcher
#
# This file is part of Ebs2s3.
#
# Ebs2s3 is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# 
# Ebs2s3 is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Ebs2s3.  If not, see <http://www.gnu.org/licenses/>.
#

class VolumesController < ApplicationController
  
  before_filter :require_user
  
  def index
    aws_key = APP_CONFIG["aws_key"]
    secret = APP_CONFIG["aws_secret"]
    region = APP_CONFIG["aws_region"]
    
    @jobvols = Job.all.map{|a| a[:ebsvol]}

    # FIXME: this needs to handle any error correctly. rather than obligingly
    # swallowing it.
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
