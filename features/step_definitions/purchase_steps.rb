Then /^the conclusion of the committee should have ratios summing to "(.*)"$/ do |sum|
  ratios = @report.conclusion
  ratios.values.sum.to_f.should == sum.to_f
end

Then /^the "(.*)" committee should have used quorum "(.*)"$/ do |committee, quorum|
  report = @activity_instance.deliberations[:emission].reports.find { |r| r.committee.name == committee.to_sym }
  report.quorum.name.should == quorum
end
