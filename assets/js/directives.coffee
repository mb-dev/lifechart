angular.module('lifechart.directives', []).
  directive('appVersion', ['version', (version) ->
    return (scope, elm, attrs) ->
      elm.text(version);
  ]);