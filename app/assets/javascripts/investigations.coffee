$ -> new Investigations

class Investigations
  constructor: ->
    @setupTreeScroll()
    @setupPublishLink()
    @setupAddModals()
    @setupDocumentPreview()

  setupTreeScroll: ->
    blink = (element)-> $(element || location.hash).effect "highlight", {times: 2}, 1500

    $('.thread-document-scroll-link a').on 'click', ->
      doc = $(@).attr('href')
      $('html, body').animate(scrollTop: $(doc).offset().top)
      setTimeout (-> blink(doc)), 300

    blink()

  setupPublishLink: ->
    $("@publish-link").click ->
      $(@).next().toggle()
      false

  setupAddModals: ->
    getModal = (name)->
      $("@new-#{name}-modal")

    photoModal = getModal('photo')
    @setupPhotoUpload(photoModal)

    $(".modal-form").on "click", "@cancel", ->
      $.fancybox.close()

    $("@open-add-model").click ->
      mediaType = $(@).data("media-type")
      modalBlock = getModal(mediaType)
      $.fancybox.open(modalBlock)

    # debugging helper
    # $("@open-add-model").eq(2).click()

  setupPhotoUpload: (block)->
    progressPane = block.find("@progress-pane")
    progressText = progressPane.find('strong')
    photosList = block.find("@photos-list")
    investigationId = block.data('investigation-id')
    entryDate = block.find("@entry-date")

    entryDate.change ->
      inputs = block.find("input[name='photo[][entry_date]']")
      inputs.val($(@).val())

    block.on "ajax:success", "@delete-photo-upload", ->
      $(@).parents("@photo-item").remove()

    uploader = new plupload.Uploader
      runtimes: 'gears,html5,flash,silverlight,browserplus'
      browse_button: 'upload_photo'
      url: "/photos"
      file_data_name: "image"
      multipart_params: {
        investigation_id: investigationId
      }
      filters : [
        {title : "Image files", extensions : "jpg,jpeg,png"},
      ]

    uploader.init()

    uploader.bind 'FilesAdded', (up, files) ->
      up.refresh()
      uploader.start()
      progressPane.show()
      progressText.text('0%')

    uploader.bind 'UploadProgress', (up, file) ->
      status = if up.total.percent == 100
        "#{file.name} (в обработке)"
      else
        "#{file.name} (#{plupload.formatSize file.size}) #{up.total.percent}%"

      progressText.text(status)

    uploader.bind 'FileUploaded', (up, file, response) ->
      photosList.append(response.response)
      entryDate.trigger('change')

    uploader.bind 'UploadComplete', (up) ->
      # progressText.text("100%")
      progressPane.hide()

  setupDocumentPreview: ->
    $("@thread-document").each ->
      doc = $(@)
      documentId = doc.data("document-id")
      previews = $("@document-preview", doc)
      collection = $(".snapshot", previews)
      total = collection.length
      collection = collection.map((index, el)->
        {
          href: $(@).data('url')
          title: "Документ #{index + 1} / #{total}"
        }
      )

      doc.click (e)->
        return if $(e.target).is("a")
        $.fancybox.open collection, padding: 0, afterShow: ->
          slide = $(@)[0]
          window.location.hash = "#doc_#{documentId}_slide_#{slide.index}"

    if hash = window.location.hash
      if result = hash.match(/^#doc_(\d+)_slide_(\d+)$/)
        documentId = result[1]
        slideIndex = result[2]

        thread = $("@thread-document").filter("[data-document-id='#{documentId}']")
        thread.trigger("click")

        if slideIndex > 0
          delayed = ->
            $.fancybox.jumpto(slideIndex)

          setTimeout(delayed, 200)
