Then /^the conclusion of the committee should be a vector with value "(.*)" and position for key "(.*)"$/ do |value, key|
  vector = @report.conclusion
  position = BrighterPlanet::Purchase::KEY_MAP.index key
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

  BrighterPlanet::Purchase::KEY_MAP.each_with_index do |key, index|
    vector[index].should be_close(column_values[index].to_f, 0.00001)
  end
end
