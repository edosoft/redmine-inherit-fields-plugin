
module SubtasksInheritedFields
  module IssuesControllerPatch
    module InstanceMethods

      # Redirects user after a successful issue creation with inheritance
      def redirect_after_create_plugin
        if params[:continue]

          attrs = {:tracker_id => @issue.tracker, :parent_issue_id => @issue.parent_issue_id}.reject {|k,v| v.nil?}

          #inherit fields on create subtask and continue
          if @issue.parent_issue_id
            parent_issue = Issue.find(@issue.parent_issue_id)

            settings = Setting.find_by_name("plugin_redmine_subtasks_inherited_fields") || {}
            settings = settings.value if settings.respond_to? :value
            settings = {} if settings == ""
            if settings[:inherit_tracker_id] #inherit tracker
              attrs[:tracker_id] = parent_issue.tracker
            else #use default subtask tracker
              default_tracker = Tracker.find_by_id(settings[:default_tracker_id] || 0) || parent_issue.tracker
              default_tracker = parent_issue.tracker unless @project.trackers.include? default_tracker
              attrs[:tracker_id] = default_tracker
            end
            attrs[:fixed_version_id] = parent_issue.fixed_version_id if settings[:inherit_fixed_version_id]
            attrs[:category_id] = parent_issue.category_id if settings[:inherit_category_id]
            attrs[:assigned_to_id] = parent_issue.assigned_to_id if settings[:inherit_assigned_to_id]
            attrs[:priority_id] = parent_issue.priority_id if settings[:inherit_priority_id]
            attrs[:start_date] = parent_issue.start_date if settings[:inherit_start_date]
            attrs[:due_date] = parent_issue.due_date if settings[:inherit_due_date]
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
          end

          if params[:project_id]
            redirect_to new_project_issue_path(@issue.project, :issue => attrs)
          else
            attrs.merge! :project_id => @issue.project_id
            redirect_to new_issue_path(:issue => attrs)
          end
        else
          redirect_to issue_path(@issue)
        end
      end
    end

    def self.included(receiver)
      receiver.send :include, InstanceMethods
 
      receiver.class_eval do
        unloadable
        alias_method :redirect_after_create, :redirect_after_create_plugin
      end
    end
  end
end

unless IssuesController.included_modules.include?(SubtasksInheritedFields::IssuesControllerPatch)
  #puts "Including module into IssuesController"
  IssuesController.send(:include, SubtasksInheritedFields::IssuesControllerPatch)
end

