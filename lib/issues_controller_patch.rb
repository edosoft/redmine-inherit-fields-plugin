
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
            attrs = SubtasksInheritedFields::Helpers.inherit_attrs(parent_issue)
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

