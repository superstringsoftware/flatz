/**
* Created with JetBrains WebStorm.
* User: aantich
* Date: 9/28/12
* Time: 6:44 PM
* To change this template use File | Settings | File Templates.
*/

// a simple handlebars function that lets you render a page based a reactive var
Handlebars.registerHelper('render', function(name) {
    if (Template[name])
        return Template[name]();
});

// Simply grabbing current_page from the Session
Handlebars.registerHelper('currentPage', function() {
    return Session.get("current_page");
});

