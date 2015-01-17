
module SubtasksInheritedFields
  module IssuesHelperPatch
    module InstanceMethods
      
      # Returns a link for adding a new subtask to the given issue
      def link_to_new_subtask_plugin(issue)
        settings = Setting.find_by_name("plugin_redmine_subtasks_inherited_fields") || {}
        settings = settings.value if settings.respond_to? :value
        settings = {} if settings == ""
        attrs = {
          #:tracker_id => issue.tracker,
          :parent_issue_id => issue
        }
        if settings[:inherit_tracker_id] #inherit tracker
          attrs[:tracker_id] = issue.tracker
        else #use default subtask tracker
          default_tracker = Tracker.find_by_id(settings[:default_tracker_id] || 0) || issue.tracker
          default_tracker = issue.tracker unless @project.trackers.include? default_tracker
          attrs[:tracker_id] = default_tracker
        end

        attrs[:fixed_version_id] = issue.fixed_version_id if settings[:inherit_fixed_version_id]
        attrs[:category_id] = issue.category_id if settings[:inherit_category_id]
        attrs[:assigned_to_id] = issue.assigned_to_id if settings[:inherit_assigned_to_id]
        attrs[:priority_id] = issue.priority_id if settings[:inherit_priority_id]
        attrs[:start_date] = issue.start_date if settings[:inherit_start_date]
        attrs[:due_date] = issue.due_date if settings[:inherit_due_date]
        attrs[:description] = issue.description if settings[:inherit_description]
        attrs[:is_private] = issue.is_private if settings[:inherit_is_private]
        attrs[:status_id] = issue.status_id if settings[:inherit_status_id]

        #inherit custom fields
        inherit_custom_fields = settings[:inherit_custom_fields] || {}
        unless inherit_custom_fields.empty?
          custom_field_values = {}
          issue.custom_field_values.each do |v|
            custom_field_values[v.custom_field_id] = v.value if inherit_custom_fields[v.custom_field_id.to_s]
          end

          attrs[:custom_field_values] = custom_field_values unless custom_field_values.empty?
        end

        link_to(l(:button_add), new_project_issue_path(issue.project, :issue => attrs))
      end
    end

    def self.included(receiver)
      receiver.send :include, InstanceMethods
 
      receiver.class_eval do
        unloadable
        alias_method :link_to_new_subtask, :link_to_new_subtask_plugin
      end
    end
  end
end

unless IssuesHelper.included_modules.include?(SubtasksInheritedFields::IssuesHelperPatch)
  #puts "Including module into IssuesHelper"
  IssuesHelper.send(:include, SubtasksInheritedFields::IssuesHelperPatch)
end

