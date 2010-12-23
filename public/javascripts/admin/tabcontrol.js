TabControl = {
    element: null,
    controls: {},
    control_id: "",
    tab_container: null,
    tabs: {},

    /*
      Initializes a tab control. The variable +element_id+ must be the id of an HTML element
      containing one element with it's class name set to 'tabs' and another element with it's
      class name set to 'pages'.
    */
    init: function(element) {
        TabControl.element = jQuery(element);
        TabControl.control_id = element.id;
        TabControl.controls = {}
        TabControl.controls[TabControl.control_id] = TabControl;
        TabControl.tab_container = TabControl.element.children('.tabs');
    },
    
    /*
      Creates a new tab. The variable +tab_id+ is a unique string used to identify the tab
      when calling other methods. The variable +caption+ is a string containing the caption
      of the tab. The variable +page+ is the ID of an HTML element, or the HTML element
      itself. When a tab is initially added the page element is hidden.
    */
    addTab: function(tab_id, caption, page) {
        var tab = new TabControl.Tab(TabControl, tab_id, caption, page);
        TabControl.tabs[tab.id] = tab;
        return TabControl.tab_container.append(tab.createElement());
    },
    
    /*
      Removes +tab+. The variable +tab+ may be either a tab ID or a tab element.
    */
    removeTab: function(tab) {
        if (typeof(tab) === "string") tab = TabControl.tabs[tab.id];
        tab.remove();
        delete TabControl.tabs[tab.id]
        
        if (TabControl.selected == tab) {
          var first = TabControl.firstTab();
          if (first) TabControl.select(first);
          else TabControl.selected = null;
        }
    },
    /*
      Selects +tab+ updating the control. The variable +tab+ may be either a tab ID or a
      tab element.
    */
    select: function(tab) {
        if (typeof(tab) === "string") tab = TabControl.tabs[tab];
        if (TabControl.selected) TabControl.selected.unselect();
        tab.select();
        TabControl.selected = tab;
        var persist = TabControl.pageId() + ":" + TabControl.selected.id;
        document.cookie = "current_tab=" + persist;
    },

    /*
      Returns the first tab element that was added using #addTab().
    */
    firstTab: function() {
      return TabControl.tabs[first(keys(TabControl.tabs))];
    },

    /*
      Returns the the last tab element that was added using #addTab().
    */
    lastTab: function() {
      return TabControl.tabs[last(keys(TabControl.tabs))];
    },

    /*
      Returns the total number of tab elements managed by the control.
    */
    tabCount: function() {
        return keys(TabControl.tabs).length;
    },

    autoSelect: function() {
        if (TabControl.tabs === {}) return; //no tabs in control
        var tab = TabControl.firstTab();
        var tab, matches = document.cookie.match(/current_tab=(.*);?/);
        if (matches) {
            matches = matches[0].split(';')[0].split('=')[1].split(':')
            var page = matches[0], tabId = matches[1];
            if (!page || page == TabControl.pageId()) tab = TabControl.tabs[tabId];
        }
        var select = tab || TabControl.firstTab();
        TabControl.select(select);
        TabControl.selected = select;
    },

    pageId: function() {
      return /(\d+)/.test(window.location.pathname) ? RegExp.$1 : '';
    }
}

TabControl.Tab = function(control, id, label, content) {
    this.contentId = content;
    this.content = jQuery('#' + content).hide();
    this.label   = label || id;
    this.id      = id;
    this.control = control;
}

TabControl.Tab.prototype = {
    
    createElement: function() {
        this.loaded = false;
        this.element = document.createElement("A");
        this.element.href = "#";
        this.element.innerHTML = "<span>" + this.label + "</span>";
        this.element.className = "tab" 
        this.element.id = this.id;
        this.element = jQuery(this.element);
        return this.element.bind('click', {tab: this}, function(event){
                var tab = event.data.tab;
                tab.control.select(tab.id);
                return false;
            });
    },

    select: function() {
        if (!this.loaded) {
            if (this.content.children('script').size() > 0)
                this.content.html(this.content.children('script').html());
            if (PageForm && PageForm.tabs && PageForm.tabs[this.contentId]) PageForm.tabs[this.contentId]();
            this.loaded = true;
        }
        this.content.show();
        TabControl.selected = this;
        this.element.addClass('here');
    },

    unselect: function() {
        this.content.hide();
        TabControl.selected = null;
        this.element.removeClass('here');
    },

    remove: function() {
        this.content.remove();
        this.element.unbind('click').remove();
    }
}

