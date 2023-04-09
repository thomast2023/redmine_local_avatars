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
  
	  	def self.included(base) # :nodoc:
			base.class_eval do
				helper :attachments
				include AttachmentsHelper
		
				include InstanceMethods
			end
		end
  
		module InstanceMethods
			def get_avatar
				@user = User.find(params[:id])
				send_avatar(@user)
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
		
			def save_or_delete
				# clear the attachments.  Then, save if 
				# we have to delete.  Otherwise add the new
				# avatar and then save
				# TODO:  This doesn't play nice with any other possible
				# attachments on the user (just because there aren't any
				# now doesn't mean there won't be in the future.  It should
				# be changed to only remove an attachment with description == 'avatar'
				@user.attachments.clear
				if params[:commit] == l(:button_delete) then
					@possible_error = l(:unable_to_delete_avatar)
					@user.save!
					flash[:notice] = l(:avatar_deleted)
				else # take anything else as save
					file_field = params[:avatar]
					Attachment.attach_files(@user, {'first' => {'file' => file_field, 'description' => 'avatar'}})
					@possible_error = l(:error_saving_avatar)
					@user.save!
					flash[:notice] = l(:message_avatar_uploaded)
				end
			end
		end
	end
end


