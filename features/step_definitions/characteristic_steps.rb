Then /^the "(.*)" characteristic should be displayed as "(.*)"$/ do |name, value|
  name = name.to_sym
  all_chars = @activity.characteristics.merge @activity.deliberations[:emission].characteristics
  @activity.class.characteristics[name].display(all_chars).should == value
end
