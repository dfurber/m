DDTable.prototype.onDrop = function() {
    var row = $('tr.drag-previous'),
        indentCount = row.find('.indentation').size(), 
        parentIndent = indentCount + 1;
    var parent_id = row.attr('data-parent-id'),
        position = row.attr('data-position'),
        old_position = position,
        old_parent_id = parent_id,
        id = SiteMap.extractPageId(row);
    row.find('.busy').show();
    while (row.prev('tr').size() > 0 && parentIndent >= indentCount) {
        row = row.prev('tr');
        if (row.size() > 0) {
            parentIndent = row.find('.indentation').size();
        } else {
            parentIndent = indentCount;
        }
    }
    $('tr.drag-previous').attr({
        'data-parent-id': SiteMap.extractPageId(row),
        'data-level'    : indentCount
    });

    // recalc positions
    var positions = {};
    SiteMap.element.find('tr').each(function(){
        var pid = $(this).attr('data-parent-id');
        if (!positions[pid]) {
            positions[pid] = 1;
        } else {
            positions[pid]++;
        }
        $(this).attr('data-position', positions[pid]);
    });
    position = $('tr.drag-previous').attr('data-position');
    parent_id = $('tr.drag-previous').attr('data-parent-id');

    // console.log('Position: ', old_position, position);
    // console.log('Parent: ', old_parent_id, parent_id);
    if (position == old_position && parent_id == old_parent_id) {
        $('tr.drag-previous').find('.busy').hide();
        return;
    }
    $.post($('#content form').attr('action'), {id: id, parent_id: parent_id, position: position},
    function(){
        $('tr.drag-previous').find('.busy').hide();
    })
}

SiteMap = {
    expandedRows: [],
    init: function() {
        SiteMap.element = jQuery('#site-map');
        SiteMap.element.hoverIntent({
            interval: 50,
    		over: function(){
    		    jQuery(this).addClass("highlight");
    		},
    		out: function(){
    		    jQuery(this).removeClass("highlight");
    		}
        });
        SiteMap.readExpandedCookie();
        SiteMap.element.bind("click", SiteMap.onMouseClickRow);
        if (SiteMap.element.find('tbody tr').size() > 1)
            SiteMap.tableDD = SiteMap.element.draggableTable();
    },
    onMouseClickRow: function(event){
        if (SiteMap.isExpander(event.target)) {
            var row = jQuery(event.target).parents("tr");
            if (SiteMap.hasChildren(row)) {
                SiteMap.toggleBranch(row, event.target);
            }
        }
    },
    // element is a jquery object
    hasChildren: function(row){
        return !row.hasClass('no-children');
    },
    // element is a DOM object
    isExpander: function(element){
        return jQuery(element).is('img.expander');
    },
    // element is a jquery object
    isExpanded: function(row){
        return row.hasClass('children-visible');
    },
    // element is a DOM object
    isRow: function(element){
        return jQuery(element).is("tr");
    },
    // Row is a DOM object
    extractLevel: function(row){
        if (/level-(\d+)/i.test(row.attr('className')))
          return RegExp.$1.toInteger();
    },
    extractPageId: function(row) {
        return row.attr('id').replace('node-','')
    },

    getExpanderImageForRow: function(row) {
      return jQuery(row).children('img');
    },
    
    readExpandedCookie: function() {
        var matches = document.cookie.match(/expanded_rows=(.+?);/);
        SiteMap.expandedRows = matches ? decodeURIComponent(matches[1]).split(',') : [];
    },

    saveExpandedCookie: function() {
        document.cookie = "expanded_rows=" + encodeURIComponent(jQuery.unique(SiteMap.expandedRows).join(",")) + "; path=/admin";
    }, 

    persistCollapsed: function(row) {
        var pageId = SiteMap.extractPageId(row);
        for (var index in SiteMap.expandedRows) {
            if (SiteMap.expandedRows[index].toString() == pageId.toString())
                delete SiteMap.expandedRows[index]
        }
        SiteMap.expandedRows = jQuery.unique(SiteMap.expandedRows);
        SiteMap.saveExpandedCookie();
    },

    persistExpanded: function(row) {
        SiteMap.expandedRows.push(SiteMap.extractPageId(row));
        SiteMap.saveExpandedCookie();
    },

    toggleExpanded: function(row, img) {
        if (!img) img = SiteMap.getExpanderImageForRow(row);
        if (SiteMap.isExpanded(row)) {
            img.src = img.src.replace('collapse', 'expand');
            jQuery(row).removeClass('children-visible').addClass('children-hidden');
            SiteMap.persistCollapsed(row);
        } else {
            img.src = img.src.replace('expand', 'collapse');
            jQuery(row).removeClass('children-hidden').addClass('children-visible');
            SiteMap.persistExpanded(row);
        }
    },
  
    hideBranch: function(parent, img) {
        var level = SiteMap.extractLevel(parent), row = parent.next();
        while (SiteMap.isRow(row) && SiteMap.extractLevel(row) > level) {
            row.hide();
            row = row.next();
        }
        SiteMap.toggleExpanded(parent, img);
    },
  
    showBranch: function(parent, img) {
        var level = SiteMap.extractLevel(parent), row = parent.next(),
            children = false, expandLevels = [level + 1];
        
        while (SiteMap.isRow(row)) {
            var currentLevel = SiteMap.extractLevel(row);
            if (currentLevel <= level) break;
            children = true;
            if (currentLevel < last(expandLevels)) expandLevels.pop();
            if (jQuery.inArray(currentLevel, expandLevels) > -1) {
                row.show();
                if (this.isExpanded(row)) expandLevels.push(currentLevel + 1);
            }
            row = row.next();
        }
        if (!children) SiteMap.getBranch(parent);
        this.toggleExpanded(parent, img);
    },
  
    getBranch: function(row) {
        var id = SiteMap.extractPageId(row), level = SiteMap.extractLevel(row),
            spinner = jQuery('#busy-' + id);
        
        jQuery.ajax({
            url: '../admin/pages/' + id + '/children/?level=' + level,
            method: 'get',
            beforeSend: function() { spinner.show(); SiteMap.updating = true  },
            complete: function(request) { 
                spinner.fadeOut(); 
                SiteMap.updating = false;  
                row.after(request.responseText);
            }
        });
    },
  
    toggleBranch: function(row, img) {
        if (!SiteMap.updating) {
            var method = (SiteMap.isExpanded(row) ? 'hide' : 'show') + 'Branch';
            SiteMap[method](row, img);
    }
  }
};

