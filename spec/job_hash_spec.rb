require 'spec_helper'
 
describe JobHash do
  let(:jobs_string) { '' }
  let(:hash) { JobHash.new(jobs_string) }
  
  describe "#new" do
    it 'accepts a single string argument' do
      expect(hash).to be_an_instance_of(JobHash)
    end
  end
  
  describe "#hash_of_jobs" do
    subject { hash.hash_of_jobs } 
    context 'when jobs string is an empty string' do
      it 'returns an empty hash' do
        expect(subject).to eql({})
      end
    end
    
    context 'when the jobs string is a => ' do
      let(:jobs_string) { 'a => ' }
      it 'returns an hash with key a and value space' do 
        expect(subject).to eql({'a' => ' '})
      end
    end
    
    context 'when the jobs string is a => b =>  c =>' do 
      let(:jobs_string) {"a => \nb => \nc => "}
      it "returns a hash with the key being a job and the value being its' dependency " do
        expect(subject).to eql({'a' => ' ','b' => ' ','c' => ' '})
      end
    end
    
  end
  
end