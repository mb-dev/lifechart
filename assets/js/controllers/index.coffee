App.IndexController = Ember.ArrayController.extend
  sortProperties: ['category']
  sortAscending: false

  contentByDate: (->
    content = this.get("content") || []
    _(content).groupBy(content, itemDate)
  ).property('content.@each')
  
  sortedContent:  (-> 
    content = this.get("content") || []
    Ember.ArrayProxy.createWithMixins(Ember.SortableMixin, {
      content: content.toArray(),
      sortProperties: this.get('sortProperties'),
      sortAscending: this.get('sortAscending')
    })
  ).property("content.@each", 'sortProperties', 'sortAscending')

  doSort: (sortBy) ->    
    previousSortBy = this.get('sortProperties.0')
    if (sortBy == previousSortBy)
      this.set('sortAscending', !this.get('sortAscending'))
    else
      set('sortAscending', true)
      this.set('sortProperties', [sortBy])