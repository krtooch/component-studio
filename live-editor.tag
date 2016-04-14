<live-editor>
  <section class="left">
    <div class="toolbar">
      <button onclick={ promptDep }>Load Dependency</button>
      <button onclick={ promptTag }>Load Tag</button>
      <button class="inception" onclick={ inception }>Inception</button>
    </div>
    <div class="editor"></div>
  </section>
  <iframe class="right" src="iframe.html" name="preview" scrolling="no"></iframe>
  <script>
    var component = this
    var editor = undefined
    var doc = undefined

    component.on('mount', function() {
      editor = ace.edit(component.root.querySelector('.editor'))
      doc = editor.getSession()
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

    function get(url, fn) {
      var req = new XMLHttpRequest()
      req.onreadystatechange = function() {
        if (req.readyState == 4 && (req.status == 200 || (!req.status && req.responseText.length)))
          fn(req.responseText)
      }
      req.open('GET', url, true)
      req.send('')
    }
    loadDep(url) {
      var script = component.preview.contentWindow.document.createElement('script')
      script.src = url
      component.preview.contentWindow.document.body.appendChild(script)
    }
    loadTag(url) {
      get(url, function(tag) { doc.setValue(tag) })
    }
    promptDep() {
      var url = prompt('dep url')
      component.loadDep(url)
    }
    promptTag() {
      var url = prompt('tag url')
      component.loadTag(url)
    }
    inception() {
      component.loadDep('//cdnjs.cloudflare.com/ajax/libs/ace/1.2.2/ace.js')
      setTimeout(function() {
        component.loadTag('live-editor.tag')
      }, 500)
    }

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
    .left {
      float: left;
    }
    .editor, .toolbar, section {
      display: inline-block;
      width: 100%;
    }
    section {
      height: 200px;
    }
    .toolbar {
      height: 40px;
      background: #19191B;
    }
    .editor {
      height: 160px;
    }
    button {
      display: inline-block;
      box-sizing: border-box;
      text-align: center;
      padding: 0 20px;
      margin: 6px 0;
      border: 1px solid #555;
      height: 28px;
      line-height: 28px;
      color: #bbb;
      background-color: transparent;
      cursor: pointer;
      font-size: 10px;
      text-transform: uppercase;
      border-radius: 0;
    }
    button:focus, button:hover {
      color: #ddd;
      border-color: #888;
      outline: 0;
    }
    .editor {
      height: 160px;
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
      .editor {
        height: calc(100vh - 40px);
      }
      iframe {
        height: 100vh;
        width: 50%;
      }
    }

    .inception {
      display: none;
    }
    @media (min-width: 700px) {
      .inception {
        display: inline-block;
      }
    }
  </style>
</live-editor>
