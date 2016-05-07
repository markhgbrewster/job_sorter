require 'job'

class JobsArrayBuilder
  attr_reader :jobs_hash
  private :jobs_hash
  
  def initialize(jobs_hash)
    @jobs_hash = jobs_hash
  end
  
  def all_jobs
    @all_jobs ||= jobs_hash.keys.map { |key| Job.new(key, jobs_hash) } 
  end
  
  def roots
    all_jobs.select{ |job|  job.root? }
  end
  
  def not_roots
    all_jobs.select{ |job| job.parent != "" }
  end
  
  def children(parent)
    all_jobs.select{ |job| job.parent == parent }
  end
  
  def dependent_on_selves
    all_jobs.select{|job| job.name == job.parent}
  end
end