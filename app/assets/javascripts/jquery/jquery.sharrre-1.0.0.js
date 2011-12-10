/*
 *  Sharrre.com - Make your sharing widget!
 *  Version: beta 1.0.0 
 *  Author: Julien Hany
 *  License: MIT http://en.wikipedia.org/wiki/MIT_License or GPLv2 http://en.wikipedia.org/wiki/GNU_General_Public_License
 */

;(function ( $, window, document, undefined ) {

  /* Defaults
  ================================================== */
  var pluginName = 'sharrre',
  defaults = {
    className: 'sharrre',
    share: {
      googlePlus: false,
      facebook: false,
      twitter: false,
      digg: false,
      delicious: false
    },
    template: '',
    title: '',
    url: document.location.href,
    text: '',
    urlCurl: 'sharrre.php',  //PHP script for google plus...
    count: {}, //conter by social network
    total: 0,  //total of sharing
    shorterTotal: true, //show total by k or M when number is to big
    enableHover: true, //disable if you want to personalize hover event with callback
    hover: function(){}, //personalize hover event with this callback function
    hide: function(){}, //personalize hide event with this callback function
    click: function(){}, //personalize click event with this callback function
    render: function(){}, //personalize render event with this callback function
    buttons: {  //settings for buttons
      googlePlus : {  //http://www.google.com/webmasters/+1/button/
        size: 'medium',
        lang: 'en-US'
      },
      facebook: { //http://developers.facebook.com/docs/reference/plugins/like/
        action: 'like',
        layout: 'button_count',
        width: '',
        send: 'false',
        faces: 'false',
        colorscheme: '',
        font: '',
        lang: 'en_US'
      },
      twitter: {  //http://twitter.com/about/resources/tweetbutton
        count: 'horizontal',
        via: '',
        related: '',
        lang: 'en'
      },
      digg: { //http://about.digg.com/downloads/button/smart
        type: 'DiggCompact'
      }
    }
  },
  urlJson = {
    googlePlus: "",
    facebook: "http://graph.facebook.com/?id={url}&callback=?",
    //facebook : "http://api.ak.facebook.com/restserver.php?v=1.0&method=links.getStats&urls={url}&format=json"
    twitter: "http://cdn.api.twitter.com/1/urls/count.json?url={url}&callback=?",
    digg: "http://services.digg.com/2.0/story.getInfo?links={url}&type=javascript&callback=?",
    delicious: 'http://feeds.delicious.com/v2/json/urlinfo/data?url={url}&callback=?' //bookmarks
  },
  /* Load share buttons asynchronously
  ================================================== */
  loadButton = {
    googlePlus : function(self){
      //$(self.element).find('.buttons').append('<div class="button googleplus"><g:plusone size="'+self.options.buttons.googlePlus.size+'" href="'+self.options.url+'"></g:plusone></div>');
      $(self.element).find('.buttons').append('<div class="button googleplus"><div class="g-plusone" data-size="'+self.options.buttons.googlePlus.size+'" data-href="'+self.options.url+'"></div></div>');
      window.___gcfg = {
        lang: self.options.buttons.googlePlus.lang
      };
      var loading = 0;
      if(typeof gapi === 'undefined' && loading == 0){
        loading = 1;
        (function() {
          var po = document.createElement('script'); po.type = 'text/javascript'; po.async = true;
          po.src = 'https://apis.google.com/js/plusone.js';
          var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(po, s);
        })();
      }
      else{
        gapi.plusone.go();
      }
    },
    facebook : function(self){
      var sett = self.options.buttons.facebook;
      $(self.element).find('.buttons').append('<div class="button facebook"><div class="fb-like" data-href="'+self.options.url+'" data-send="'+sett.send+'" data-layout="'+sett.layout+'" data-width="'+sett.width+'" data-show-faces="'+sett.faces+'" data-action="'+sett.action+'" data-colorscheme="'+sett.colorscheme+'" data-font="'+sett.font+'"></div></div>');
      var loading = 0;
      if(typeof FB === 'undefined' && loading == 0){
        loading = 1;
        (function(d, s, id) {
          var js, fjs = d.getElementsByTagName(s)[0];
          if (d.getElementById(id)) {return;}
          js = d.createElement(s); js.id = id;
          js.src = '//connect.facebook.net/'+sett.lang+'/all.js#xfbml=1';
          fjs.parentNode.insertBefore(js, fjs);
        }(document, 'script', 'facebook-jssdk'));
      }
      else{
        FB.XFBML.parse();
      }
    },
    twitter : function(self){
      var sett = self.options.buttons.twitter;
      $(self.element).find('.buttons').append('<div class="button twitter"><a href="https://twitter.com/share" class="twitter-share-button" data-url="'+self.options.url+'" data-count="'+sett.count+'" data-text="'+self.options.text+'" data-via="'+sett.via+'" data-related="'+sett.related+'" data-lang="'+sett.lang+'">Tweet</a></div>');
      var loading = 0;
      if(typeof twttr === 'undefined' && loading == 0){
        loading = 1;
        (function() {
          var twitterScriptTag = document.createElement('script');
          twitterScriptTag.type = 'text/javascript';
          twitterScriptTag.async = true;
          twitterScriptTag.src = 'http://platform.twitter.com/widgets.js';
          var s = document.getElementsByTagName('script')[0];
          s.parentNode.insertBefore(twitterScriptTag, s);
        })();
      }
      else{
        $.ajax({ url: 'http://platform.twitter.com/widgets.js', dataType: 'script', cache:true}); //http://stackoverflow.com/q/6536108
      }
    },
    digg : function(self){
      $(self.element).find('.buttons').append('<div class="button digg"><a class="DiggThisButton '+self.options.buttons.digg.type+'" rel="nofollow external" href="http://digg.com/submit?url='+self.options.url+'"></a></div>');
      var loading = 0;
      if(typeof __DBW === 'undefined' && loading == 0){
        loading = 1;
        (function() {
          var s = document.createElement('SCRIPT'), s1 = document.getElementsByTagName('SCRIPT')[0];
          s.type = 'text/javascript';
          s.async = true;
          s.src = 'http://widgets.digg.com/buttons.js';
          s1.parentNode.insertBefore(s, s1);
        })();
      }
    },
    delicious : function(self){
      $(self.element).find('.buttons').append(
      '<div class="button delicious"><a href="http://www.delicious.com/save" onclick="window.open(\'http://www.delicious.com/save?v=5&noui&jump=close&url='+encodeURIComponent(self.options.url)+'&title='+self.options.text+'\', \'delicious\', \'toolbar=no,width=550,height=550\'); return false;">'+
      '<img src="http://www.delicious.com/static/img/delicious.small.gif" height="10" width="10" alt="Delicious" /> Bookmark</a></div>');
    }
  };

  /* Plugin constructor
  ================================================== */
  function Plugin( element, options ) {
    this.element = element;
    
    this.options = $.extend( true, {}, defaults, options) ;
    
    this._defaults = defaults;
    this._name = pluginName;
    
    this.init();
  }
  
  /* Initialization method
  ================================================== */
  Plugin.prototype.init = function () {
    var self = this;
    urlJson.googlePlus = this.options.urlCurl + '?url={url}'; // PHP script for GooglePlus...
    $(this.element).addClass(this.options.className);
    
    //get count of social share that have been selected
    $.each(this.options.share, function(name, val) {
      if(val == true){
        //self.getSocialJson(name);
        try {
          self.getSocialJson(name);
        } catch(e){
        }
      }
    });
    
    //add hover event
    $(this.element).hover(function(){
      if($(this).find('.buttons').length === 0 && self.options.enableHover === true){ //load social button if enable and 1 time
        $(this).append('<div class="buttons"></div>');
        $.each(self.options.share, function(name, val) {
          if(val == true){
            loadButton[name](self);
          }
        });
      }
      self.options.hover(self.element, self.options);
    }, function(){
      self.options.hide(self.element, self.options);
    });
    
    //click event
    $(this.element).click(function(){
      self.options.click(self.element, self.options);
      return false;
    });
  };
  
  /* getSocialJson methode
  ================================================== */
  Plugin.prototype.getSocialJson = function (name) {
    var self = this,
    count = 0,
    url = urlJson[name].replace('{url}', this.options.url);
    //console.log('name : ' + name + ' - url : '+url); //debug
    $.getJSON(url, function(json){
      if(typeof json.count != "undefined"){  //GooglePlus, Twitter and Digg
        count += parseInt(json.count, 10);
      }
      else if(typeof json.shares != "undefined"){  //Facebook
       count += parseInt(json.shares, 10);
      }
      else if(typeof json[0] != "undefined"){  //Delicious
        count += parseInt(json[0].total_posts, 10);
      }
      self.options.count[name] = count;
      self.options.total += count;
      self.renderer();
      self.options.render(self.element, self.options);
      //console.log(json); //debug
    });
  };
  
  /* render methode
  ================================================== */
  Plugin.prototype.renderer = function () {
    var total = this.options.total,
    template = this.options.template;
    if(this.options.shorterTotal === true){  //format number like 1.2k or 5M
      total = this.shorterTotal(total);
    }
    if(template !== ''){  //if there is a template
      template = template.replace('{total}', total);
      $(this.element).html(template);
    }
    else{ //template by defaults
      $(this.element).html(
                            '<div class="box"><a class="count" href="#">' + total + '</a>' + 
                            (this.options.title !== '' ? '<a class="share" href="#">' + this.options.title + '</a>' : '') +
                            '</div>'
                          );
    }
  };
  
  /* format total numbers like 1.2k or 5M
  ================================================== */
  Plugin.prototype.shorterTotal = function (num) {
    if (num >= 1e6){
      num = (num / 1e6).toFixed(2) + "M"
    } else if (num >= 1e3){ 
      num = (num / 1e3).toFixed(1) + "k"
    }
    return num;
  }

  /* A really lightweight plugin wrapper around the constructor, preventing against multiple instantiations
  ================================================== */
  $.fn[pluginName] = function ( options ) {
    return this.each(function () {
      if (!$.data(this, 'plugin_' + pluginName)) {
        $.data(this, 'plugin_' + pluginName, new Plugin( this, options ));
      }
    });
  }
})(jQuery, window, document);
