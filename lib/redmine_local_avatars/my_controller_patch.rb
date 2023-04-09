# Redmine Local Avatars plugin
#
# Copyright (C) 2010	Andrew Chaika, Luca Pireddu
# 
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.	See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA	 02110-1301, USA.

module RedmineLocalAvatars
	module MyControllerPatch
	  extend ActiveSupport::Concern
  
	  included do
		helper :attachments
		include AttachmentsHelper
		include AvatarManagement
	  end
  
	  def show_avatar
		@user = User.current || User.anonymous
		logger.debug("MyController User: #{@user}")
	  end
  
	  def save_avatar
		@user = User.current
		begin
		  save_or_delete_avatar # Call the method from UsersControllerPatch
		  redirect_to :action => 'account', :id => @user
		rescue => e
		  $stderr.puts("save_or_delete_avatar raised an exception. exception: #{e.class}: #{e.message}")
		  flash[:error] = @possible_error || e.message
		  redirect_to :action => 'show_avatar'
		end
	  end
	end
  end
  
  # Apply the patch to the MyController
  MyController.send(:include, RedmineLocalAvatars::MyControllerPatch)
  