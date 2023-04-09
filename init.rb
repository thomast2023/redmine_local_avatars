# Redmine Local Avatars plugin
#
# Copyright (C) 2010  Andrew Chaika, Luca Pireddu
# 
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

require 'redmine'
require_dependency File.expand_path('../lib/redmine_local_avatars/hooks', __FILE__)

Redmine::Plugin.register :redmine_local_avatars do
  name 'Redmine Local Avatars plugin'
  author 'Andrew Chaika and Luca Pireddu'
  author_url 'https://github.com/ncoders/redmine_local_avatars'
  description 'This plugin lets users upload avatars directly into Redmine'
  version '1.0.6'
end

Rails.configuration.to_prepare do
  [
    'account_controller_patch',
    'application_helper_avatar_patch',
    'my_controller_patch',
    'users_avatar_patch',
    'users_controller_patch',
    'users_helper_avatar_patch'
  ].each do |patch|
    require_dependency File.expand_path("../lib/redmine_local_avatars/#{patch}", __FILE__)
  end
  

  class RedmineLocalAvatars::Hooks < Redmine::Hook::ViewListener
    render_on :view_my_account_contextual, :partial => 'hooks/redmine_local_avatars/view_my_account_contextual'
  end  
end
