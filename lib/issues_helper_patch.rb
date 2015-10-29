
module SubtasksInheritedFields
  module IssuesHelperPatch
    module InstanceMethods
      
      # Returns a link for adding a new subtask to the given issue
      def link_to_new_subtask_plugin(issue)
        attrs = SubtasksInheritedFields::Helpers.inherit_attrs(issue)
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

