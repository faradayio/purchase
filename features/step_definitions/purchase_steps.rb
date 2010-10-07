Then /^the conclusion of the committee should have ratios summing to "(.*)"$/ do |sum|
  ratios = @report.conclusion
  ratios.values.sum.to_f.should == sum.to_f
end
