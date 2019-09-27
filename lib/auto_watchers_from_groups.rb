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
			@issue = Issue.find context[:issue][:id]

			if context[:params][:issue]
				if context[:params][:issue][:assigned_to_id].blank?
					# group assign with category default assignee
					@project = context[:params][:project_id]
					@project = context[:params][:issue][:project_id] if context[:params][:issue][:project_id]
					unless context[:params][:issue][:category_id].blank?
						if context[:params][:commit] == "Create"
							if @settings['groups_enabled'].include? group_id = Project.find(@project).issue_categories.find_by_id(context[:params][:issue][:category_id]).assigned_to_id.to_s
								group = Group.find group_id
							end
						end
					end
				elsif @settings['groups_enabled'].include? context[:params][:issue][:assigned_to_id]
					# normal group assign
					group = Group.find context[:params][:issue][:assigned_to_id]
				end

				unless group.nil?
					group.users.each do |new_watcher|
						Watcher.create(:watchable => @issue, :user => new_watcher)
					end
				end

			end

		end

		alias_method :controller_issues_bulk_edit_before_save, :controller_issues_edit_before_save

	end

end
