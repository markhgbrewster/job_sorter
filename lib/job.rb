class Job
  attr_reader :key, :job_hash
  private :key, :job_hash
  
  def initialize(key, job_hash)
    @key = key
    @job_hash = job_hash
  end
  
  def name
    #returns the name of the job 
    key
  end
  
  def parent
    #returns the job the job is dependant on 
    job_hash[key]
  end
  
  def root?
    #returns true of the job is not depandant on any other job
    parent == ''
  end

end