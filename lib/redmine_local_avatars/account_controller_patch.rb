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
	module AccountControllerPatch
	  def self.included(base) # :nodoc:
		base.class_eval do
		  helper :attachments
		  include AttachmentsHelper
		end
  
		base.send(:include, InstanceMethods)
	  end
  
	  module InstanceMethods
		def get_avatar
		  @user = User.find(params[:id])
		  send_avatar(@user)
		end
  
		# Move the send_avatar method from the LocalAvatars module to this InstanceMethods module
		def send_avatar(user)
		  if user.avatar.nil?
			render_404
		  else
			# Make sure the user has access to the image.
			if Redmine::VERSION::MAJOR < 4
			  if !visible?(user)
				render_404
				return
			  end
			else
			  if !user.active? || !user.visible?
				render_404
				return
			  end
			end
  
			# Send the file to the user.
			send_file user.avatar.diskfile, :filename => filename_for_content_disposition(user.avatar.filename),
											 :type => user.avatar.content_type,
											 :disposition => 'inline'
		  end
		end
	  end
	end
  end
  