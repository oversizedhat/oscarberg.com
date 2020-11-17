// Cookie use consent.
const cookieBanner_acceptCookieId = "acceptingCookies";
function cookieBanner_show(){
    let cookieBanner = document.getElementsByClassName("cookie-banner")[0];
    cookieBanner.style.display = "block";
}
function cookieBanner_accept(){
    localStorage.setItem(cookieBanner_acceptCookieId, "true");
    let cookieBanner = document.getElementsByClassName("cookie-banner")[0];
    cookieBanner.style.display = "none";
}
function cookieBanner_init(){
    let alreadyAcceptingCookies = localStorage.getItem(cookieBanner_acceptCookieId);
    if(alreadyAcceptingCookies != "true") {
        cookieBanner_show();
    }
}
window.onload = cookieBanner_init();