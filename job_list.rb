class JobList
  attr_reader :jobs_str
  private :jobs_str

  def initialize(jobs_str)
    @jobs_str = jobs_str
  end
  
  def sorted_jobs
    'a'
  end
  
end