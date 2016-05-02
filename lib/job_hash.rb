require 'job_array'

class JobHash
  attr_reader :jobs_str
  private :jobs_str

  def initialize(jobs_str)
    @jobs_str = jobs_str
  end
  
  def hash_of_jobs
    build_hash
  end
  
  private
      
    def build_hash
      jobs_hash = Hash.new
      jobs_arr.each_with_index do |job, index|
        jobs_hash[job] = jobs_arr[(index + 1)].strip! if is_even?(index)
      end
      jobs_hash
    end

    def is_even?(index)
      index % 2 == 0
    end

    def jobs_arr
      @jobs_arr ||= JobArray.new(jobs_str).job_str_to_arr
    end
end