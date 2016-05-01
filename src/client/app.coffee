# src/client/app.coffee becomes:
### public/js/app.js ###

app = angular.module 'Scrumtious', []

app.controller 'BoardCtrl', ['$scope', ($scope) ->
  $scope.stickyList = []
  $scope.stickyList.push {text: 'some sticky text'}
  $scope.stickyTracker = 1

  $scope.addSticky = ->
    console.log 'Sticky added!'
]

app.directive 'sticky', ($document) ->
  {
    restrict: 'E'
    scope: {
      idn: '@'
      text: '@'
      startX: '=x'
      startY: '=y'
      x: '=x'
      y: '=y'
    }
    template: '''
    <div class='card blue-grey darken-1'>
      <div class='card-content white-text'>
        <p>{{text}}, {{x}}, {{y}}</p>
      </div>
    </div>
    '''
    link: (scope, element, attrs) ->
      element.css {
        'position': 'relative'
        'display': 'block'
        'width': '150px'
        'height': '150px'
        'cursor': 'pointer'
      }

      element.on 'mouseon', (event) ->
        console.log scope.text, scope.startX, scope.startY, scope.x, scope.y

      element.on 'mousedown', (event) ->
        event.preventDefault()
        scope.startX = event.screenX - scope.x
        scope.startY = event.screenY - scope.y
        $document.on 'mousemove', mousemove
        $document.on 'mouseup', mouseup

      mousemove = (event) ->
        scope.y = event.screenY - scope.startY
        scope.x = event.screenX - scope.startX
        element.css {
          top: scope.y + 'px'
          left: scope.x + 'px'
        }

      mouseup = (event) ->
        $document.off 'mousemove', mousemove
        $document.off 'mouseup', mouseup

      element.on 'dblclick', (event) ->
        # scope.text = prompt 'Change the text', scope.text
        alert scope.x + ', ' + scope.startX
  }
