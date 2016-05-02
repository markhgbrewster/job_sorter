require 'spec_helper'
 
describe JobList do
  before :each do
    @job_list ||= JobList.new('a =>')
  end
  
  describe "#new" do
    it 'accepts a single string argument' do
      expect(@job_list).to be_an_instance_of(JobList)
    end
  end
  
  describe "#sorted_jobs" do
    it 'should be a sequence consisting of a single job a' do
      expect(@job_list.sorted_jobs).to eql('a')
    end
  end
  
end