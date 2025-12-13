cache = {}

function compiletext(text, filetype = "bash") {
    var result = hljs.highlight(filetype, text).value; // use the same highlight as the revealjs module

    ////////// MARKDOWNIT
    // var md = window.markdownit();
    // var result = md.render("```bash\n" + text + "\n```");
    //////////
    return result
}

function showtext(url, text) {
    try {
        /////// Highlightjs assume bash
        var pre = document.createElement("pre")
        var code = document.createElement("code")
        code.classList.add("language-bash")
        code.classList.add("hljs") // have the same background as in the theme
        code.innerHTML = text
        pre.appendChild(code)
        ///////
        var domnode = document.createElement("div");
        domnode.classList.add("modal")
        domnode.classList.add("hljs")
        domnode.ondblclick = function () { domnode.remove() } // remove on click
        var sourcefile = document.createElement("a")
        sourcefile.classList.add("modal-top")
        sourcefile.classList.add("hljs-comment")
        sourcefile.setAttribute("href", url)
        sourcefile.setAttribute("target", "_blank")
        sourcefile.innerText = url
        var info = document.createElement("div")
        info.classList.add("modal-bottom")
        info.classList.add("hljs-comment")
        info.innerText = "... Double-Click to close ..."
        domnode.appendChild(sourcefile)
        domnode.appendChild(pre)
        domnode.appendChild(info)
        document.body.appendChild(domnode) // add to the bottom of the page over everything
    } catch (err) {
        console.error("Failed to parse", err)
    }
}

function openExample(domelem, filetype = "bash") {
    // Can access the event with "event"
    // Can access the dom elem with "this"
    event.preventDefault()
    var url = domelem.getAttribute("href")
    if (url in cache) {
        showtext(url, cache[url])
    } else {
        fetch(url)
            .then(response => response.text())
            .then(text => {
                let ft = filetype
                try {
                    const extension = url.split("/").pop().split(".").pop()
                    switch (extension) {
                        case "py": ft = "python"; break;
                        case "sh": ft = "bash"; break;
                        case "yaml":
                        case "yml": ft = "yaml"; break;
                        case "conf": ft = "ini"; break;
                        case "toml": ft = "toml"; break;
                        case "jsonc":
                        case "json": ft = "json"; break;
                        case "Dockerfile": ft = "dockerfile"; break;
                        default: break;
                    }
                    console.log("Render file with type:", extension, ft);
                } catch (err) {
                    console.warn("Could not guess filetype")
                }
                var result = compiletext(text, ft)
                cache[url] = result;
                return result;
            })
            .then(result => showtext(url, result))
            .catch(data => {
                console.error(data);
            });
    }
    return false;
}

function keepAlphanumeric(str) {
    return str.replace(/[^a-zA-Z0-9]/g, '');
}

function asciiCast(path) {
    const id = "asciinema_" + keepAlphanumeric(path) // add valid ID name
    var newDiv = document.createElement("div");
    newDiv.id = id; // add this to make it possible to add the cast
    newDiv.className = "stretch"; // add this class to fill the available space
    if (document.currentScript) {
        document.currentScript.insertAdjacentElement("afterend", newDiv); // add the div after the current script tag
        AsciinemaPlayer.create(path, document.getElementById(id), {
            // https://docs.asciinema.org/manual/player/options/
            fit: "height",
            speed: 2,
            idleTimeLimit: 1,
        });
    } else {
        console.error("Failed to load asciinema cast:", path)
    }
}

function setupImageModal() {
    document.querySelectorAll('img[src^="./images/"]').forEach(img => {
      img.addEventListener('click', function(event) {
        const modalOverlay = document.createElement('div');
        modalOverlay.classList.add('modal-overlay');
  
        const modalImage = document.createElement('img');
        modalImage.src = event.target.src;
        modalOverlay.appendChild(modalImage);
  
        document.body.appendChild(modalOverlay);
  
        modalOverlay.addEventListener('click', function() {
          document.body.removeChild(modalOverlay);
        });
      });
    });
  }

  function secureExternalLinks() {
    const links = document.querySelectorAll('a[href^="https://"]');
    links.forEach(link => {
      link.setAttribute('target', '_blank');
      link.setAttribute('rel', 'noreferrer');
    });
  }
  
  // Call the function after DOM is loaded
  document.addEventListener('DOMContentLoaded', () => {
    setupImageModal();
    secureExternalLinks();
});
  