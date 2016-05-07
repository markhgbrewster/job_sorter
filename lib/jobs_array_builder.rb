require 'job'

class JobsArrayBuilder
  attr_reader :jobs_hash
  private :jobs_hash
  
  def initialize(jobs_hash)
    @jobs_hash = jobs_hash
  end
  
  def all_jobs
    gererated_array 
  end
  
  def roots
    gererated_array.select{ |job|  job.root? }
  end
  
  def parents
    gererated_array.select{ |job| job.parent != "" }
  end
  
  def children(parent)
    gererated_array.select{ |job| job.parent == parent }
  end
  
  def dependent_on_selves
    gererated_array.select{|job| job.name == job.parent}
  end
  
  private
    
    def generate_jobs_arr 
      jobs_hash.keys.map { |key| Job.new(key, jobs_hash) }
    end
    
    def gererated_array
       @gererated_array ||=  generate_jobs_arr
    end 
end