# Modelo base para os estilos de banners
class window.BannerBoxStyle

  # Callback disparado após a execução
  # do constructor de uma classe
  afterConstructor: (style) ->

  # Callback disparado antes da execução
  # do constructor de uma classe
  beforeConstructor: (style) ->

  # Constructor da classe
  constructor: (@style) ->
    @beforeConstructor @style
    @setAttributes @style
    @afterConstructor @style

  # Seta os attributos do estilo passado
  # no construtor
  # @param style Object
  setAttributes: (@style) ->
    @text = @style.text
    @value = @style.value