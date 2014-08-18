require 'redmine'

require_dependency 'auto_watchers_from_groups'

Redmine::Plugin.register :redmine_auto_watchers_from_groups do
  name 'Redmine Auto Watchers From Groups plugin'
  author 'Alexander Kuznecov'
  description 'Automatically add group members as issue watchers on group assignment'
  version '0.0.1'
  #url 'http://example.com/path/to/plugin'
  author_url 'http://about.me/akuznecov'

  settings :default => {
    'groups_enabled' => []
  }, :partial => 'settings/auto_watchers_from_groups'
end