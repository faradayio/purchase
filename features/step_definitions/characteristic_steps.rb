Then /^the "(.*)" characteristic should be displayed as "(.*)"$/ do |name, value|
  name = name.to_sym
  c = @activity.characteristics[name] || @activity.deliberations[:emission].characteristics[name]
  c.to_s.should == value
end
