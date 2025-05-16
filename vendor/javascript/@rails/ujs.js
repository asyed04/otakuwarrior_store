// Rails UJS
// This is a simplified version of Rails UJS for basic functionality
// Source: https://github.com/rails/rails/blob/main/actionview/app/javascript/rails-ujs/index.js

(function() {
  var Rails = {
    CSRFProtection: function(xhr) {
      var token = document.querySelector('meta[name="csrf-token"]');
      if (token) { xhr.setRequestHeader('X-CSRF-Token', token.content); }
    },
    
    fire: function(obj, name, data) {
      var event = new CustomEvent(name, { bubbles: true, cancelable: true, detail: data });
      obj.dispatchEvent(event);
      return !event.defaultPrevented;
    },
    
    confirm: function(message) {
      return confirm(message);
    },
    
    handleRemote: function(element) {
      var method, url, data, withCredentials, dataType, options;
      
      var getData = function(element) {
        var data = element.getAttribute('data-params');
        if (data) return data;
        
        if (element.tagName.toUpperCase() === 'FORM') {
          return new FormData(element);
        } else {
          return null;
        }
      };
      
      method = element.getAttribute('data-method') || element.method || 'GET';
      url = element.getAttribute('data-url') || element.action || element.href;
      data = getData(element);
      withCredentials = element.getAttribute('data-with-credentials');
      dataType = element.getAttribute('data-type') || 'script';
      
      options = {
        method: method,
        url: url,
        data: data,
        withCredentials: withCredentials,
        dataType: dataType,
        success: function(response) {
          Rails.fire(element, 'ajax:success', { response: response });
        },
        error: function(xhr, status, error) {
          Rails.fire(element, 'ajax:error', { xhr: xhr, status: status, error: error });
        },
        complete: function(xhr, status) {
          Rails.fire(element, 'ajax:complete', { xhr: xhr, status: status });
        }
      };
      
      Rails.ajax(options);
    },
    
    ajax: function(options) {
      var xhr = new XMLHttpRequest();
      xhr.open(options.method, options.url, true);
      
      if (options.withCredentials) {
        xhr.withCredentials = true;
      }
      
      xhr.setRequestHeader('Accept', '*/*');
      xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded; charset=UTF-8');
      
      Rails.CSRFProtection(xhr);
      
      xhr.onload = function() {
        if (xhr.status >= 200 && xhr.status < 300) {
          options.success(xhr.response);
        } else {
          options.error(xhr, xhr.status, xhr.statusText);
        }
        options.complete(xhr, xhr.status);
      };
      
      xhr.onerror = function() {
        options.error(xhr, 'error', 'Failed to make request');
        options.complete(xhr, 'error');
      };
      
      xhr.send(options.data);
    },
    
    start: function() {
      document.addEventListener('click', function(e) {
        var element = e.target;
        
        if (element.getAttribute('data-remote') === 'true') {
          e.preventDefault();
          Rails.handleRemote(element);
        }
        
        if (element.getAttribute('data-confirm')) {
          if (!Rails.confirm(element.getAttribute('data-confirm'))) {
            e.preventDefault();
          }
        }
      });
      
      document.addEventListener('submit', function(e) {
        var element = e.target;
        
        if (element.getAttribute('data-remote') === 'true') {
          e.preventDefault();
          Rails.handleRemote(element);
        }
        
        if (element.getAttribute('data-confirm')) {
          if (!Rails.confirm(element.getAttribute('data-confirm'))) {
            e.preventDefault();
          }
        }
      });
      
      console.log('Rails UJS started successfully');
    }
  };
  
  window.Rails = Rails;
  
  if (typeof exports !== 'undefined') {
    exports.Rails = Rails;
  }
})();

export const start = function() {
  if (window.Rails) {
    window.Rails.start();
  }
};

export default { start };