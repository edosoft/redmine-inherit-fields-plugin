class Hooks < Redmine::Hook::ViewListener
  def controller_issues_edit_before_save(context={})
    issue = context[:issue]
    settings = Setting.send("plugin_redmine_subtasks_inherited_fields") || {}
    update_all_children_subtasks(issue, settings)
  end

  def controller_issues_bulk_edit_before_save(context={})
    issue = context[:issue]
    settings = Setting.send("plugin_redmine_subtasks_inherited_fields") || {}
    update_all_children_subtasks(issue, settings)
  end

  def update_all_children_subtasks(issue, settings)
    children = issue.children
    children.each do |sub_task|
      update_subtask(sub_task, issue, settings)
      update_all_children_subtasks(sub_task, settings)
    end
  end

  def update_subtask(sub_task, issue, settings)
    sub_task.fixed_version_id = issue.fixed_version_id if settings[:inherit_fixed_version_id]
    sub_task.category_id = issue.category_id if settings[:inherit_category_id]
    sub_task.assigned_to_id = issue.assigned_to_id if settings[:inherit_assigned_to_id]
    sub_task.priority_id = issue.priority_id if settings[:inherit_priority_id]
    sub_task.start_date = issue.start_date if settings[:inherit_start_date]
    sub_task.due_date = issue.due_date if settings[:inherit_due_date]
    sub_task.description = issue.description if settings[:inherit_description]
    sub_task.is_private = issue.is_private if settings[:inherit_is_private]
    sub_task.status_id = issue.status_id if settings[:inherit_status_id]
    sub_task.save
  end

end