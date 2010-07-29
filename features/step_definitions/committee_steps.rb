Given /^a purchase emitter$/ do
  @activity = PurchaseRecord
end

Given /^(a )?characteristic "(.*)" of "(.*)"$/ do |_, name, value|
  @characteristics ||= {}
  if value =~ /\d+\.\d+/
    value = value.to_f
  elsif value =~ /^\d+$/
    value = value.to_i
  end
  @characteristics[name.to_sym] = value
end

When /^the (.*) committee is calculated$/ do |committee_name|
  @decision ||= @activity.decisions[:emission]
  @committee = @decision.committees.find { |c| c.name.to_s == committee_name }
  @report = @committee.report(@characteristics, [])
end

Then /^the committee should have used quorum "(.*)"$/ do |quorum|
  @report.quorum.name.should == quorum
end

Then /^the conclusion of the committee should be (.+)$/ do |conclusion|
  if conclusion =~ /\d+\.\d+/
    conclusion = conclusion.to_f
    @report.conclusion.should be_close(conclusion, 0.00001)
  elsif conclusion =~ /^\d+$/
    conclusion = conclusion.to_i
    @report.conclusion.should == conclusion
  else
    @report.conclusion.should == conclusion
  end
end
