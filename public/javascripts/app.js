$(function(){
  initAutocomplete($('#card_autocomplete'));
  loadCard("Jackson Howard");
});

function loadCard(cardTitle) {
  $('#card_autocomplete').val(cardTitle);
  onAutocompleteSelectionUpdated(cardTitle);
}

function initAutocomplete(element){
  var options = element.data();
  options.updater = onAutocompleteSelectionUpdated;
  element.typeahead(options);
}

function onAutocompleteSelectionUpdated(item) {
  $.get("/api/recommendations/" + encodeURIComponent(item)).then(function(response){
    updatePage(response);
  });
  return item;
}

function updatePage(recommendations){
  var recommendationElement = $('#recommendations');
  var filtersElement = $('#filters');
  var filters = _(recommendations).map(function(card){
    return card.type.toLowerCase();
  }).uniq()
    .value();
  renderFilters(filtersElement, filters);
  renderRecommendations(recommendationElement, recommendations);
}

function renderFilters(element, filters) {
  element.find('.btn').remove();
  filters.unshift('all');
  var btnFilters = filters.map(function(filter){
    return '<button type="button" data-card-type="' + filter + '" class="btn btn-default">' + filter + '</button>';
  });
  element.css({opacity: 0}).animate({opacity: 1});
  element.append(btnFilters);
  element.find('.btn').each( function( i, buttonCardType ) {
    $(buttonCardType).on('click', function() {
      filterRecommendations(element, $(this).data('card-type'));
    });
  });
}

function filterRecommendations(element, type) {
  var recommendationElement = $('#recommendations');
  var cardsToFilter;
  if(type === 'all') {
    cardsToFilter = $();
  } else {
    cardsToFilter = recommendationElement.find(':not(.' + type + ')');
  }
  recommendationElement.find('.filtered').removeClass('filtered').show();
  cardsToFilter.addClass('filtered');
  cardsToFilter.hide();
  recommendationElement.css({opacity: 0}).animate({opacity: 1});
}

function renderRecommendations(element, recommendations) {
  element.find('.card').remove();
  var newCards = recommendations.map(function(card){
    var imgFragment = '<img data-title="' + card.title + '" width="150" height="208" src="' + card.image_url + '" class="card ' + card.type.toLowerCase() + '" />';
    return $(imgFragment);
  });
  element.css({opacity: 0}).animate({opacity: 1});
  element.append(newCards);
  element.find('.card').each( function( i, card ) {
    $(card).on('click', function() {
      loadCard($(this).data('title'));
    });
  });
}
