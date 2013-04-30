#Salma's Tests

  it "initializes a new project" do
    a = create_logged_in_developer
    sign_in(a.gamer)
    get :new
    response.code.should eq("200")
  end

  it "assigns the requested project to project" do
    a = create_logged_in_developer
    sign_in(a.gamer)
    project
    get :edit, id: project
    assigns(:project).should eq(project)
  end

  it "located the requested project" do
    a = create_logged_in_developer
    sign_in(a.gamer)
    project
    put :update, id: project.id, project: { name: "hospital", category:"" }
    assigns(:project).should eq(project)
  end

  it "changes project's attributes" do
    a = create_logged_in_developer
    sign_in(a.gamer)
    project
    put :update, id: project,
    project: { name: "Pro", minAge:"23", maxAge:"50",category:"" }
    project.reload
    project.name.should eq("Pro")
    project.minAge.should eq(23)
    project.maxAge.should eq(50)
  end

  it "redirects to the project index" do
    a = create_logged_in_developer
    sign_in(a.gamer)
    project
    put :update, id: project, project: { name: "Pro", minAge:"23", maxAge:"50",category:"" }
    response.should redirect_to projects_path
  end

  it "locates the requested project" do
    a = create_logged_in_developer
    sign_in(a.gamer)
    project
    put :update, id: project, project: { name: "Pro", minAge:"23", maxAge:"50",category:"" }
    assigns(:project).should eq(project)
  end

  it "does not change project's attributes" do
   a = create_logged_in_developer
   sign_in(a.gamer)
   project
   put :update, id: project,
   project: { name: "Pro", minAge:"500", maxAge:"50",category:"" }
   project.reload
   project.name.should_not eq("Pro")
   project.minAge.should_not eq(500)
   project.minAge.should eq(19)
 end

 it "re-renders the edit method" do
  a = create_logged_in_developer
  sign_in(a.gamer)
  project
  put :update, id: project, project: { name: "Pro", minAge:"500", maxAge:"50",category:"" }
  response.should render_template :edit
end

it "renders the #show view" do
  a = create_logged_in_developer
  sign_in(a.gamer)
  project
  get :show, id: project
  response.should render_template project
end
end