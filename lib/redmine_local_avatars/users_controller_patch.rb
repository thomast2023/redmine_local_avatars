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

module RedmineLocalAvatars
	module UsersControllerPatch
	  extend ActiveSupport::Concern
  
	  included do
		helper :attachments
		include AttachmentsHelper
		include AvatarManagement
	  end
  
	  def get_avatar
		@user = User.find(params[:id])
		avatar = @user.attachments.find_by_description('avatar')
		if avatar
		  send_data avatar.diskfile, filename: avatar.filename, type: avatar.content_type, disposition: 'inline'
		else
		  head :ok
		end
	  end
	  
  
	  def save_avatar
		@user = User.find(params[:id])
  
		begin
		  save_or_delete # see the LocalAvatars module
		rescue
		  flash[:error] = @possible_error
		end
		redirect_to :action => 'edit', :id => @user
	  end
	end
  end
  
  # Apply the patch to the UsersController
  UsersController.send(:include, RedmineLocalAvatars::UsersControllerPatch)
  