<live-editor>
  <section></section><iframe src="iframe.html" name="preview" scrolling="no"></iframe>
  <script>
    var component = this

    component.on('mount', function() {
      var editor = ace.edit(component.root.querySelector('section'))
      var doc = editor.getSession()
      editor.setTheme('ace/theme/monokai')
      editor.session.setUseWorker(false)
      doc.setMode('ace/mode/html')
      doc.setTabSize(2)
      doc.on('change', function(e) {
        var tag = doc.getValue()
        window.location.hash = encodeURIComponent(tag)
      })
      doc.setValue(decodeURIComponent(window.location.hash.substring(1)))
    })

    var updateTag = function() {
      var tag = decodeURIComponent(window.location.hash.substring(1))
      component.preview.contentWindow.postMessage(tag, '*')
    }
    window.onhashchange = updateTag
    component.on('unmount', function() {
      window.onhashchange = null
    })
  </script>

  <style scoped>
    :scope {
      display: block;
      height: 100vh;
      overflow: hidden;
    }
    section {
      display: inline-block;
      height: 150px;
      width: 100%;
    }
    iframe {
      display: inline-block;
      height: 100vh;
      width: 100%;
      border: none;
    }
    @media (min-width: 500px) {
      section {
        height: 100vh;
        width: 50%;
      }
      iframe {
        height: 100vh;
        width: 50%;
      }
    }
  </style>
</live-editor>
