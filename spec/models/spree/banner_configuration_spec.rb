require 'spec_helper'

describe Spree::BannerConfiguration do

  let(:object) { subject.class.new }

  [:banner_default_url, :banner_path, :banner_url, :banner_styles, :banner_default_style].each do |preference|
    it "should have the #{preference} preference" do
      expect(object.has_preference?(preference)).to be true
    end
  end
end