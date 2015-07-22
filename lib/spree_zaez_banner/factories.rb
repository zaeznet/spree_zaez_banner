FactoryGirl.define do
  factory :banner_box, class: Spree::BannerBox do
    category 'home'
    url 'http://localhost:3000'
    enabled true
    attachment { File.new(Spree::Core::Engine.root + 'spec/fixtures' + 'thinking-cat.jpg') }
  end
end