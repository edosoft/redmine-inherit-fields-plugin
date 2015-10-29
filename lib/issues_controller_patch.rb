
module SubtasksInheritedFields
  module IssuesControllerPatch
    module InstanceMethods

      #redefine create method to call our redirect_after_create
      def create_plugin
        call_hook(:controller_issues_new_before_save, { :params => params, :issue => @issue })
        @issue.save_attachments(params[:attachments] || (params[:issue] && params[:issue][:uploads]))
        if @issue.save
          call_hook(:controller_issues_new_after_save, { :params => params, :issue => @issue})
          respond_to do |format|
            format.html {
              render_attachment_warning_if_needed(@issue)
              flash[:notice] = l(:notice_issue_successful_create, :id => view_context.link_to("##{@issue.id}", issue_path(@issue), :title => @issue.subject))
              redirect_after_create #redirect after create inheriting subtask fields
            }
            format.api  { render :action => 'show', :status => :created, :location => issue_url(@issue) }
          end
          return
        else
          respond_to do |format|
            format.html { render :action => 'new' }
            format.api  { render_validation_errors(@issue) }
          end
        end
      end

      # Redirects user after a successful issue creation with inheritance
      def redirect_after_create
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
        alias_method :create, :create_plugin
      end
    end
  end
end

unless IssuesController.included_modules.include?(SubtasksInheritedFields::IssuesControllerPatch)
  #puts "Including module into IssuesController"
  IssuesController.send(:include, SubtasksInheritedFields::IssuesControllerPatch)
end

