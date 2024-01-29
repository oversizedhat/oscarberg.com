
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

/*!
 * Note: Modified from the original source in Bootstrap v5.3.2
 *
 * Color mode toggler for Bootstrap's docs (https://getbootstrap.com/)
 * Copyright 2011-2023 The Bootstrap Authors
 * Licensed under the Creative Commons Attribution 3.0 Unported License.
 */

(() => {
    'use strict'
  
    const getStoredTheme = () => localStorage.getItem('theme')
    const setStoredTheme = theme => localStorage.setItem('theme', theme)
  
    const getPreferredTheme = () => {
      const storedTheme = getStoredTheme()
      if (storedTheme) {
        return storedTheme
      }
  
      return window.matchMedia('(prefers-color-scheme: dark)').matches ? 'dark' : 'light'
    }
  
    const setTheme = theme => {
      if (theme === 'auto' && window.matchMedia('(prefers-color-scheme: dark)').matches) {
        document.documentElement.setAttribute('data-bs-theme', 'dark')
      } else {
        document.documentElement.setAttribute('data-bs-theme', theme)
      }
    }
  
    setTheme(getPreferredTheme())
  
    const showActiveTheme = (theme, focus = false) => {
      document.querySelectorAll('[data-bs-theme-value]').forEach(element => {
        if (theme === 'light') {
            element.setAttribute('data-bs-theme-value', 'dark');
            element.innerHTML = `<i data-feather="moon"></i>`;
        } else {
            element.setAttribute('data-bs-theme-value', 'light');
            element.innerHTML = `<i data-feather="sun"></i>`;
        }        
      });
      // replace icons
      feather.replace();
    }
  
    window.matchMedia('(prefers-color-scheme: dark)').addEventListener('change', () => {
      const storedTheme = getStoredTheme()
      if (storedTheme !== 'light' && storedTheme !== 'dark') {
        setTheme(getPreferredTheme())
      }
    })
  
    window.addEventListener('DOMContentLoaded', () => {
      showActiveTheme(getPreferredTheme())
  
      document.querySelectorAll('[data-bs-theme-value]')
        .forEach(toggle => {
          toggle.addEventListener('click', () => {
            const theme = toggle.getAttribute('data-bs-theme-value')
            setStoredTheme(theme)
            setTheme(theme)
            showActiveTheme(theme, true)
          })
        })
    })
  })()