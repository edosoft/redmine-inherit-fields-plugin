
describe "Subtasks pages" do
  subject { page }
  
  let(:user) { FactoryGirl.create(:user, :admin => true) }
  let(:project) { FactoryGirl.create(:project) }
  let(:version) { FactoryGirl.create(:version, :project => project) }
  let(:issue) { FactoryGirl.create(:issue, :project => project, :fixed_version => version) }

  before do
    visit signin_path
    fill_in "username", with: user.login
    fill_in "password", with: user.password
    click_button "login"
  end
  
  describe "issue navigation" do
    describe "with default options" do
      before { visit issue_path(issue) }
      it { should have_content(issue.subject) }
      it { should have_content(issue.tracker.name) }
      it { should have_content("##{issue.id}") }
      
    
    end

  end

end
