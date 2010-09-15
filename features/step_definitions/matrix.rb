Then /^the conclusion of the committee should be a vector with value "(.*)" and position for key "(.*)"$/ do |value, key|
  vector = @report.conclusion
  position = BrighterPlanet::Purchase.key_map.index key
  compare_values vector[position], value
end

Then /^the conclusion of the committee should be a square matrix with "(\d+)" rows and columns$/ do |num|
  matrix = @report.conclusion
  matrix.row_size.should == num.to_i
  matrix.should be_square
end

Then /^the conclusion of the committee should be a vector with values "(.*)"$/ do |column_values|
  column_values = column_values.split(/,/).map(&:to_f)
  vector = @report.conclusion
  vector = vector.row(0) if vector.is_a? Matrix  #some vectors are single-row matrices

  vector.should have_column_values(column_values)
end
