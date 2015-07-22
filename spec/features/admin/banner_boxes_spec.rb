require 'spec_helper'

describe 'Banner Boxes', type: :feature do

  before { create_admin_in_sign_in }

  context 'visit Banner Box' do
    it 'should be a link to Banner Box' do
      within('.sidebar') { page.find_link('Banner Box')['/admin/banner_boxes'] }
    end

    it 'should show a message if there are not any banners', js: true do
      visit spree.admin_banner_boxes_path

      expect(page).to have_text 'No Results'
    end

    it 'should show the data of banner boxes', js: true do
      create(:banner_box)
      visit spree.admin_banner_boxes_path

      expect(page).to have_text 'home'
      expect(page).to have_text 'http://localhost:3000'
    end

    context 'searching' do
      before do
        create(:banner_box)
        create(:banner_box, category: 'product', url: 'google.com', enabled: false)
        visit spree.admin_banner_boxes_path
      end

      it 'should search by category', js: true do
        select2 'product', from: 'Category'
        click_button 'Filter Results'

        within_row(1) do
          expect(page).to have_content('product')
        end
        within('table#listing_banner_boxes') { expect(page).not_to have_content('home') }
      end

      it 'should search by url', js: true do
        fill_in 'URL', with: 'google.com'
        click_button 'Filter Results'

        within_row(1) do
          expect(page).to have_content('product')
        end
        within('table#listing_banner_boxes') { expect(page).not_to have_content('home') }
      end

      it 'should search only enables', js: true do
        check 'Show Only Enabled'
        click_button 'Filter Results'

        within_row(1) do
          expect(page).to have_content('home')
        end
        within('table#listing_banner_boxes') { expect(page).not_to have_content('product') }
      end
    end
  end

  context 'create Banner Box' do
    it 'should create a banner box', js: true do
      visit spree.admin_banner_boxes_path
      click_link 'New Banner Box'

      fill_in 'Category', with: 'test'
      fill_in 'URL', with: 'http://localhost'
      fill_in 'Alternative Text', with: 'Test'
      fill_in 'Begin Display', with: '2015/07/21'
      fill_in 'End Display', with: '2015/07/22'
      attach_file('Attachment', Spree::Core::Engine.root + 'spec/fixtures' + 'thinking-cat.jpg')
      click_button 'Create'

      banner = Spree::BannerBox.last
      expect(banner.category).to eq 'test'
      expect(banner.url).to eq 'http://localhost'
      expect(banner.alt_text).to eq 'Test'
      expect(banner.begin_display).to eq Date.parse('2015/07/21')
      expect(banner.end_display).to eq Date.parse('2015/07/22')

      within_row(1) do
        expect(page).to have_content('test')
      end
    end
  end

  context 'edit Banner Box' do
    it 'should be possible edit a banner box', js: true do
      create(:banner_box)
      visit spree.admin_banner_boxes_path
      click_icon :edit

      fill_in 'End Display', with: '2015/07/22'
      click_button 'Update'

      expect(page).to have_text 'Banner box has been successfully updated!'
      expect(Spree::BannerBox.last.end_display).to eq Date.parse('2015/07/22')
    end
  end

  context 'clone Banner Box' do
    it 'should be possible clone a banner box', js: true do
      create(:banner_box)
      visit spree.admin_banner_boxes_path
      click_icon :clone

      expect(page).to have_text 'Banner has been cloned'
      expect(Spree::BannerBox.count).to eq 2
    end
  end

  context 'Delete Banner Box' do
    it 'should be possible delete a banner box', js: true do
      create(:banner_box)
      visit spree.admin_banner_boxes_path
      click_icon :delete
      # page.driver.browser.switch_to.alert.accept

      expect(page).to have_selector('table tbody tr', count: 0)
    end
  end
end