module AutoWatchersFromGroups

	class Hooks < Redmine::Hook::ViewListener

		def controller_issues_new_after_save(context)
			auto_watchers(context)
		end

		def controller_issues_edit_before_save(context)
			auto_watchers(context)
		end

		def auto_watchers(context)
			@settings ||= Setting.plugin_redmine_auto_watchers_from_groups
			if context[:params][:issue]
				 if @settings['groups_enabled'].include? context[:params][:issue][:assigned_to_id]
				 	@issue = Issue.find context[:issue]
				 	@group = Group.find(context[:params][:issue][:assigned_to_id])
				 	@group.users.each do |new_watcher|
					Watcher.create(:watchable => @issue, :user => new_watcher)
			    	end
				 end 
			end
		end

		alias_method :controller_issues_bulk_edit_before_save, :controller_issues_edit_before_save

	end

end