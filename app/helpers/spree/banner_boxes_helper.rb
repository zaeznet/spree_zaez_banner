module Spree
  module BannerBoxesHelper

    # Monta o banner om os atributos passados
    #
    # Os atributos disponíveis são:
    #   category {default: 'home'}
    #     nome da categoria dos banners que serão exibidos
    #   class {default: ''}
    #     classe a ser inserida no container do carrossel
    #   style {default: [salvo em Spree::BannerConfig.default_style]}
    #     tamanho das imagens
    #   carousel_id {default: 'carousel'}
    #     id do carousel
    #   buttons_carousel {default: true}
    #     botões de controle do carrossel habilitado/desabilitado
    #   buttons_class {default: 'carousel-control'}
    #     classes para os botões de controle do carrossel
    #   indicators_carousel {default: true}
    #     indicadores dos banners habilitados/desabilitados
    #   image_class {default: ''}
    #     classes para serem inseridas na imagem
    #
    def insert_banner_box(params={})
      params[:category] ||= 'home'
      params[:style] ||= Spree::BannerConfig[:banner_default_style]
      params[:carousel_id] ||= 'carousel'
      params[:buttons_carousel] ||= true
      params[:buttons_class] ||= 'carousel-control'
      params[:indicators_carousel] ||= true

      @banners = Spree::BannerBox.enabled(params[:category]).order(:position)
      return '' if @banners.empty?

      render :partial => 'spree/shared/banner_box', locals: { banners: @banners, params: params }
    end

  end
end
