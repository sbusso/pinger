require 'spec_helper'

describe LocationPresenter do
  subject { described_class.new(location, view) }

  let(:location) do
    Factory :location,
      :title => 'Google',
      :seconds => 10,
      :url => 'http://x.com',
      :http_method => 'get'
  end

  [[:seconds, 10], [:url, 'http://x.com'], [:title, 'Google']].each do |method, value|
    describe "#{method}" do
      it "delegates to the location" do
        subject.send(method).should === value
      end
    end
  end

  describe "next_ping" do
    before { Timecop.freeze(Time.now) }
    after { Timecop.return }

    context "when the location's next ping date is in the future" do
      before { location.stub(:next_ping_date) { 3.minutes.from_now } }
      it "returns the distance of time, in words, until then" do
        subject.next_ping.should == '3 minutes'
      end
    end

    [
      ['now', lambda { Time.now }],
      ["in the past", lambda { 2.minutes.ago }],
      ["nil", lambda { nil }]
    ].each do |text, method_block|
      context "when the location's next ping date is #{text}" do
        before { location.stub(:next_ping_date, method_block) }
        it { subject.next_ping.should == 'just a moment' }
      end
    end
  end

  describe "http_method" do
    it "returns the location's http method upcased" do
      subject.http_method.should == 'GET'
    end
  end

  describe "render_pings" do
    context "when there are pings" do
      before do
        @pings = [mock(Ping)]
        subject.stub(:pings) { @pings }
      end
      it "tells the view to render the pings table" do
        view.should_receive(:render).with('pings/table', :pings => @pings)
        subject.render_pings
      end
    end

    context "when there are no pings" do
      before { subject.stub(:pings) }
      it "returns a no-pings msg" do
        subject.render_pings.should == "<p>No pings yet</p>"
      end
    end
  end

  describe "pings" do
    before do
      Factory(:ping, :performed_at => 1.minute.ago)
      Factory(:ping, :location => location, :performed_at => nil)
    end
    it "returns the performed pings for the location, ordered performed_at desc" do
      pings = (1..3).map do |i|
        Factory(:ping, :location => location, :performed_at => i.minutes.ago)
      end
      subject.pings.should == pings
    end
  end
end