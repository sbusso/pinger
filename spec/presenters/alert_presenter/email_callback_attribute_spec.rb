require 'spec_helper'

describe AlertPresenter::EmailCallbackAttribute do

  let :alert_presenter do
    mock AlertPresenter, alert: mock(Alert)
  end

  subject { described_class.new alert_presenter }

  it { should be_a(AlertPresenter::Attribute) }

  [:email_callback_options_for_select].each do |method|
    it "delegates #{method} to the alert presenter" do
      result = mock Object
      args = [mock(Object), mock(Object)]
      alert_presenter.should_receive(method).with(*args).and_return(result)
      subject.send(method, *args).should == result
    end
  end

end