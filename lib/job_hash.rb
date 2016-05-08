class JobHash
  attr_reader :jobs_str
  private :jobs_str

  def initialize(jobs_str)
    @jobs_str = jobs_str
  end
  
  def hash_of_jobs
    #converts arry of jobs into a hash for ease of use
    jobs_hash = Hash.new
    jobs_arr.each_with_index do |job, index|
      jobs_hash[job] = jobs_arr[(index + 1)].strip! if is_even?(index)
    end
    jobs_hash
  end
  
  private

    def is_even?(index)
      #if the index is even then it is a job name not a dependancy and should be a key in the hash
      index % 2 == 0
    end

    def jobs_arr
      #build an array of jobs names and jobs dependents form the job_str
      jobs_str.split("\n").map{|slot| slot.split(' =>')}.flatten
    end
end