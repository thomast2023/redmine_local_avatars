module RedmineLocalAvatars
    module AvatarManagement
      def save_or_delete_avatar
        avatar = Attachment.where(container_id: @user.id, container_type: 'Principal', description: 'avatar').first
  
        # Delete existing avatar if exists
        if avatar
          @possible_error = l(:unable_to_delete_avatar)
          avatar.destroy
          flash[:notice] = l(:avatar_deleted)
        end
  
        # If not deleting, save new avatar
        unless params[:commit] == l(:button_delete)
          file_field = params[:avatar]
          attachment = Attachment.create!(
            file: file_field,
            author: @user,
            container_id: @user.id,
            container_type: 'Principal',
            description: 'avatar'
          )
          @possible_error = l(:error_saving_avatar)
          flash[:notice] = l(:message_avatar_uploaded)
        end
      rescue => e
        flash[:error] = @possible_error || e.message
      end
    end
  end
  
  