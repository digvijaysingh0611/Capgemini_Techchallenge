var angularjs;
(function (angularjs) {
    (function (directives) {
        var StateButton = (function () {
            function StateButton() {
                this.require = "?ngModel";
                this.replace = true;
                this.restrict = 'AE';
                this.templateUrl = "salespredict.directives.stateButton.html";
                this.terminal = true;
                this.link = this.link.bind(this);
            }
            StateButton.prototype.link = function (scope, element, attributes, ngModel) {
                var _this = this;
                var values = JSON.parse(attributes["dataset"]);
                var classes = JSON.parse(attributes["classes"]);
                var texts = JSON.parse(attributes["texts"]);

                element.find("span").each(function (index) {
                    this.innerHTML = texts[1 - index];
                });

                if (ngModel.$modelValue === values[1])
                    element.addClass(classes[1]);
                else
                    element.addClass(classes[0]);

                element.bind("click", function () {
                    _this.onStateButtonClicked(scope, element, attributes, ngModel);
                });
            };

            StateButton.prototype.onStateButtonClicked = function (scope, element, attributes, ngModel) {
                var values = JSON.parse(attributes["dataset"]);
                var classes = JSON.parse(attributes["classes"]);

                if (ngModel.$modelValue === values[1]) {
                    element.removeClass(classes[1]);
                    element.addClass(classes[0]);
                } else {
                    element.removeClass(classes[0]);
                    element.addClass(classes[1]);
                }

                scope.$apply(function () {
                    if (ngModel.$modelValue === values[0]) {
                        ngModel.$setViewValue(values[1]);
                    } else {
                        ngModel.$setViewValue(values[0]);
                    }
                    ngModel.$render();
                });
            };
            return StateButton;
        })();
        directives.StateButton = StateButton;
    })(angularjs.directives || (angularjs.directives = {}));
    var directives = angularjs.directives;
})(angularjs || (angularjs = {}));

angular.module('salespredict.directives', []);

angular.module('salespredict.directives').directive('stateButton', function () {
    return new angularjs.directives.StateButton();
});