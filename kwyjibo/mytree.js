//  TLR.MAP (c)1999 by bingen@tlr.de
//   - based on OmenTree by OmenSoft.

// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// start() - GENERAL FUNCTION - called by the HTML document once loaded - starts OmenTree by
//                                          first loading the user data, and then drawing the tree.

function startmap() {
        loadData();
        drawTree();
}

// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// drawTree() - GENERAL FUNCTION - starts the recursive tree drawing process by first writing
//                                             the root node, and then all subordinate branches.

function drawTree() {
        outputFrame = hudel.window.document; 
        
        outputFrame.open("text/html");
        
        outputFrame.write("<HTML>\n<style> body {font-family:Tahoma;font-size:11px}\n a:active{text-decoration:none;font-weight:bold;background-color:#efedde} a:link{text-decoration:none;color:#000000} a:visited{text-decoration:none;}</style>\n");
        outputFrame.write("<BODY BGCOLOR=#ffffff text=#000000 link=#000000 vlink=#000000 alink=#000000 style='margin:1'>\n");

        if (treeData[1].target == "") {var targetFrame = defaultTargetFrame} else {var targetFrame = treeData[1].target}
        if (treeData[1].icon == "") {var imageString = gPathTree + 'img-globe-' + structureStyle + '.gif'} else {imageString = treeData[1].icon}
        outputFrame.write("<A HREF='" + treeData[1].url + "' TARGET='" + targetFrame + "'><IMG SRC='" + imageString + "' ALIGN=TEXTTOP BORDER=0></A>&nbsp;<B>" + treeData[1].name + "</B><BR>\n");
        drawBranch("root","");
        outputFrame.write("\n</BODY></HTML>");
        outputFrame.close();
        window.status="";
}

// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// drawBranch() - GENERAL FUNCTION - used by the drawTree() function to recursively draw all
//                                                 visable nodes in the tree structure.

function drawBranch(startNode,structureString) {
        var children = extractChildrenOf(startNode);
        var currentIndex = 1;
        while (currentIndex <= children.length) {
                outputFrame.write("<nobr>"+structureString);
                if (children[currentIndex].type == 'link') {
                        if (children[currentIndex].icon == "") {
                                var imageString = defaultImageURL + defaultLinkIcon;
                        }
                        else {var imageString =  children[currentIndex].icon}
                        if (children[currentIndex].target == "") {
                                var targetFrame = defaultTargetFrame;
                        }
                        else {var targetFrame = children[currentIndex].target}
                        if (currentIndex != children.length) {
                                outputFrame.write("<IMG SRC='"+spacer+"' WIDTH=15 HEIGHT=16 ALIGN=TEXTTOP>")
                        }
                        else {
                                outputFrame.write("<IMG SRC='"+spacer+"' WIDTH=15 HEIGHT=16 ALIGN=TEXTTOP>")
                        }
                        outputFrame.write("<A HREF='" + children[currentIndex].url + "' TARGET='" + targetFrame + "'><IMG SRC='" + imageString + "' ALIGN=TEXTTOP BORDER=0>&nbsp;" + children[currentIndex].name + "</A></nobr><BR>\n")
                }
                else {
                        var newStructure = structureString;
                        if (children[currentIndex].iconClosed == "") {var iconClosed = "img-folder-closed.gif"} else {var iconClosed = children[currentIndex].iconClosed}
                        if (children[currentIndex].iconOpen == "") {var iconOpen = "img-folder-open.gif"} else {var iconOpen = children[currentIndex].iconOpen}
                        if (currentIndex != children.length) {
                                if (children[currentIndex].open == 0) {
                                        outputFrame.write("<A HREF=\"javascript:parent.toggleFolder('" + children[currentIndex].id + "',1)\"><IMG SRC='" + defaultImageURL + "collapsed.gif' ALIGN=TEXTTOP HSPACE=2 VSPACE=3 BORDER=0>")
                                        outputFrame.write("<IMG SRC='" + iconClosed + "' ALIGN=TEXTTOP BORDER=0></A>&nbsp;<A HREF='" + children[currentIndex].url + "'>" + children[currentIndex].name + "</A><BR>\n")
                                }
                                else {
                                        outputFrame.write("<A HREF=\"javascript:parent.toggleFolder('" + children[currentIndex].id + "',0)\"><IMG SRC='" + defaultImageURL + "expanded.gif' ALIGN=TEXTTOP HSPACE=2 VSPACE=3 BORDER=0>");
                                        outputFrame.write("<IMG SRC='" + iconOpen + "' ALIGN=TEXTTOP BORDER=0></A>&nbsp;<A HREF='" + children[currentIndex].url + "'>" + children[currentIndex].name + "</A><BR>\n");
                                        newStructure = newStructure + "<IMG SRC='"+spacer+"' WIDTH=16 HEIGHT=16 ALIGN=TEXTTOP>";
                                        drawBranch(children[currentIndex].id,newStructure);
                                }
                        }
                        else {
                                if (children[currentIndex].open == 0) {
                                        outputFrame.write("<A HREF=\"javascript:parent.toggleFolder('" + children[currentIndex].id + "',1)\"><IMG SRC='" + defaultImageURL + "collapsed.gif' ALIGN=TEXTTOP HSPACE=2 VSPACE=3 BORDER=0>")
                                        outputFrame.write("<IMG SRC='" + iconClosed + "' ALIGN=TEXTTOP BORDER=0></A>&nbsp;<A HREF='" + children[currentIndex].url + "'>" + children[currentIndex].name + "</A><BR>\n")
                                }
                                else {
                                        outputFrame.write("<A HREF=\"javascript:parent.toggleFolder('" + children[currentIndex].id + "',0)\"><IMG SRC='" + defaultImageURL + "expanded.gif' ALIGN=TEXTTOP HSPACE=2 VSPACE=3 BORDER=0>");
                                        outputFrame.write("<IMG SRC='" + iconOpen + "' ALIGN=TEXTTOP BORDER=0></A>&nbsp;<A HREF='" + children[currentIndex].url + "'>" + children[currentIndex].name + "</A><BR>\n");
                                        newStructure = newStructure + "<IMG SRC='"+spacer+"' WIDTH=16 HEIGHT=16 ALIGN=TEXTTOP>";
                                        drawBranch(children[currentIndex].id,newStructure);
                                }
                        }
                }
                currentIndex++;
        }
}

// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// toggleFolder() - GENERAL FUNCTION - opens/closes folder nodes.

function toggleFolder(id,status) {
        var nodeIndex = indexOfNode(id);
        treeData[nodeIndex].open = status;
        timeOutId = setTimeout("drawTree()",100)}

// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// indexOfNode() - GENERAL FUNCTION - finds the index in the treeData Collection of the node
//                                                  with the given id.

function indexOfNode(id) {
        var currentIndex = 1;
        while (currentIndex <= treeData.length) {
                if ((treeData[currentIndex].type == 'root') || (treeData[currentIndex].type == 'folder')) {
                        if (treeData[currentIndex].id == id) {return currentIndex}}
                currentIndex++}
        return -1}

// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// extractChildrenOf() - GENERAL FUNCTION - extracts and returns a Collection containing all
//                                                          of the node's immediate children nodes.

function extractChildrenOf(node) {
        var children = new Collection();
        var currentIndex = 1;
        while (currentIndex <= treeData.length) {
                if ((treeData[currentIndex].type == 'folder') || (treeData[currentIndex].type == 'link')) {
                        if (treeData[currentIndex].parent == node) {
                                children.add(treeData[currentIndex])}}
                currentIndex++}
        return children}

// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// Collection() - OBJECT - a dynamic storage structure similar to an Array.

function Collection() {
        this.length = 0;
        this.add = add;
        return this}

// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// add() - METHOD of Collection - adds an object to a Collection.

function add(object) {
        this.length++;
        this[this.length] = object}

// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// RootNode() - OBJECT - represents the top-most node of the hierarchial tree.

function RootNode(id,name,url,target,icon) {
        this.id = id;
        this.name = name;
        this.url = url;
        this.target = target;
        this.icon = icon;
        this.type = 'root';
        return this}

// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// FolderNode() - OBJECT - represents a node which branches to contain other nodes.

function FolderNode(id,parent,name,url,iconClosed,iconOpen) {
        this.id = id;
        this.parent = parent;
        this.name = name;
        this.url = url;
        this.iconClosed = iconClosed;
        this.iconOpen = iconOpen;
        this.type = 'folder';
        this.open = 0;
        return this}

// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// LinkNode() - OBJECT - a node that represents a link using a URL.

function LinkNode(parent,name,url,target,icon) {
        this.parent = parent;
        this.name = name;
        this.url = url;
        this.target = target;
        this.icon = icon;
        this.type = 'link';
        return this}

// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// loadData() - GENERAL FUNCTION - user defined data and variables exist in this function.

function loadData() {

      // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      // User defined variables:

      structureStyle = 0;                   // 0 for light background, 1 for dark background

      backgroundColor = '#FFFFFF';           // sets the bgColor of the menu
      textColor = '#000000';           // sets the color of the text used in the menu
      linkColor = '#000000';           // sets the color of any text links (usually defined in additional HTML sources)
      aLinkColor = '#FF0000';           // sets the active link color (when you click on the link)
      vLinkColor = '#880088';           // sets the visited link color

      backgroundImage = '';                  // give the complete path to a gif or jpeg to use as a background image

      defaultTargetFrame = '_self';      // the name of the frame that links will load into by default
      defaultImageURL = gPathTree;        // the URL or path where the OmenTree images are located

      defaultLinkIcon = 'endnode.gif';  // the default icon image used for links

      omenTreeFont = 'Tahoma,MS Sans Serif,Arial,Helvetica';  // the font used for the menu
      omenTreeFontSize = 1;                                // its size - don't make it too big!

      spacer=gPathIcons+"spacer.gif";

      // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      // Additional HTML sources:

      prefixHTML = "";
      suffixHTML = "";
}

