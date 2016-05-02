require 'spec_helper'
 
describe JobArray do
  let(:jobs_string) { '' }
  let(:array) { JobArray.new(jobs_string) }

  describe "#new" do
    it 'accepts a single string argument' do
      expect(array).to be_an_instance_of(JobArray)
    end
  end

  describe "#job_str_to_arr" do
    subject { array.job_str_to_arr }
    context 'when jobs string is an empty string' do
      it 'returns an empty array' do
        expect(subject).to eql([])
      end
    end

    context 'when the jobs string is a => ' do
      let(:jobs_string) { 'a => ' }
      it 'returns an array containing a and a space' do
        expect(subject).to eql(['a', ' '])
      end
    end

    context 'when the jobs string is a => b =>  c =>' do
      let(:jobs_string) {"a => \nb => \nc => "}
      it "returns an array containing a,' ', b, ' ', c, ' '" do
        expect(subject).to eql(['a',' ','b',' ','c',' '])
      end
    end

    context 'when the jobs string is a => b => c c => f d => a e => b f =>' do
      let(:jobs_string) {"a => \nb => c\nc => f\nd => a\ne => b\nf => "}
      it 'returns an array with all 6 jobs and dependencies' do
        expect(subject).to eql(["a", " ", "b", " c", "c", " f", "d", " a", "e", " b", "f", " "])
      end
    end
  end

end