require 'job_hash'
require 'jobs_array'

class JobSorter
  attr_reader :jobs_str, :orderd_jobs_str, :ancestry_hash
  private :jobs_str

  def initialize(jobs_str)
    @jobs_str = jobs_str
    @orderd_jobs_str = ''
    @ancestry_hash = {}
  end
  
  def sorted_jobs
    check_self_dependent
    check_circular_dependencies
    add_root_jobs
    add_other_jobs
    orderd_jobs_str
  end
  
  private
    
    def jobs_hash
      #converts the jobs string in to a hash to make them more usable
      @jobs_hash ||= JobHash.new(jobs_str).hash_of_jobs
    end
  
    def array_builder
      #loop through the jobs hash and creates an array of Job objects 
      @array_builder ||= JobsArray.new(jobs_hash)
    end
  
    def jobs
      #returns an array of all the job names
      @jobs ||= jobs_hash.keys
    end
  
    def add_root_jobs
      #Adds the jobs with no parent (jobs with a blank after the =>)
      #as well as any jobs dependent on them to the orderd_jobs_str
      array_builder.roots.each do |root_job|
        add_job_to_str(root_job.name)
        add_children(root_job.name)
      end
    end
    
   def add_other_jobs
     #Adds the jobs with a parent (jobs with a letter after the => )
     #as well as any jobs dependent on them to the orderd_jobs_str
     array_builder.not_roots.each do |job|
       add_job_to_str(job.name)
       add_children(job.name)
     end
   end
    
    def add_children(parent)
      #Adds the jobs dependant on the passed in parent job to the orderd_jobs_str
       array_builder.children(parent).each do |job|
         add_job_to_str(job.name)
       end
    end 
    
    def add_job_to_str(job)
      #Adds the passed in job to the orderd_jobs_str unless it is already in there
      orderd_jobs_str << job unless job_already_added?(job)
    end 
    
    def job_already_added?(job)
      #retrns true if the passed in job is already in the orderd_jobs_str and false if not
      orderd_jobs_str.include?(job)
    end
    
    def check_self_dependent
      #raises an excption if there is one or more jobs that are dependad on them selevs 
      if array_builder.dependent_on_selves.count > 0
        raise "jobs can't depend on themselves"
      end
    end
    
    def check_circular_dependencies
      #returns and excption if any circular dependencies are found 
      build_ancestry_hash
      ancestry_hash.keys.each do |key|
        if ancestry_hash[key].include?(key)
          raise "jobs can’t have circular dependencies"
        end
      end
    end
    
    def build_ancestry_hash
      #makes a hash that has a key for each job and values the consistes of an array containing all the jobs a job is dependant on
      array_builder.all_jobs.each do |job|
        unless job.root?
          add_to_ancestry_hash(job)
        end
      end
    end
    
    def add_to_ancestry_hash(job)
      #adds a job to the ancestry_hash with it's name bing the key and inserts it parent as the value 
      if ancestry_hash.keys.include?(job.name)
        ancestry_hash[job.name] << job.parent
      else
        ancestry_hash[job.name] = [job.parent]
      end
      add_ancestrors_to_hash(job)
    end
    
    def add_ancestrors_to_hash(job)
      #add the job passed in's parent to the array in the hash of job the is dependant on the job passed in
      ancestry_hash.select{|key, value| value.include?(job.name) }.keys.each do |key|
        ancestry_hash[key] << job.parent unless job.root?
      end
    end
end