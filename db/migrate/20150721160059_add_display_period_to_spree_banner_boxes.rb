class AddDisplayPeriodToSpreeBannerBoxes < ActiveRecord::Migration
  def change
    add_column :spree_banner_boxes, :begin_display, :date
    add_column :spree_banner_boxes, :end_display, :date
  end
end
