Then /^the "(.*)" characteristic should be displayed as "(.*)"$/ do |name, value|
  name = name.to_sym
  c = @activity_instance.characteristics[name] || @activity_instance.deliberations[:emission].characteristics[name]
  c.to_s.should == value
end
