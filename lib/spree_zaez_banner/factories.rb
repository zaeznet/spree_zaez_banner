FactoryGirl.define do
  factory :banner_box, class: Spree::BannerBox do
    category 'home'
    url 'http://localhost:3000'
    enabled true
    attachment { File.new(Rails.root + '../../spec/fixtures/spree.jpg') }
  end
end