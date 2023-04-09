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
require_dependency 'redmine_local_avatars/application_helper_patch'

Redmine::Plugin.register :redmine_local_avatars do
  name 'Redmine Local Avatars plugin'
  author 'Andrew Chaika and Luca Pireddu'
  author_url 'https://github.com/ncoders/redmine_local_avatars'
  description 'This plugin lets users upload avatars directly into Redmine'
  version '1.0.6'
end

receiver = ActiveSupport::Reloader.to_prepare do
  require_dependency 'project'
  require_dependency 'principal'
  require_dependency 'user'
  
  helper_klass = ApplicationHelper.method_defined?(:avatar) ? ApplicationHelper : AvatarsHelper
  
  AccountController.send(:include, LocalAvatarsPlugin::AccountControllerPatch)
  helper_klass.send(:include, LocalAvatarsPlugin::ApplicationAvatarPatch)
  MyController.send(:include, LocalAvatarsPlugin::MyControllerPatch)
  User.send(:include, LocalAvatarsPlugin::UsersAvatarPatch)
  UsersController.send(:include, LocalAvatarsPlugin::UsersControllerPatch)
  UsersHelper.send(:include, LocalAvatarsPlugin::UsersHelperPatch)
  ApplicationHelper.send(:include, RedmineLocalAvatars::ApplicationHelperPatch)
  end
