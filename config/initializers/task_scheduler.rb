require 'rubygems'
require 'rufus/scheduler'

$scheduler = Rufus::Scheduler.start_new

# Schedule all defined jobs on startup
jobs = Job.all
jobctl = JobsController.new

jobs.each do |job|
  jobctl.schedule(job)
end
