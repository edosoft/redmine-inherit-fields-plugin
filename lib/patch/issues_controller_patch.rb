require_dependency 'issues_controller'

module  Patch
  module IssuesControllerPatch
    def self.included(base)
      base.extend(ClassMethods)
      base.send(:include, InstanceMethods)
      base.class_eval do
       after_filter  :update_version, :only=>[:update]
        #alias_method_chain :issue_list, :order
      end
    end
  end
  module ClassMethods
  end

  module InstanceMethods
    private
    def update_version
      version_changed = @issue.journals.last(1).map(&:details).flatten.select{|d| d.prop_key== "fixed_version_id" }
      if version_changed.any?
        children = @issue.children
        loop_update_version_child(children, @issue)if children.any?
      end
    end
    def loop_update_version_child(children, issue)
      children.each do |child|
        child.update_attributes!(:fixed_version_id=> issue.fixed_version_id)
        sub_children = child.children
        loop_update_version_child(sub_children, issue) if sub_children.any?
      end
    end
  end
end