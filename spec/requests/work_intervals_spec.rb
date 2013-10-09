require 'spec_helper'

describe "WorkIntervals" do
  describe "GET /work_intervals" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get work_intervals_path
      response.status.should be(200)
    end
  end
end
