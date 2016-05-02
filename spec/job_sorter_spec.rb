require 'spec_helper'
 
describe JobSorter do
  let(:jobs_string) { '' }
  let(:sorter) { JobSorter.new(jobs_string) }
  
  describe "#new" do
    it 'accepts a single string argument' do
      expect(sorter).to be_an_instance_of(JobSorter)
    end
  end
  
  describe "#sorted_jobs" do
    subject { sorter.sorted_jobs } 
    context 'when jobs string is an empty string' do
      it 'returns sequence consisting of an empty string' do
        expect(subject).to eql('')
      end
    end
    
    context 'when the jobs string is a => ' do
      let(:jobs_string) { 'a => ' }
      it 'returns a sequence consisting of a single job a' do 
        expect(subject).to eql('a')
      end
    end
    
    context 'when the jobs string is a => b =>  c =>' do 
      let(:jobs_string) {"a => \nb => \nc => "}
      it 'returns a sequence consisting of jobs a b and c' do
        expect(subject).to eql('abc')
      end
    end
    
  end
  
end