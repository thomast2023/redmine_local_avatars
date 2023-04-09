module RedmineLocalAvatars
    module AvatarManagement
        included do
            helper :attachments
            include AttachmentsHelper
        end
      def save_or_delete_avatar
        # clear the attachments. Then, save if
        # we have to delete. Otherwise add the new
        # avatar and then save
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
  