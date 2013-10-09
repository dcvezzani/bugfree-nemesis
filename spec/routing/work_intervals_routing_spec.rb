require "spec_helper"

describe WorkIntervalsController do
  describe "routing" do

    it "routes to #index" do
      get("/work_intervals").should route_to("work_intervals#index")
    end

    it "routes to #new" do
      get("/work_intervals/new").should route_to("work_intervals#new")
    end

    it "routes to #show" do
      get("/work_intervals/1").should route_to("work_intervals#show", :id => "1")
    end

    it "routes to #edit" do
      get("/work_intervals/1/edit").should route_to("work_intervals#edit", :id => "1")
    end

    it "routes to #create" do
      post("/work_intervals").should route_to("work_intervals#create")
    end

    it "routes to #update" do
      put("/work_intervals/1").should route_to("work_intervals#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/work_intervals/1").should route_to("work_intervals#destroy", :id => "1")
    end

  end
end
