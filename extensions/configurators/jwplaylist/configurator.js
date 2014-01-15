/**
* 
* This file is part of MuraPlayer TM
*
* Copyright 2010-2014 Stephen J. Withington, Jr.
* Licensed under the Apache License, Version v2.0
* http://www.apache.org/licenses/LICENSE-2.0
*
*/
function init(data) {

	initConfigurator(data,{
		url: '../plugins/MuraPlayer/extensions/configurators/jwplaylist/configurator.cfm'
		, pars: ''
		, title: 'MuraPlayer Playlist'
		, init: function(){}
		, destroy: function(){}
		, validate: function(){
			return true;
		}
	});

	return true;

};