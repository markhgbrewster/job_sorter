require 'job_hash'
require 'job'
require 'jobs_array_builder'

class JobSorter
  attr_reader :jobs_str, :orderd_jobs_str
  private :jobs_str

  def initialize(jobs_str)
    @jobs_str = jobs_str
    @orderd_jobs_str = ''
  end
  
  def sorted_jobs
    check_self_dependent
    validate_circular_dependencies
    add_root_jobs
    add_parents
    add_other_jobs
    orderd_jobs_str
  end
  
  private
    
    def jobs_hash
      @jobs_hash ||= JobHash.new(jobs_str).hash_of_jobs
    end
  
    def array_builder
      @array_builder ||= JobsArrayBuilder.new(jobs, jobs_hash)
    end
  
    def jobs
      @jobs ||= jobs_hash.keys
    end
  
    def add_root_jobs
      array_builder.roots.each do |root_job|
        add_job_to_str(root_job.name)
        add_children(root_job.name)
      end
    end
    
   def add_parents
     array_builder.parents.each do |parent_job|
       add_job_to_str(parent_job.name)
       add_children(parent_job.name)
     end
   end
    
    def add_other_jobs
      array_builder.all_jobs.each do |job|
        add_job_to_str(job.parent)
        add_job_to_str(job.name)
      end
    end
    
    def add_children(parent)
       array_builder.children(parent).each do |job|
         add_job_to_str(job.name)
       end
    end 
    
    def add_job_to_str(job)
      orderd_jobs_str << job unless job_already_added?(job)
    end 
    
    def job_already_added?(job)
      orderd_jobs_str.include?(job)
    end
    
    def check_self_dependent
      if array_builder.dependent_on_selves.count > 0
        raise "jobs can't depend on themselves"
      end
    end
    
    def check_for_circular_dependencies(job)
      array_builder.children(job.name).each do |child|
        if child.name == job.parent || decendents_names(child).include?(job.parent) 
          raise "jobs can’t have circular dependencies"
        end
      end
    end
    
    def decendents_names(child)
      array_builder.children(child.name).map(&:name)
    end
    
    def validate_circular_dependencies
      array_builder.all_jobs.each do |job|
        unless job.root?
          check_for_circular_dependencies(job)
        end
      end
    end
 
end