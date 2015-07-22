module Spree
  class BannerBox < ActiveRecord::Base

    has_attached_file :attachment,
                      styles: Spree::BannerConfig[:banner_styles].symbolize_keys!,
                      default_style: Spree::BannerConfig[:banner_default_style].to_sym,
                      url: Spree::BannerConfig[:banner_url],
                      path: Spree::BannerConfig[:banner_path],
                      convert_options: { all: '-strip -auto-orient -colorspace sRGB' }
    validates_attachment :attachment,
                         :presence => true,
                         :content_type => { :content_type => %w(image/jpeg image/jpg image/png image/gif) }

    # save the w,h of the original image (from which others can be calculated)
    # we need to look at the write-queue for images which have not been saved yet
    after_post_process :find_dimensions

    validates_presence_of :category

    scope :enabled, lambda { |*categories|
                    if categories.empty?
                      where(:enabled => true).where('begin_display IS NULL OR begin_display <= :d) AND (end_display IS NULL OR end_display >= :d', d: Date.today)
                    else
                      where(:enabled => true)
                          .where('begin_display IS NULL OR begin_display <= :d) AND (end_display IS NULL OR end_display >= :d', d: Date.today)
                          .where(:category => categories)
                    end
                  }

    # for adding banner_boxes which are closely related to existing ones
    # define "duplicate_extra" for site-specific actions, eg for additional fields
    def duplicate
      enhance_settings
      p = self.dup
      p.category = 'COPY OF ' + category
      p.created_at = p.updated_at = nil
      p.url = url
      p.attachment = attachment

      # allow site to do some customization
      p.send(:duplicate_extra, self) if p.respond_to?(:duplicate_extra)
      p.save!
      p
    end

    def find_dimensions
      temporary = attachment.queued_for_write[:original]
      filename = temporary.path unless temporary.nil?
      filename = attachment.path if filename.blank?
      geometry = Paperclip::Geometry.from_file(filename)
      self.attachment_width  = geometry.width
      self.attachment_height = geometry.height
    end

    def enhance_settings
      Spree::BannerBox.attachment_definitions[:attachment][:styles] = Spree::BannerConfig[:banner_styles].symbolize_keys!
      Spree::BannerBox.attachment_definitions[:attachment][:path] = Spree::BannerConfig[:banner_path]
      Spree::BannerBox.attachment_definitions[:attachment][:url] = Spree::BannerConfig[:banner_url]
      Spree::BannerBox.attachment_definitions[:attachment][:default_url] = Spree::BannerConfig[:banner_default_url]
      Spree::BannerBox.attachment_definitions[:attachment][:default_style] = Spree::BannerConfig[:banner_default_style].to_sym
    end

    def self.categories_for_select
      unscoped.pluck(:category).uniq.sort
    end

  end
end