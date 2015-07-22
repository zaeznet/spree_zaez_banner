require 'spec_helper'

describe Spree::BannerBox do
  let(:banner) { FactoryGirl.build(:banner_box) }

  context 'validate banner' do
    it 'should be invalid if category is null' do
      banner.category = nil
      expect(banner.invalid?).to be true
      expect(banner.errors.full_messages).to include("Category can't be blank")
    end

    it 'should be invalid if attachment is null' do
      banner.attachment = nil
      expect(banner.invalid?).to be true
      expect(banner.errors.full_messages).to include("Attachment can't be blank")
    end
  end

  it 'should be able duplicate the banner' do
    new_banner = banner.duplicate
    expect(new_banner.category).to eq 'COPY OF home'
    expect(new_banner.url).to eq 'http://localhost:3000'
    expect(new_banner.attachment).to eq banner.attachment
  end

  it 'should return the categories for select' do
    create(:banner_box, category: 'cart')
    create(:banner_box, category: 'product')
    expect(subject.class.categories_for_select).to eq %w(cart product)
  end

  context 'scoping enabled' do
    it 'should return only enabled banners' do
      create(:banner_box, category: 'product', enabled: false)
      create(:banner_box, category: 'home')
      expect(subject.class.enabled.count).to eq 1
    end

    it 'should return the banners enabled without category defined' do
      create(:banner_box, category: 'product')
      create(:banner_box, category: 'home')
      expect(subject.class.enabled.count).to eq 2
    end

    it 'should return the banners with the category passed' do
      create(:banner_box, category: 'product')
      create(:banner_box, category: 'home')
      expect(subject.class.enabled('product').count).to eq 1
    end

    it 'should return the banners with display period between the current date' do
      create(:banner_box, category: 'product', end_display: (Date.today - 2.days))
      create(:banner_box, category: 'home')
      expect(subject.class.enabled.count).to eq 1
    end
  end
end