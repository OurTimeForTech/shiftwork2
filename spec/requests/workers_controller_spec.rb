require 'rails_helper'

RSpec.describe "WorkersControllers", type: :request do
  let(:org_user) { create(:user) }
  let(:worker_user) { create(:user, :worker_user_type) }
  let(:worker) { create(:worker, user_id: worker_user.id) }
  let(:org) { create(:org, user_id: org_user.id) }

  describe "GET /workers" do
    # workers #index    
    # should this response be a 204?
    # follow redirect
  end

  describe "POST /workers" do
    # workers #create
    before do
      Worker.destroy_all
      login_as(worker_user.email, worker_user.password)
    end

    it "should create a new worker when all necessary params are supplied" do
      post workers_path, params: { worker: { user_id: worker_user.id, first_name: "Full", last_name: "Name", worker_city: "Cityville", worker_state:"AA", bio: ""} }
      
      # FIXME: getting a failure, redirect goes to login instead, why?
      # expect(response).to redirect_to users_path(worker_user.id)
      expect(response).to have_http_status(302)

      follow_redirect!

      expect(response.body).to include("Worker Account created successfully!")
      expect(response.body).to include("Your Worker Account Details")
    end

    it "should display an error message and re-render the form if necessary params are missing" do
      post workers_path, params: { worker: { first_name: nil}}
      
      expect(response.body).to include("Something went wrong.")
      expect(response.body).to include("Create Worker Account")
    end
    # users must be logged in to access
    # with errors
        # "Something went wrong."
    # with success
        # "Worker Account created successfully!"
        # follow redirect
        # check for new worker info
  end

  describe "GET /workers/new" do
    #  workers #new
    # as an org, TODO: orgs can access /workers/new page, check with group
    # as a worker, TODO: sees the form

  end

  describe "GET /workers/:id" do
    #   workers #show

    it "should show a worker their shifts" do
      login_as(worker_user.email, worker_user.password)
      get workers_path(worker.id)

      # expect(response).to have_http_status(204)
      expect(response.body).to include("All Your Shifts")

    end

    it "should show users who are not the worker a bio" do
      login_as(org_user.email, org_user.password)
      get workers_path(worker.id)

      expect(response.body).to include(worker.bio)
    end

    # as an org or other worker
        # Shows name and bio
    # as the worker
        # "All Your Shifts"
  end

  describe "GET /workers/:id/edit" do
    #   workers #edit
    # as an org
        # "You do not have authority to access that."
        # follow redirect to make sure it is the org's profile page
    # as another worker
    # as the worker
        # should show a form
  end

  describe "PATCH /workers/:id" do
    # workers # partial update
    # success
        # "Worker Account updated successfully!"
        # follow redirect to check for changes
    # missing required value or setting required value to nil
        # "Something went wrong." with a status
        # make sure we're still on the same page
  end

  describe "PUT /workers/:id" do
    # workers # full update
    # success
    # missing required value
  end

  describe "DELETE /workers/:id" do
    #   workers #destroy
    # is this implemented?
  end

end
