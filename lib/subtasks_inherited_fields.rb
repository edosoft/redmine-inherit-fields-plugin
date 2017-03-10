
module SubtasksInheritedFields
  module Helpers
    def self.inherit_attrs(parent_issue)
      attrs = {:parent_issue_id => parent_issue.id}
      settings = Setting.find_by_name("plugin_redmine_subtasks_inherited_fields") || {}
      settings = settings.value if settings.respond_to? :value
      settings = {} if settings == ""
      if settings[:inherit_tracker_id] #inherit tracker
        attrs[:tracker_id] = parent_issue.tracker
      else #use default subtask tracker
        default_tracker = Tracker.find_by_id(settings[:default_tracker_id] || 0) || parent_issue.tracker
        project = parent_issue.project
        default_tracker = parent_issue.tracker unless project.trackers.include? default_tracker
        attrs[:tracker_id] = default_tracker
      end
      attrs[:fixed_version_id] = parent_issue.fixed_version_id if settings[:inherit_fixed_version_id]
      attrs[:category_id] = parent_issue.category_id if settings[:inherit_category_id]
      attrs[:assigned_to_id] = parent_issue.assigned_to_id if settings[:inherit_assigned_to_id]
      attrs[:priority_id] = parent_issue.priority_id if settings[:inherit_priority_id]
      attrs[:start_date] = parent_issue.start_date if settings[:inherit_start_date]
      attrs[:due_date] = parent_issue.due_date if settings[:inherit_due_date]
      attrs[:subject] = parent_issue.subject if settings[:inherit_subject]
      attrs[:description] = parent_issue.description if settings[:inherit_description]
      attrs[:is_private] = parent_issue.is_private if settings[:inherit_is_private]
      attrs[:status_id] = parent_issue.status_id if settings[:inherit_status_id]
  
      #inherit custom fields
      inherit_custom_fields = settings[:inherit_custom_fields] || {}
      unless inherit_custom_fields.empty?
        custom_field_values = {}
        parent_issue.custom_field_values.each do |v|
          custom_field_values[v.custom_field_id] = v.value if inherit_custom_fields[v.custom_field_id.to_s]
        end
  
        attrs[:custom_field_values] = custom_field_values unless custom_field_values.empty?
      end

      return attrs
    end
  end
end 
