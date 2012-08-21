describe "ERB" do
  before do
    @simple = ERB[:simple]
  end

  it "should create an instance for each template by its basename" do
    @simple.should be_kind_of(ERB)
  end

  it "should execute the body and return the result as a string, with #result" do
    @some_data = "hello"
    @simple.result(self).should == "<div>hello</div>"
  end
end