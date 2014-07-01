
require File.expand_path('../../test_helper', __FILE__)
require File.expand_path(File.dirname(__FILE__) + '/../../../../test/test_helper')

class CommonViewsTest < ActionController::IntegrationTest
  fixtures :projects,
           :users,
           :roles,
           :members,
           :member_roles,
           :issues,
           :issue_statuses,
           :versions,
           :trackers,
           :projects_trackers,
           :issue_categories,
           :enabled_modules,
           :enumerations,
           :attachments,
           :workflows,
           :custom_fields,
           :custom_values,
           :custom_fields_projects,
           :custom_fields_trackers,
           :time_entries,
           :journals,
           :journal_details,
           :queries

  def setup
    @project_1 = Project.find(1)
    EnabledModule.create(:project => @project_1, :name => 'gantt')
    EnabledModule.create(:project => @project_1, :name => 'calendar')
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @request.env['HTTP_REFERER'] = '/'
  end

  test "View issues" do
    log_user("admin", "admin")
    get "/issues"
    assert_response :success
  end

  test "View first issue" do
    log_user("admin", "admin")
    get "/issues/1"
    assert_response :success
  end

  test "View subtasks_inherited_fields plugin settings" do
    log_user("admin", "admin")
    get "/settings/plugin/redmine_subtasks_inherited_fields"
    assert_response :success
  end

end
