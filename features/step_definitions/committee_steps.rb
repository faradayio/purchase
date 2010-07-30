def coerce_value(value)
  if value =~ /\d+\.\d+/
    value.to_f
  elsif value =~ /^\d+$/
    value.to_i
  else
    value
  end
end

def compare_values(a, b)
  if b =~ /\d+\.\d+/
    b = b.to_f
    a.should be_close(b, 0.00001)
  elsif b =~ /^\d+$/
    b = b.to_i
    a.should == b
  else
    a.should == b
  end
end

Given /^a purchase emitter$/ do
  @activity = PurchaseRecord
end

Given /^(a )?characteristic "(.*)" of "(.*)"$/ do |_, name, value|
  @characteristics ||= {}

  if name =~ /\./
    model_name, attribute = name.split /\./
    model = model_name.singularize.camelize.constantize
    value = model.send "find_by_#{attribute}", value
    @characteristics[model_name.to_sym] = value
  else
    value = coerce_value(value)
    @characteristics[name.to_sym] = value
  end
end

When /^the "(.*)" committee is calculated$/ do |committee_name|
  @decision ||= @activity.decisions[:emission]
  @committee = @decision.committees.find { |c| c.name.to_s == committee_name }
  @report = @committee.report(@characteristics, [])
  @characteristics[committee_name.to_sym] = @report.conclusion
end

Then /^the committee should have used quorum "(.*)"$/ do |quorum|
  @report.quorum.name.should == quorum
end

Then /^the conclusion of the committee should be (.+)$/ do |conclusion|
  compare_values(@report.conclusion, conclusion)
end

Then /^the conclusion of the committee should include a key of (.*) and value (.*)$/ do |key, value|
  @report.conclusion.keys.map(&:to_s).should include(key)

  @report.conclusion.each do |k, v|
    @report.conclusion[k.to_s] == v
  end
  compare_values(@report.conclusion[key.to_s], value)
end

Then /^the conclusion of the committee should have "(.*)" of "(.*)"$/ do |attribute, value|
  report_value = coerce_value @report.conclusion.send(attribute)
  report_value.should == coerce_value(value)
end

