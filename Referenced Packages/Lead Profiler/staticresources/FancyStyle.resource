.Default .sp-class-A {
	background: #54cc52;
}

.Default .sp-class-B {
	background: #d4a537;
}

.Default .sp-class-C {
	background: #c4424b;
}

.Default .sp-class-D {
	background: #c7c7c7;
}

.Special .sp-class-D, .sp-class-C, .sp-class-B, .sp-class-A {
    background: #fff;
	padding: 10px 24px 9px 20px;
}

div.fancy-select {
	position: relative;
	font-weight: bold;
	text-transform: uppercase;
	font-size: 16px;
}

div.fancy-select.disabled {
	opacity: 0.5;
}

div.fancy-select select:focus + div.trigger {
	box-shadow: 0 0 0 2px #0089bd;
}

div.fancy-select select:focus + div.trigger.open {
	box-shadow: none;
}

div.fancy-select div.trigger {
	cursor: pointer;
	padding: 10px 24px 9px 10px;
	white-space: nowrap;
	overflow: hidden;
	text-overflow: ellipsis;
	position: relative;
	border: 1px solid #eaece9;
	box-shadow: -1px 1px 1px #0089bd;
	width: 58px;
	height: 36px;
	font-size: 24px;
	line-height: 0.7em;	

	transition: all 240ms ease-out;
	-webkit-transition: all 240ms ease-out;
	-moz-transition: all 240ms ease-out;
	-ms-transition: all 240ms ease-out;
	-o-transition: all 240ms ease-out;
}

div.fancy-select div.trigger:after {
	content: "";
	display: block;
	position: absolute;
	width: 0;
	height: 0;
	border: 5px solid transparent;
	border-top-color: #4B5468;
	top: 16px;
	right: 9px;
}

div.fancy-select div.trigger.open {
	box-shadow: -1px 1px 1px #d5e1e6;
}

div.fancy-select div.trigger.open:after {
	border-top-color: #eaece9;
	border-bottom: 0px;
}

div.fancy-select ul.options {
	list-style: none;
	margin: 0;
	position: absolute;
	top: 36px;
	left: 0;
	visibility: hidden;
	display: none;
	opacity: 0;
	z-index: 50;
	max-height: 200px;
	overflow: auto;
	/*border-top: 1px solid #eaece9;*/
	box-shadow: 0 1px 2px rgba(0, 0, 0, 0.2);
	min-width: 58px;

	transition: opacity 300ms ease-out, top 300ms ease-out, visibility 300ms ease-out;
	-webkit-transition: opacity 300ms ease-out, top 300ms ease-out, visibility 300ms ease-out;
	-moz-transition: opacity 300ms ease-out, top 300ms ease-out, visibility 300ms ease-out;
	-ms-transition: opacity 300ms ease-out, top 300ms ease-out, visibility 300ms ease-out;
	-o-transition: opacity 300ms ease-out, top 300ms ease-out, visibility 300ms ease-out;
}

div.fancy-select ul.options.open {
	visibility: visible;
	display: inline;
	/*top: 50px;*/
	opacity: 1;

	/* have to use a non-visibility transition to prevent this iOS issue (bug?): */
	/*http://stackoverflow.com/questions/10736478/css-animation-visibility-visible-works-on-chrome-and-safari-but-not-on-ios*/
	transition: opacity 300ms ease-out, top 300ms ease-out;
	-webkit-transition: opacity 300ms ease-out, top 300ms ease-out;
	-moz-transition: opacity 300ms ease-out, top 300ms ease-out;
	-ms-transition: opacity 300ms ease-out, top 300ms ease-out;
	-o-transition: opacity 300ms ease-out, top 300ms ease-out;
}

div.fancy-select ul.options.overflowing {
	top: auto;
	/*bottom: 40px;*/

	transition: opacity 300ms ease-out, bottom 300ms ease-out, visibility 300ms ease-out;
	-webkit-transition: opacity 300ms ease-out, bottom 300ms ease-out, visibility 300ms ease-out;
	-moz-transition: opacity 300ms ease-out, bottom 300ms ease-out, visibility 300ms ease-out;
	-ms-transition: opacity 300ms ease-out, bottom 300ms ease-out, visibility 300ms ease-out;
	-o-transition: opacity 300ms ease-out, bottom 300ms ease-out, visibility 300ms ease-out;
}

div.fancy-select ul.options.overflowing.open {
	top: auto;
	/*bottom: 50px;*/

	transition: opacity 300ms ease-out, bottom 300ms ease-out;
	-webkit-transition: opacity 300ms ease-out, bottom 300ms ease-out;
	-moz-transition: opacity 300ms ease-out, bottom 300ms ease-out;
	-ms-transition: opacity 300ms ease-out, bottom 300ms ease-out;
	-o-transition: opacity 300ms ease-out, bottom 300ms ease-out;
}

div.fancy-select ul.options li {
	padding: 8px 12px;
	cursor: pointer;
	white-space: nowrap;

	transition: all 150ms ease-out;
	-webkit-transition: all 150ms ease-out;
	-moz-transition: all 150ms ease-out;
	-ms-transition: all 150ms ease-out;
	-o-transition: all 150ms ease-out;
}

div.fancy-select ul.options li.selected {
}

.Default div.fancy-select ul.options li.hover {
	color: #fff;
}

.Special div.fancy-select ul.options li.hover {
    transition: none;
	-webkit-transition: none;
	-moz-transition: none;
	-ms-transition: none;
	-o-transition: none;
}
