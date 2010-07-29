def coerce_value(value)
  if value =~ /\d+\.\d+/
    value.to_f
  elsif value =~ /^\d+$/
    value.to_i
  else
    value
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

When /^the (.*) committee is calculated$/ do |committee_name|
  puts "calcing #{committee_name} committee with chars #{@characteristics.inspect}"
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

Then /^the conclusion of the committee should include a key of (.*) and value (.*)$/ do |key, value|
  @report.conclusion.keys.should include(key)

  @report.conclusion[key].should == value
end
