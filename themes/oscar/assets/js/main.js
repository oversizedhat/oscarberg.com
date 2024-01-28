
/**
 * Show/hide email in registered divs.
 */
var contactElements = [];

function MeMail() {
    var memail = atob("{{.Site.Params.contact64}}");
    if (contactElements.length <= 0) {
        window.location.href = "mailto:"+memail;
        return;
    }

    contactElements.forEach(element => {
        if (document.getElementById(element).text.indexOf("@") != -1) {
            window.location.href = "mailto:"+memail;
            return;
        }
    
        document.getElementById(element).text=memail;
    });
}

function registerContactElement(replaceElem) {
    contactElements.push(replaceElem);
}
