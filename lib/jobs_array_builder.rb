require 'job'

class JobsArrayBuilder
  attr_reader :jobs, :jobs_hash
  private :jobs, :jobs_hash
  
  def initialize(jobs, jobs_hash)
    @jobs = jobs
    @jobs_hash = jobs_hash
  end
  
  def all_jobs
    gererated_array 
  end
  
  def roots
    gererated_array.select{ |job|  job.root? }
  end
  
  def parents_names
    parents.map(&:parent)
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
      array =[]
      jobs.each do |key|
        array << Job.new(key, jobs_hash)
      end
      array
    end
    
    def gererated_array
       @gererated_array ||=  generate_jobs_arr
    end 
end