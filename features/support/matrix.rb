Then /^the conclusion of the committee should be a square matrix with "(\d+)" rows and columns$/ do |num|
  matrix = @report.conclusion
  matrix.row_size.should == num.to_i
  matrix.should be_square
end
