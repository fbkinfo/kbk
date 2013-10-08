$ -> new Documents

class Documents
  constructor: ->
    @setupCauseFormat()
    @setupViewer()
    @setupSelectsDependence()
    @setupCreatableSelects()

    @setupSnapshotsUploadAndSort()

    @setupFinalToggler()
    @setupRelatedWarning()
    @setupDeleteInstructions()
    @setupSnapshotValidation()
    @setupSnapshotEditor()

    @setupAttachements()
    @setupSnapshotAndAttachementRemove()

  setupViewer: ->
    $(".document-snapshot-preview").fancybox()

  setupSnapshotValidation: ->
    form = $(".is-document-form form")
    showError = ->
      $("@aside-validation-error").show()
      $('html, body').animate({scrollTop: 0}, 400)

    form.submit ->
      uploadItems = $("@list-item")
      if uploadItems.length == 0
        showError()
        false
      else
        true

  setupSelectsDependence: ->
    investigationSelect = $('#document_investigation_id')
    return if investigationSelect.length == 0

    causeSelect = $('#document_cause_id')[0].selectize

    toggleRenewInvestigationPublish = (visible)->
      $("@document-renew-investigation-publish").toggle(visible)

    investigationPublished = $('form.edit_document').data('investigation-published')
    unless investigationPublished
      toggleRenewInvestigationPublish(false)

    investigationSelect.change =>
      id = $('form.edit_document').data('document')
      investigationId = investigationSelect.val()

      realId = parseInt(investigationId).toString() == investigationId

      if investigationId && realId
        $.get "/investigations/#{investigationId}.json", (result) ->
          toggleRenewInvestigationPublish(!!result.published_until)

          docs = []
          $.each result.documents, (i, d)->
            docs.push({value: d.id, text: d.title}) if d.id != id

          causeSelect.clearOptions()
          causeSelect.load (callback)->
            callback(docs)

      else
        causeSelect.clearOptions

  setupCreatableSelects: ->
    $.each ['#document_organization_id', '#document_investigation_id', '#document_author_id'], (i, e) ->
      $.selectify e,
        multiple: false
        create: true

  setupCauseFormat: ->
    format = (data) ->
      return null if data.text.length == 0

      kind = $(data.element).data('kind')
      date = $(data.element).data('date')

      "<i>#{Date.create(date).format('{d}.{M}.{yy}')}</i>" +
      "<img src='/assets/icons/doc_#{kind}_gray.png' />" +
      data.text.truncate(45)

    $.selectify '#document_cause_id',
      formatSelection: format
      formatResult: format

  setupSnapshotAndAttachementRemove: ->
    lists = [{
      selector: '@snapshots-list',
      ids: '.document-snapshot-ids'
    },
    {
      selector: '@attachements-list',
      ids: '.document-attachement-ids'
    }]
    $.each lists, (i, list)->
      $(list.selector).on 'ajax:success', '@remove-link', ->
        item = $(@).closest('@list-item')
        ids = $(list.ids).find("input[value=#{item.data('id')}]").remove()
        item.fadeOut(-> $(@).remove())

      $(list.selector).on 'ajax:error', '@remove-link', ->
        alert "У документа должен быть хотя бы один скан или вложение"

  # TODO: Split further
  setupSnapshotsUploadAndSort: ->
    snapshotsIds    = $('.document-snapshot-ids')
    snapshotsPane   = $('.document-snapshots-list')
    return if snapshotsPane.length == 0

    container       = $('.document-form-side')
    progressPane    = $('.document-snapshots-progress')
    progressText    = progressPane.find('i')
    actionsPane     = container.find('.actions').eq(0)

    url = if doc = container.data('document')
      "/documents/#{doc}/snapshots"
    else
      "/snapshots"

    uploader = new plupload.Uploader
      container: 'snapshot_upload_box'
      runtimes: 'gears,html5,flash,silverlight,browserplus'
      browse_button: 'attach'
      url: url
      filters : [
        {title : "", extensions : "jpg,jpeg,png,pdf"},
      ]

    uploader.init()

    uploader.bind 'FilesAdded', (up, files) ->
      up.refresh()
      uploader.start()
      progressPane.show()
      progressText.text('0%')
      actionsPane.hide()

    uploader.bind 'UploadProgress', (up, file) ->
      status = if up.total.percent == 100
        "#{file.name} (в обработке)"
      else
        "#{file.name} (#{plupload.formatSize file.size}) #{up.total.percent}%"

      progressText.text(status)


    uploader.bind 'FileUploaded', (up, file, response) ->
      snapshotsPane.append $(response.response)
      for el in $(response.response)
        snapshotsIds.append $('<input/>').attr('type', 'hidden')
          .attr('name', 'document[snapshot_ids][]')
          .val $(el).attr('data-id')

    uploader.bind 'UploadComplete', (up) ->
      progressText.text("100%")
      progressPane.hide()
      actionsPane.show()

    snapshotsPane.sortable
      update: (e, ui) -> $.post "/snapshots/sort", snapshotsPane.sortable('serialize')

  setupAttachements: ->
    attachementsIds    = $('.document-attachement-ids')
    attachementsPane   = $('.document-attachements-list')
    return if attachementsPane.length == 0

    container       = $('.document-form-side')
    progressPane    = $('.document-attachements-progress')
    progressText    = progressPane.find('i')
    actionsPane     = container.find('.actions').eq(1)

    url = if doc = container.data('document')
      "/documents/#{doc}/attachements"
    else
      "/attachements"

    uploader = new plupload.Uploader
      container: 'attachement_upload_box'
      runtimes: 'gears,html5,flash,silverlight,browserplus'
      browse_button: 'upload_attachement'
      url: url

    uploader.init()

    uploader.bind 'FilesAdded', (up, files) ->
      up.refresh()
      uploader.start()
      progressPane.show()
      progressText.text('0%')
      actionsPane.hide()

    uploader.bind 'UploadProgress', (up, file) ->
      status = if up.total.percent == 100
        "#{file.name} (в обработке)"
      else
        "#{file.name} (#{plupload.formatSize file.size}) #{up.total.percent}%"

      progressText.text(status)


    uploader.bind 'FileUploaded', (up, file, response) ->
      attachementsPane.append $(response.response)

      for el in $(response.response)
        attachementsIds.append $('<input/>').attr('type', 'hidden')
          .attr('name', 'document[attachement_ids][]')
          .val $(el).attr('data-id')

    uploader.bind 'UploadComplete', (up) ->
      progressText.text("100%")
      progressPane.hide()
      actionsPane.show()

  setupFinalToggler: ->
    finalToggler = $("@document-is-final")
    dueDateField = $(".input.document_due_date")
    finalToggler.change ->
      checked = finalToggler.is(":checked")
      if checked
        dueDateField.hide()
      else
        dueDateField.show()

    finalToggler.trigger("change")

  setupRelatedWarning: ->
    warning = $("@related-doc-warning")
    $("@related-doc-select").change ->
      warning.hide()

  setupDeleteInstructions: ->
    popover = $("@delete-instructions-popover")
    $("@delete-instructions-link").click ->
      popover.toggle()
      false

  setupSnapshotEditor: ->
    editor = $(".snapshot-editor")

    applyButton = editor.find("@apply_button")
    restoreButton = editor.find("@restore_button")

    toggleEditorControls = (enable)->
      if enable
        applyButton.removeAttr("disabled")
        restoreButton.removeAttr("disabled")
      else
        applyButton.attr("disabled", true)
        restoreButton.attr("disabled", true)

    save = (canvas, snapshotId)->
      toggleEditorControls(false)
      pngUrl = canvas.toDataURL()

      $.ajax
        url: "/snapshots/#{snapshotId}"
        type: "PUT"
        data: { snapshot: { public_scan: pngUrl } }
        success: ->
          $.fancybox.close()
          toggleEditorControls(true)

    openEditor = ->
      button = $(@)
      snapshot = button.parents(".document-attachment")
      snapshotId = snapshot.data("id")

      timestamp = new Date().getTime()
      publicImageUrl = snapshot.data("public-image")
      originalImageUrl = snapshot.data("original-image")

      $.fancybox.open(editor)

      # colorpickers are not working because of modal bugs
      # $('#color_field').colorpicker()

      imageUrl = publicImageUrl || originalImageUrl

      restore = (context)->
        toggleEditorControls(false)

        image = new Image()
        image.src = originalImageUrl + "?ts=" + new Date().getTime()
        image.onload = ->
          context.drawImage(image, 0, 0)
          toggleEditorControls(true)

      initEditor(
        imageUrl: imageUrl
        saveCallback: save
        restoreCallback: restore
        restoreButton: restoreButton[0]
        applyButton: applyButton[0]
        snapshotId: snapshotId
      )

      false

    $(document).on 'click', '@snapshot-editor-button', openEditor
