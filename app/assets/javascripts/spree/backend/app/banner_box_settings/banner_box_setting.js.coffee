#= require_self
#= require ./banner_box_style

class window.BannerBoxSetting

  # Callback disparado após a execução
  # do constructor de uma classe
  afterConstructor: ->

  # Callback disparado antes da execução
  # do constructor de uma classe
  beforeConstructor: ->

  # Constructor da classe
  constructor: (defaultExecution = true) ->
    do @beforeConstructor
    do @defaultExecution if defaultExecution
    do @afterConstructor

  # Execucao padrao da classe
  defaultExecution: ->
    do @setVariables
    do @setEvents

  # Exibe o formulario para insercao de um novo estilo
  addNewStyle: (e) ->
    e.preventDefault()
    @add_new_style_button.attr('disabled', true)
    object = {translations: {text: 'Text', value: 'Value'}}
    rendered = @add_new_style_template {new_style: object}
    @banner_styles_container.append(rendered)
    $('.new_banner_style_form').click (e) => @addNewStyleToList(e)

  # Adiciona um novo estilo de banner a lista de estilos
  addNewStyleToList: (e) ->
    e.preventDefault()
    # validar
    params =
      text: $('#new_banner_styles_name').val()
      value: $('#new_banner_styles_value').val()
    banner_style = new BannerBoxStyle($.extend({}, params))
    rendered = @banner_style_template {new_style: banner_style}
    $('#banner_style_form').remove()
    @banner_styles_container.append(rendered)
    $("#preferences_banner_default_style").append("<option value='#{params.text}'>#{params.text}</option>")
    @add_new_style_button.attr('disabled', false)

  destroyStyle: (e) ->
    e.preventDefault()
    style = e.target.parentElement.dataset['value']
    $("#banner_style_#{style}").remove()
    $("#preferences_banner_default_style option[value='#{style}']").remove()

  # Seta os eventos do formulario
  setEvents: ->
    @destroy_button.click (e) => @destroyStyle(e)
    @add_new_style_button.on 'click', $.proxy(@addNewStyle, @)

  # Seta as variaveis utilizadas
  setVariables: ->
    @destroy_button          = $ '.destroy_banner_style'
    @add_new_style_button    = $ '.add_new_banner_style'
    @banner_styles_container = $ '#banner_styles'
    @add_new_style_template  = Handlebars.compile $('#new_banner_style_template').html()
    @banner_style_template   = Handlebars.compile $('#banner_style_template').html()