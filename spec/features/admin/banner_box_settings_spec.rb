require 'spec_helper'

describe 'Banner Box Settings', type: :feature do
  before { create_admin_in_sign_in }

  context 'visit Banner Box settings' do
    it 'should be a link to Banner Box settings' do
      within('.sidebar') { page.find_link('Banner Box Settings')['/admin/banner_box_settings/edit'] }
    end
  end

  context 'show Banner Box settings' do
    it 'should has the preferences of Banner Box', js: true do
      visit spree.edit_admin_banner_box_settings_path

      expect(page).to have_selector '#preferences_banner_path'
      expect(page).to have_selector '#preferences_banner_default_url'
      expect(page).to have_selector '#preferences_banner_url'
      expect(page).to have_selector '#preferences_banner_default_style'
    end
  end

  context 'edit Banner Box settings' do
    before { visit spree.edit_admin_banner_box_settings_path }

    it 'should update the preferences', js: true do
      fill_in 'Banner Path', with: 'test'
      click_button 'Update'

      expect(Spree::BannerConfig.banner_path).to eq 'test'
      expect(find_field('preferences_banner_path').value).to eq 'test'

      # set default
      Spree::BannerConfig.banner_path = ':rails_root/public/spree/banners/:id/:style/:basename.:extension'
    end

    it 'should create a banner style', js: true do
      click_link 'Add New Banner Style'
      fill_in 'Style Name', with: 'test'
      fill_in 'Value', with: '10x10'
      click_icon :ok

      expect(page).to have_text 'TEST'
      expect(page).to have_selector '#banner_styles_test'
    end
  end
end