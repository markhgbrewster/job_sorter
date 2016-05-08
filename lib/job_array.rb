class JobArray
  attr_reader :jobs_str
  private :jobs_str

  def initialize(jobs_str)
    @jobs_str = jobs_str
  end
  
  def job_str_to_arr
    jobs_arr = []
    jobs_str.split("\n").each  do |jobs| 
       jobs.split(' =>').each do |job|
       	jobs_arr << job
       end
    end
    jobs_arr
  end
  
  
end