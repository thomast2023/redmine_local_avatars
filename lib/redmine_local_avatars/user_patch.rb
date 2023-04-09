module RedmineLocalAvatars
    module UserPatch
      extend ActiveSupport::Concern
  
      included do
        acts_as_attachable
        has_many :attachments, as: :container, dependent: :destroy
      end
    end
  end
  
  User.send(:include, RedmineLocalAvatars::UserPatch)
  