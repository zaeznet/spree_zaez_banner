module Spree
  module Admin
    class BannerBoxesController < ResourceController
      
      def index
        respond_with(@collection)
      end
      
      def show
        redirect_to( :action => :edit )
      end
      
      def update
        @banner_box.enhance_settings
        super
      end

      def clone
        @new = @banner_box.duplicate

        if @new.save
          flash.notice = I18n.t('notice_messages.banner_box_cloned')
        else
          flash.notice = I18n.t('notice_messages.banner_box_not_cloned')
        end

        respond_with(@new) { |format| format.html { redirect_to edit_admin_banner_box_url(@new) } }
      end
      
      protected

      def find_resource
        Spree::BannerBox.find(params[:id])
      end
      
      def location_after_save
         admin_banner_boxes_url
      end
      
      def collection
        return @collection if @collection.present?
        params[:q] ||= {}

        params[:q][:s] ||= 'position asc'
        @collection = super

        @q = @collection.ransack(params[:q])
        @collection = @q.result
        @collection
      end

      def model_class
        Spree::BannerBox
      end
    end
  end
end
