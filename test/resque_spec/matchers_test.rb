require 'minitest_helper'

describe "ResqueSpec Matchers" do
  before do
    ResqueSpec.reset!
  end

  let(:first_name) { 'Les' }
  let(:last_name) { 'Hill' }

  describe "#have_queued" do
    describe "queued with a class" do
      before do
        Resque.enqueue(Person, first_name, last_name)
      end

      subject { Person }

      it { must have_queued(first_name, last_name) }
      it { must_not have_queued(last_name, first_name) }
    end

    describe "queued with a string" do
      before do
        Resque::Job.create(:people, "Person", first_name, last_name)
      end

      describe "asserted with a class" do
        subject { Person }

        it { must have_queued(first_name, last_name) }
        it { must_not have_queued(last_name, first_name) }
      end

      describe "asserted with a string" do
        subject { "Person" }

        it { must have_queued(first_name, last_name) }
        it { must_not have_queued(last_name, first_name) }
      end

      describe "with anything matcher" do
        subject { "Person" }

        it { must have_queued(anything, anything) }
        it { must have_queued(anything, last_name) }
        it { must have_queued(first_name, anything) }
        it { must_not have_queued(anything) }
        it { must_not have_queued(anything, anything, anything) }
      end
    end

    describe "#in" do

      before do
        Resque::Job.create(:people, "User", first_name, last_name)
      end

      subject { "User" }

      describe "without #in(queue_name)" do
        it "must raise a Resque::NoQueueError" do
          lambda { "User".must have_queued(first_name, last_name) }.must raise_error(Resque::NoQueueError)
        end
      end

      describe "with #in(queue_name)" do
        it { must have_queued(first_name, last_name).in(:people) }
        it { must_not have_queued(last_name, first_name).in(:people) }
      end

      describe "without #in(:places) after #in(:people)" do
        before { must have_queued(first_name, last_name).in(:people) }
        before { Resque.enqueue(Place) }

        specify { Place.must have_queued }
      end
    end

    describe "#times" do

      subject { Person }

      describe "job queued once" do
        before do
          Resque.enqueue(Person, first_name, last_name)
        end

        it { must_not have_queued(first_name, last_name).times(0) }
        it { must have_queued(first_name, last_name).times(1) }
        it { must_not have_queued(first_name, last_name).times(2) }
      end

      describe "no job queued" do
        it { must have_queued(first_name, last_name).times(0) }
        it { must_not have_queued(first_name, last_name).times(1) }
      end
    end

    describe "#once" do

      subject { Person }

      describe "job queued once" do
        before do
          Resque.enqueue(Person, first_name, last_name)
        end

        it { must have_queued(first_name, last_name).once }
      end

      describe "no job queued" do
        it { must_not have_queued(first_name, last_name).once }
      end
    end
  end
end