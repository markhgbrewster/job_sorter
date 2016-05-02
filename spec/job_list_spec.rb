require 'spec_helper'
 
describe JobList do
  before :each do
      @job_list = JobList.new('a =>')
  end
  
  describe "#new" do
    it 'accepts a single string argument' do
      @job_list.should be_an_instance_of JobList
    end
  end
  
end