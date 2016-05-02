class Job
  attr_reader :key, :job_hash
  private :key, :job_hash
  
  def initialize(key, job_hash)
    @key = key
    @job_hash = job_hash
  end
  
  def name 
    key
  end
  
  def parent
    job_hash[key]
  end
  
  def root?
    parent == ' '
  end
  
  def child?
    parent != ' '
  end
end