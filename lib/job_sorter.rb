require 'job_hash'

class JobSorter
  attr_reader :jobs_str
  private :jobs_str

  def initialize(jobs_str)
    @jobs_str = jobs_str
  end
  
  def sorted_jobs
    jobs_hash.keys.join('')
  end
  
  private
    
    def jobs_hash
      @jobs_hash ||= JobHash.new(jobs_str).hash_of_jobs
    end
  
end