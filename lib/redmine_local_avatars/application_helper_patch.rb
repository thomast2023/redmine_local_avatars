module RedmineLocalAvatars
  module ApplicationHelperPatch
    extend ActiveSupport::Concern

    included do
      alias_method :avatar_without_local, :avatar
      alias_method :avatar, :avatar_with_local
    end

    def avatar_with_local(user, options = {})
      puts "avatar_with_local: #{user}"
      if user.is_a?(User)
        av = user.attachments.find_by_description 'avatar'
        if av
          image_url = url_for :only_path => true, :controller => 'users', :action => 'get_avatar', :id => user
          options[:size] = "64" unless options[:size]
          title = "#{user.name}"
          return "<img class=\"gravatar\" title=\"#{title}\" width=\"#{options[:size]}\" height=\"#{options[:size]}\" src=\"#{image_url}\" />".html_safe
        end
      end
      avatar_without_local(user, options)
    end
  end
end
