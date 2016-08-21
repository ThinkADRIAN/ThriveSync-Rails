// Dropdown Menu Fix for Mobile
// https://github.com/designmodo/startup-support/issues/43
$('a.dropdown-toggle').click('button', function () {
    $('a.dropdown-toggle').collapse('display');
});