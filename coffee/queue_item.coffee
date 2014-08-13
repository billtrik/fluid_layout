define ->
  class QueueItem
    template: (data)-> """<li class="box">
          <header>
            <h1>#{data.id}</h1>
            <span class="delete">&#x2716;</span>
          </header>
          <section>
            <p class="prev">#{data.prev or ''}</p>
            <p class="next">#{data.next or ''}</p>
          </section>
        </li>"""

    constructor: (data)->
      @template = @template(data)

  return QueueItem