require 'spec_helper'

describe JobsArrayBuilder do
  let(:builder) { JobsArrayBuilder.new(jobs_hash) }
  let(:jobs_hash) { { 'b' => 'c', 'c' => '', 'd' => 'd' }  }
  
  let(:first_job) { double('first_job', name: 'b', root?: false, parent: 'c') }
  let(:second_job) { double('second_job', name: 'c', root?: true, parent: '') }
  let(:third_job) { double('third_job', name: 'd', root?: false, parent: 'd') }
  
  before do
    allow(Job).to receive(:new).with('b', jobs_hash).and_return(first_job)
    allow(Job).to receive(:new).with('c', jobs_hash).and_return(second_job)
    allow(Job).to receive(:new).with('d', jobs_hash).and_return(third_job)
  end
  
  describe '#all_jobs' do
    subject { builder.all_jobs }
    it 'returns all the jobs' do
      expect(subject).to eql([first_job, second_job, third_job])
    end
  end
  
  describe '#roots' do
    subject { builder.roots }
    it 'returns the jobs not dependent on anything' do
      expect(subject).to eql([second_job])
    end
  end
  
  describe '#not_roots' do
    subject { builder.not_roots }
    it 'returns the jobs that are not roots' do
      expect(subject).to eql([first_job, third_job])
    end
  end
  
  describe '#children' do
    subject { builder.children(second_job.name) }
    it 'returns the and array of the jobs dependent on the job passed in' do
      expect(subject).to eql([first_job])
    end
  end
  
  describe '#dependent_on_selves' do
    subject { builder.dependent_on_selves }
    it 'returns the jobs that are dependen on them selves' do
      expect(subject).to eql([third_job])
    end
  end
end