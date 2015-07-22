module Spree
  module Admin
    class BannerBoxSettingsController < Spree::Admin::BaseController

      def show
        redirect_to( :action => :edit )
      end

      # def create
      #   update_paperclip_settings
      #   # @styles = Spree::BannerConfig[:banner_styles]
      #   @config = Spree::BannerConfig.new
      #   super
      # end

      def edit
        @config = Spree::BannerConfiguration.new
      end

      def update
        Spree::BannerConfig.set(params[:preferences])

        update_banner_style
        update_paperclip_settings

        respond_to do |format|
          format.html {
            flash[:notice] = Spree.t(:banner_settings_updated)
            redirect_to edit_admin_banner_box_settings_path
          }
        end
      end

      private

      def update_banner_style
        collection = {}
        params[:banner_styles].each do |key, value|
          collection[key.to_sym] = value
        end
        Spree::BannerConfig.banner_styles = collection
      end

      def update_paperclip_settings
        Spree::BannerBox.attachment_definitions[:attachment][:styles] = Spree::BannerConfig[:banner_styles].symbolize_keys!
        Spree::BannerBox.attachment_definitions[:attachment][:path] = Spree::BannerConfig[:banner_path]
        Spree::BannerBox.attachment_definitions[:attachment][:default_url] = Spree::BannerConfig[:banner_default_url]
        Spree::BannerBox.attachment_definitions[:attachment][:default_style] = Spree::BannerConfig[:banner_default_style].to_sym
      end
    end
  end
end
