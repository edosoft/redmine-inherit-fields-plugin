require_dependency 'issues_controller'

module  Patch
  module IssuesControllerPatch
    def self.included(base)
      base.extend(ClassMethods)
      base.send(:include, InstanceMethods)
      base.class_eval do
       after_filter  :update_version, :only=>[:update]
       after_filter  :update_versions, :only=>[:bulk_update]
        #alias_method_chain :issue_list, :order
      end
    end
  end
  module ClassMethods
  end

  module InstanceMethods
    private
    def update_versions
      if @issues.any?
        @issues.each do |issue|
          update_issue_version(issue)
        end
      end
    end

    def update_version
      update_issue_version(@issue)
    end

    def update_issue_version(issue)

      cf = CustomValue.where("customized_type= 'Project' and custom_field_id= 36").where(customized_id: issue.project.id)
      if cf.present? and cf.first.value == "1"
        version_changed = issue.journals.last(1).map(&:details).flatten.select{|d| d.prop_key == "fixed_version_id" }
        if version_changed.any?
          children = issue.children
          loop_update_version_child(children, issue) if children.any?
        end
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