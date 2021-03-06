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
    let(:jobs_string) { '' }
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

    context 'when the jobs string is a => b => c c =>' do
      let(:jobs_string) {"a => \nb => c \nc => "}
      it 'returns a sequence consisting where c comes before b ' do
        expect(subject).to eql('acb')
      end
    end

    context 'when the jobs string is a => b => c c => f d => a e => b f =>' do
      let(:jobs_string) {"a => \nb => c \nc => f \nd => a \ne => b \nf => "}
      it 'returns a sequence that positions f before c, c before b, b before e and a before d' do
        expect(subject).to eql('adfcbe')
      end
      it 'returns all 6 jobs' do
        expect(subject.length).to eql(6)
      end
    end

    context 'when the jobs string is a => b => c => c' do
      let(:jobs_string) {"a => \nb => \nc => c"}
      it "returns and error stating that jobs can't depend on themselves" do
        expect { subject }.to raise_error(RuntimeError, "jobs can't depend on themselves")
      end
    end
    
    context 'when the jobs string is a => b => c c => f d => a e => f => b' do 
      let(:jobs_string) {"a => \nb => c \nc => f \nd => a \ne => \nf => b"}
      it "returns and error stating that jobs can’t have circular dependencies" do
         expect { subject }.to raise_error(RuntimeError, "jobs can’t have circular dependencies")
      end
    end
    
    context 'when the jobs string is a => b => c c => f d => a e => f => g g => h h => b' do 
      let(:jobs_string) {"a => \nb => c \nc => f \nd => a \ne => \nf => h \ng => h \nh => b" }
      it "returns and error stating that jobs can’t have circular dependencies" do
         expect { subject }.to raise_error(RuntimeError, "jobs can’t have circular dependencies")
      end
    end
    
    context 'when the jobs string is a => b b => c c =>  d => a e => b f => a' do
      let(:jobs_string) {"a => b \nb => c \nc => \nd => a \ne => b \nf => e"}
      it 'returns a sequence that positions c before b, b before a and e, a before d and e before f' do
        expect(subject).to eql('cbadef')
      end
    end

  end

end