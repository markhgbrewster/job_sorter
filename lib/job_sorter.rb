require 'job_hash'
require 'job'


class JobSorter
  attr_reader :jobs_str, :orderd_jobs_str, :new_jobs_arr
  private :jobs_str

  def initialize(jobs_str)
    @jobs_str = jobs_str
    @orderd_jobs_str = ''
    @new_jobs_arr = []
  end
  
  def sorted_jobs
    generate_new_jobs_arr
    add_root_jobs
    add_parents
    add_other_jobs
    orderd_jobs_str
  end
  
  private
    
    def jobs_hash
      @jobs_hash ||= JobHash.new(jobs_str).hash_of_jobs
    end
    
    def jobs
       jobs_hash.keys
    end
    
    def generate_new_jobs_arr 
      jobs.each do |key|
        new_jobs_arr << Job.new(key, jobs_hash)
      end
    end
    
    def add_root_jobs
      new_jobs_arr.select{ |job|  job.root? }.each do |root_job|
        add_job_to_str(root_job.name)
      end
    end
    
   def parents
     new_jobs_arr.select{ |job| job.parent != " " }.map(&:parent)
   end
    
   def add_parents
     parents.each do |parent_job|
       add_job_to_str(parent_job)
       add_children(parent_job)
     end
   end
    
    def add_other_jobs
      new_jobs_arr.each do |job|
        add_job_to_str(job.parent)
        add_job_to_str(job.name)
      end
    end
    
    def add_children(parent)
       new_jobs_arr.select{ |job| job.parent == parent }.each do |job|
         add_job_to_str(job.name)
       end
    end 
    
    def add_job_to_str(job)
      orderd_jobs_str << job unless job_already_added?(job)
    end 
    
    def job_already_added?(job)
      orderd_jobs_str.include?(job)
    end
 
end