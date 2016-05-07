require 'job_hash'
require 'job'
require 'jobs_array_builder'

class JobSorter
  attr_reader :jobs_str, :orderd_jobs_str, :decendents_hash
  private :jobs_str

  def initialize(jobs_str)
    @jobs_str = jobs_str
    @orderd_jobs_str = ''
    @decendents_hash = {}
  end
  
  def sorted_jobs
    check_self_dependent
    build_dynasty
    check_circular_dependencies
    add_root_jobs
    add_parents
    orderd_jobs_str
  end
  
  private
    
    def jobs_hash
      @jobs_hash ||= JobHash.new(jobs_str).hash_of_jobs
    end
  
    def array_builder
      @array_builder ||= JobsArrayBuilder.new(jobs_hash)
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
    
    def build_dynasty
      array_builder.all_jobs.each do |job|
        unless job.root?
          build_decendents_hash(job)
        end
      end
    end
    
    def check_circular_dependencies
      decendents_hash.keys.each do |key|
        if decendents_hash[key].include?(key)
          raise "jobs can’t have circular dependencies"
        end  
      end  
    end
    
    def build_decendents_hash(job)
      if decendents_hash.keys.include?(job.name)
        decendents_hash[job.name] << job.parent
      else
        decendents_hash[job.name] = [job.parent]
      end
       build_decendents_hash_part_2(job)  
    end
    
    def build_decendents_hash_part_2(job)
      decendents_hash.select{|key, value| value.include?(job.name) }.keys.each do |key|
        decendents_hash[key] << job.parent unless job.root?
      end
    end
end